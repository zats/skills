---
title: Keyboards
description: A physical keyboard can be an essential input device for entering text, playing games, controlling apps, and more.
source: https://developer.apple.com/design/human-interface-guidelines/keyboards
timestamp: 2026-02-01T17:08:22.324Z
---

**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# Keyboards

> A physical keyboard can be an essential input device for entering text, playing games, controlling apps, and more.



People can connect a physical keyboard to any device except Apple Watch. Mac users tend to use a physical keyboard all the time and iPad users often do. Many games work well with a physical keyboard, and people can prefer using one instead of a [Virtual keyboards](/design/human-interface-guidelines/virtual-keyboards) when entering a lot of text.

Keyboard users often appreciate using keyboard shortcuts to speed up their interactions with apps and games. A *keyboard shortcut* is a combination of a primary key and one or more modifier keys (Control, Option, Shift, and Command) that map to a specific command. A keyboard shortcut in a game — called a *key binding* — often consists of a single key.

Apple defines standard keyboard shortcuts to work consistently across the system and most apps, helping people transfer their knowledge to new experiences. Some apps define custom keyboard shortcuts for the app-specific commands people use most; most games define custom key bindings that make it quick and efficient to use the keyboard to control the game. For guidance, see [Keyboards](/design/human-interface-guidelines/game-controls#Keyboards).

## Best practices

**Support Full Keyboard Access when possible.** Available in iOS, iPadOS, macOS, and visionOS, Full Keyboard Access lets people navigate and activate windows, menus, controls, and system features using only the keyboard. To test Full Keyboard Access in your app or game, turn it on in the Accessibility area of the system-supplied Settings app. For developer guidance, see [Support Full Keyboard Access in your iOS app](https://developer.apple.com/videos/play/wwdc2021/10120/) and [isFullKeyboardAccessEnabled](/documentation/AppKit/NSApplication/isFullKeyboardAccessEnabled).

**Respect standard keyboard shortcuts.** While using most apps, people generally expect to rely on the standard keyboard shortcuts that work in other apps and throughout the system. If your app offers a unique action that people perform frequently, prefer creating a [Custom keyboard shortcuts](/design/human-interface-guidelines/keyboards#Custom-keyboard-shortcuts) shortcut for it instead of repurposing a standard one that people associate with a different action. While playing a game, people may expect to use certain standard keyboard shortcuts — such as Command–Q to quit the game — but they also expect to be able to modify each game’s key bindings to fit their personal play style. For guidance, see [Keyboards](/design/human-interface-guidelines/game-controls#Keyboards).

## Standard keyboard shortcuts

**In general, don’t repurpose standard keyboard shortcuts for custom actions.** People can get confused when the shortcuts they know work differently in your app or game. Only consider redefining a standard shortcut if its action doesn’t make sense in your experience. For example, if your app doesn’t support text editing, it doesn’t need a text-styling command like Italic, so you might repurpose Command–I for an action that has more relevance, like Get Info.

People expect each of the following standard keyboard shortcuts to perform the action listed in the table below.

The system also defines several keyboard shortcuts for use with localized versions of the system, localized keyboards, keyboard layouts, and input methods. These shortcuts don’t correspond directly to menu commands.

## Custom keyboard shortcuts

**Define custom keyboard shortcuts for only the most frequently used app-specific commands.** People appreciate using keyboard shortcuts for actions they perform frequently, but defining too many new shortcuts can make your app seem difficult to learn.

**Use modifier keys in ways that people expect.** For example, pressing Command while dragging moves items as a group, and pressing Shift while drag-resizing constrains resizing to the item’s aspect ratio. In addition, holding an arrow key moves the selected item by the smallest app-defined unit of distance until people release the key.

Here are the modifier keys and the symbols that represent them.

**List modifier keys in the correct order.** If you use more than one modifier key in a custom shortcut, always list them in this order: Control, Option, Shift, Command.

**Avoid adding Shift to a shortcut that uses the upper character of a two-character key.** People already understand that they must hold the Shift key to type the upper character of a two-character key, so it’s clearer to simply list the upper character in the shortcut. For example, the keyboard shortcut for Hide Status Bar is Command-Slash, whereas the keyboard shortcut for Help is Command-Question mark, not Shift-Command-Slash.

**Let the system localize and mirror your keyboard shortcuts as needed.** The system automatically localizes a shortcut’s primary and modifier keys to support the currently connected keyboard; if your app or game switches to a right-to-left layout, the system automatically mirrors the shortcut. For guidance, see [Right to left](/design/human-interface-guidelines/right-to-left).

**Avoid creating a new shortcut by adding a modifier to an existing shortcut for an unrelated command.** For example, because people are accustomed to using Command-Z for undoing an action, it would be confusing to use Shift-Command-Z as the shortcut for a command that’s unrelated to undo and redo.

## Platform considerations

*No additional considerations for iOS, iPadOS, macOS, or tvOS. Not supported in watchOS.*

### visionOS

In visionOS, an app’s keyboard shortcuts appear in the shortcut interface that displays when people hold the Command key on a connected keyboard. Similar in organization to an app’s [The menu bar](/design/human-interface-guidelines/the-menu-bar) on iPad or Mac, the shortcut interface on Apple Vision Pro displays app commands in familiar system-defined menu categories such as File, Edit, and View. Unlike menu bar menus, the shortcut interface displays all relevant categories in one view, listing within each category only available commands that also have shortcuts.

**Write descriptive shortcut titles.** Because the shortcut interface displays a flat list of all items in each category, submenu titles aren’t available to provide context for their child items. Make sure each shortcut title is descriptive enough to convey its action without the additional context a submenu title might provide. For developer guidance, see [discoverabilityTitle](/documentation/UIKit/UIKeyCommand/discoverabilityTitle).

**Recognize that people see an overlay when they use a physical keyboard with your visionOS app or game.** When people connect a physical keyboard while using your visionOS app or game, the system displays a virtual keyboard overlay that provides typing completion and other controls.

## Resources

#### Related

[Virtual keyboards](/design/human-interface-guidelines/virtual-keyboards)

[Entering data](/design/human-interface-guidelines/entering-data)

[Pointing devices](/design/human-interface-guidelines/pointing-devices)

#### Developer documentation

[KeyboardShortcut](/documentation/SwiftUI/KeyboardShortcut) — SwiftUI

[Input events](/documentation/SwiftUI/Input-events) — SwiftUI

[Handling key presses made on a physical keyboard](/documentation/UIKit/handling-key-presses-made-on-a-physical-keyboard) — UIKit

[Mouse, Keyboard, and Trackpad](/documentation/AppKit/mouse-keyboard-and-trackpad) — AppKit

## Change log

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
