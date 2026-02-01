---
title: Color wells
description: A color well lets people adjust the color of text, shapes, guides, and other onscreen elements.
source: https://developer.apple.com/design/human-interface-guidelines/color-wells
timestamp: 2026-02-01T17:08:21.171Z
---

**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# Color wells

> A color well lets people adjust the color of text, shapes, guides, and other onscreen elements.



A color well displays a color picker when people tap or click it. This color picker can be the system-provided one or a custom interface that you design.

## Best practices

**Consider the system-provided color picker for a familiar experience.** Using the built-in color picker provides a consistent experience, in addition to letting people save a set of colors they can access from any app. The system-defined color picker can also help provide a familiar experience when developing apps across iOS, iPadOS, and macOS.

## Platform considerations

*No additional considerations for iOS, iPadOS, or visionOS. Not supported in tvOS or watchOS.*

### macOS

When people click a color well, it receives a highlight to provide visual confirmation that it’s active. It then opens a color picker so people can choose a color. After they make a selection, the color well updates to show the new color.

Color wells also support drag and drop, so people can drag colors from one color well to another, and from the color picker to a color well.

## Resources

#### Related

[Color](/design/human-interface-guidelines/color)

#### Developer documentation

[UIColorWell](/documentation/UIKit/UIColorWell) — UIKit

[UIColorPickerViewController](/documentation/UIKit/UIColorPickerViewController) — UIKit

[NSColorWell](/documentation/AppKit/NSColorWell) — AppKit

[Color Programming Topics](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/DrawColor/DrawColor.html)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
