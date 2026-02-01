---
title: Dock menus
description: On a Mac, people can secondary click an app’s or game’s icon in the Dock to reveal a Dock menu, which presents both system-provided and custom items.
source: https://developer.apple.com/design/human-interface-guidelines/dock-menus
timestamp: 2026-02-01T17:08:20.326Z
---

**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# Dock menus

> On a Mac, people can secondary click an app’s or game’s icon in the Dock to reveal a Dock menu, which presents both system-provided and custom items.



The system-provided Dock menu items can vary depending on whether the app is open. For example, the Dock menu for Safari includes menu items for actions like viewing a current window or creating a new window.

## Best practices

As with all menus, you need to label Dock menu items succinctly and organize them logically. For guidance, see [Menus](/design/human-interface-guidelines/menus).

**Make custom Dock menu items available in other places, too.** Not everyone uses a Dock menu, so it’s important to offer the same commands elsewhere, like in your menu bar menus or within your interface.

**Prefer high-value custom items for your Dock menu.** For example, a Dock menu can list all currently or recently open windows, making it a convenient way to jump to the window people want. Also consider listing a few of the actions that are most likely to be useful when your app isn’t frontmost or when there are no open windows. For example, Mail includes items for getting new mail and composing a new message in addition to listing all open windows.

## Platform considerations

*Not supported in iOS, iPadOS, tvOS, visionOS, or watchOS.*

## Resources

#### Related

[Menus](/design/human-interface-guidelines/menus)

[Home Screen quick actions](/design/human-interface-guidelines/home-screen-quick-actions)

#### Developer documentation

[applicationDockMenu(_:)](/documentation/AppKit/NSApplicationDelegate/applicationDockMenu(_:)) — AppKit

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
