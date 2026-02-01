---
title: Web views
description: A web view loads and displays rich web content, such as embedded HTML and websites, directly within your app.
source: https://developer.apple.com/design/human-interface-guidelines/web-views
timestamp: 2026-02-01T17:08:19.588Z
---

**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# Web views

> A web view loads and displays rich web content, such as embedded HTML and websites, directly within your app.



For example, Mail uses a web view to show HTML content in messages.

## Best practices

**Support forward and back navigation when appropriate.** Web views support forward and back navigation, but this behavior isn’t available by default. If people are likely to use your web view to visit multiple pages, allow forward and back navigation, and provide corresponding controls to initiate these features.

**Avoid using a web view to build a web browser.** Using a web view to let people briefly access a website without leaving the context of your app is fine, but Safari is the primary way people browse the web. Attempting to replicate the functionality of Safari in your app is unnecessary and discouraged.

## Platform considerations

*No additional considerations for iOS, iPadOS, macOS, or visionOS. Not supported in tvOS or watchOS.*

## Resources

#### Related

[Webkit.org](https://webkit.org/)

#### Developer documentation

[WKWebView](/documentation/WebKit/WKWebView) — WebKit

#### Videos

- [Explore WKWebView additions](https://developer.apple.com/videos/play/wwdc2021/10032) - Explore the latest updates to WKWebView. We’ll show you how to use APIs to manipulate web content without JavaScript, explore delegates that can help with WebRTC and Downloads, and share how you can easily create a richer web experience within your app.

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
