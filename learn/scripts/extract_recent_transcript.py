#!/usr/bin/env python3
"""
Resolve the active Codex session UUID and rollout JSONL path.
Verbose diagnostics go to stderr; stdout is JSON.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
from pathlib import Path

LOG_PREFIX = "[learn]"
UUID_RE = re.compile(r"rollout-.*-([0-9a-fA-F-]{36})\.jsonl$")


def log(message: str) -> None:
    print(f"{LOG_PREFIX} {message}", file=sys.stderr)


def run(cmd: list[str]) -> tuple[int, str, str]:
    proc = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    return proc.returncode, proc.stdout, proc.stderr


def get_self_tty() -> str:
    rc, out, _ = run(["ps", "-p", str(os.getpid()), "-o", "tty="])
    if rc == 0:
        tty = out.strip().replace(" ", "")
        if tty:
            return tty
    rc, out, _ = run(["tty"])
    if rc == 0:
        tty = out.strip()
        if tty.startswith("/dev/"):
            return tty[len("/dev/") :]
    return ""


def ps_command(pid: str) -> str:
    rc, out, _ = run(["ps", "-p", pid, "-o", "command="])
    return out.strip() if rc == 0 else ""


def ps_ppid(pid: str) -> str:
    rc, out, _ = run(["ps", "-p", pid, "-o", "ppid="])
    return out.strip() if rc == 0 else ""


def is_codex_command(cmd: str) -> bool:
    parts = cmd.strip().split()
    if not parts:
        return False
    exe = os.path.basename(parts[0])
    return exe == "codex"


def find_candidate_pids(self_pid: str, self_tty: str) -> list[str]:
    candidates: set[str] = set()

    # Walk ancestor chain
    pid = self_pid
    while True:
        cmd = ps_command(pid)
        if cmd:
            log(f"ancestor pid={pid} cmd={cmd}")
            if is_codex_command(cmd):
                candidates.add(pid)
        ppid = ps_ppid(pid)
        if not ppid or ppid == pid or pid == "1":
            break
        pid = ppid

    if candidates:
        return sorted(candidates)

    # Fallback: scan process list
    log("no codex ancestor found; scanning process list")
    rc, out, err = run(["ps", "-axo", "pid=,tty=,command="])
    if rc != 0:
        log(f"ERROR: failed to list processes: {err.strip()}")
        return []

    for line in out.splitlines():
        parts = line.strip().split(None, 2)
        if len(parts) < 3:
            continue
        pid, tty, cmd = parts
        if not is_codex_command(cmd):
            continue
        if self_tty and tty != self_tty:
            continue
        candidates.add(pid)

    return sorted(candidates)


def lsof_paths(pid: str) -> list[str]:
    rc, out, err = run(["lsof", "-p", pid])
    if rc != 0:
        log(f"ERROR: lsof failed for pid={pid}: {err.strip()}")
        return []
    paths: list[str] = []
    for line in out.splitlines()[1:]:
        parts = line.split()
        if not parts:
            continue
        path = parts[-1]
        if "/.codex/sessions/" in path and path.endswith(".jsonl") and "rollout-" in path:
            paths.append(path)
    return paths


def lsof_cwd(pid: str) -> str:
    rc, out, _ = run(["lsof", "-a", "-p", pid, "-d", "cwd"])
    if rc != 0:
        return ""
    lines = out.splitlines()
    if len(lines) < 2:
        return ""
    return lines[1].split()[-1]


def resolve_rollout_path(session_id: str | None, rollout_path: str | None) -> tuple[str, str]:
    if rollout_path:
        return rollout_path, extract_uuid(rollout_path)

    if session_id:
        root = Path.home() / ".codex" / "sessions"
        matches = list(root.rglob(f"*{session_id}.jsonl"))
        if not matches:
            raise RuntimeError(f"no rollout file found for session_id={session_id}")
        if len(matches) > 1:
            raise RuntimeError(f"multiple rollout files found for session_id={session_id}: {len(matches)}")
        return str(matches[0]), session_id

    if not shutil_which("lsof"):
        raise RuntimeError("lsof not found; cannot inspect open files")

    self_pid = str(os.getpid())
    self_tty = get_self_tty()
    log(f"self pid={self_pid} tty={self_tty or '<none>'} cwd={os.getcwd()}")

    candidates = find_candidate_pids(self_pid, self_tty)
    if not candidates:
        raise RuntimeError("no codex processes found")
    log(f"candidate codex pids: {' '.join(candidates)}")

    matches: list[tuple[str, str, str, str]] = []
    for pid in candidates:
        cmd = ps_command(pid)
        cwd = lsof_cwd(pid)
        log(f"inspect pid={pid} cmd={cmd or '<unknown>'} cwd={cwd or '<unknown>'}")
        for path in lsof_paths(pid):
            uuid = extract_uuid(path)
            if not uuid:
                log(f"pid={pid} rollout path did not match UUID pattern: {path}")
                continue
            log(f"pid={pid} rollout={path} uuid={uuid}")
            matches.append((pid, uuid, path, cwd))

    if not matches:
        raise RuntimeError("no rollout files detected for candidate processes")

    unique_uuids = sorted({m[1] for m in matches})
    if len(unique_uuids) == 1:
        uuid = unique_uuids[0]
        path = next(m[2] for m in matches if m[1] == uuid)
        return path, uuid

    # Try to disambiguate by cwd
    cwd = os.getcwd()
    matches_cwd = [m for m in matches if m[3] == cwd]
    unique_cwd_uuids = sorted({m[1] for m in matches_cwd})
    if len(unique_cwd_uuids) == 1:
        uuid = unique_cwd_uuids[0]
        path = next(m[2] for m in matches_cwd if m[1] == uuid)
        return path, uuid

    # Fall back to error with diagnostics
    lines = ["pid|uuid|path|cwd"] + ["|".join(m) for m in matches]
    raise RuntimeError("multiple candidate sessions found:\n" + "\n".join(lines))


def extract_uuid(path: str) -> str:
    match = UUID_RE.search(path)
    return match.group(1) if match else ""


def shutil_which(cmd: str) -> bool:
    rc, _, _ = run(["/usr/bin/env", "which", cmd])
    return rc == 0


def find_repo_root(start: Path) -> Path | None:
    current = start.resolve()
    for path in [current, *current.parents]:
        if (path / ".git").is_dir() or (path / ".sl").is_dir():
            return path
    return None


def find_agents_candidates(cwd: Path) -> tuple[list[str], list[str]]:
    candidates: list[str] = []
    suggestions: list[str] = []

    repo_root = find_repo_root(cwd)

    for path in [cwd, *cwd.parents]:
        agents = path / "AGENTS.md"
        if agents.is_file():
            candidates.append(str(agents))
        if repo_root and path == repo_root:
            break
        if not repo_root and str(path) == str(cwd.anchor):
            break

    home_agents = Path.home() / ".codex" / "AGENTS.md"
    if home_agents.is_file():
        candidates.append(str(home_agents))

    suggestions.append(str(cwd / "AGENTS.md"))
    if repo_root:
        suggestions.append(str(repo_root / "AGENTS.md"))
    suggestions.append(str(home_agents))

    # Deduplicate while preserving order
    seen: set[str] = set()
    candidates = [p for p in candidates if not (p in seen or seen.add(p))]
    seen.clear()
    suggestions = [p for p in suggestions if not (p in seen or seen.add(p))]

    return candidates, suggestions


def main() -> int:
    parser = argparse.ArgumentParser(description="Resolve active Codex session UUID and rollout path.")
    parser.add_argument("--session-id", type=str, default="", help="Explicit session UUID to load.")
    parser.add_argument("--rollout-path", type=str, default="", help="Explicit rollout JSONL path.")
    args = parser.parse_args()

    session_id = args.session_id.strip() or None
    rollout_path = args.rollout_path.strip() or None

    try:
        resolved_path, resolved_uuid = resolve_rollout_path(session_id, rollout_path)
    except Exception as exc:
        log(f"ERROR: {exc}")
        return 1

    if not resolved_path or not os.path.exists(resolved_path):
        log(f"ERROR: rollout path not found: {resolved_path}")
        return 1

    agents_candidates, agents_suggestions = find_agents_candidates(Path(os.getcwd()))

    payload = {
        "session_id": resolved_uuid,
        "rollout_path": resolved_path,
        "cwd": os.getcwd(),
        "agents_candidates": agents_candidates,
        "agents_suggestions": agents_suggestions,
    }

    print(json.dumps(payload, indent=2, ensure_ascii=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
