---
title: ResearchKit
description: A research app lets people everywhere participate in important medical research studies.
source: https://developer.apple.com/design/human-interface-guidelines/researchkit
timestamp: 2026-02-01T17:08:23.379Z
---

**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# ResearchKit

> A research app lets people everywhere participate in important medical research studies.



The ResearchKit framework provides predesigned screens and transitions that make it easy to design and build an engaging custom research app. For developer guidance, see [Research & Care > ResearchKit](https://www.researchandcare.org/researchkit/).

## Creating the onboarding experience

When opening a research app for the first time, people encounter a series of screens that introduce them to the study, determine their eligibility to participate, request permission to proceed with the study, and, when appropriate, grant access to personal data. These screens aren’t typically revisited once they’ve been completed, so clarity is essential.

**Always display the onboarding screens in the correct order.**



### 1. Introduction

**Provide an introduction that informs and provides a call to action.** Clearly describe the subject and purpose of your study. Also allow existing participants to quickly log in and continue an in-progress study.



### 2. Determine eligibility

**Determine eligibility as soon as possible.** People don’t need to move on to the consent section if they’re not eligible for the study. Only present eligibility requirements that are necessary for your study. Use simple, straightforward language that describes the requirements, and make it easy to enter information.



### 3. Get informed consent

**Make sure participants understand your study before you get their consent.** ResearchKit helps you make the consent process concise and friendly, while still allowing you to incorporate into the consent any legal requirements or requirements set by an institutional review board or ethics review board. Make sure that your app complies with the applicable App Store Guidelines, including the consent requirements. Typically, the consent section explains how the study works, ensures that participants understand the study and their responsibilities, and gets the participant’s consent.

**Break a long consent form into easily digestible sections.** Each section can cover one aspect of the study, such as data gathering, data use, potential benefits, possible risks, time commitment, how to withdraw, and so on. For each section, use simple, straightforward language to provide a high-level overview. If necessary, provide a more detailed explanation of the section that participants can read by tapping a Learn More button. Participants need to be able to view the entire consent form before they agree to participate.

**If it makes sense, provide a quiz that tests the participant’s understanding.** You might do this for questions the participant would otherwise be asked when obtaining consent in person.



**Get the participant’s consent and, if appropriate, some contact information.** After agreeing to join the study, participants receive a confirmation dialog, followed by screens in which they provide their signature and contact details. Most research apps email participants a PDF version of the consent form for their records.



### 4. Request permission to access data

**Get permission to access the participant’s device or data, and to send notifications.** Clearly explain why your research app needs access to location, Health, or other data, and don’t request access to data that isn’t critical to your study. If your app requires it, also ask for permission to send notifications to the participant’s device.



## Conducting research

To get input from participants, your study might use surveys, active tasks, or a combination of both. Depending on the architecture of your study, participants may interact with each section multiple times or only once.

**Create surveys that keep participants engaged.** ResearchKit provides many customizable screens you can use in your surveys, and makes it easy to present questions that require different types of answers, such as true or false, multiple choice, dates and times, sliding scales, and open-ended text entry. As you use ResearchKit screens to design a survey, follow these guidelines to provide a great experience:

- Tell participants how many questions there are and about how long the survey will take.
- Use one screen per question.
- Show participants their progress in the survey.
- Keep the survey as short as possible. Several short surveys tend to work better than one long survey.
- For questions that require some additional explanation, use the standard font for the question and a slightly smaller font for the explanatory text.
- Tell participants when the survey is complete.



**Make active tasks easy to understand.** An active task requires the participant to engage in an activity, such as speaking into the microphone, tapping fingers on the screen, walking, or performing a memory test. Follow these guidelines to encourage participants to perform an active task and give them the best chance of success:

- Describe how to perform the task using clear, simple language.
- Explain any requirements, such as if the task must be performed at a particular time or under specific circumstances.
- Make sure participants can tell when the task is complete.



## Managing personal information and providing encouragement

ResearchKit offers a profile screen you can use to let participants manage personal information while they’re in your research app. It’s also a good idea to design a custom screen that motivates people and gives them a way to track progress in the study. Ideally, both screens are accessible at all times in your app.

**Use a profile to help participants manage personal data related to your study.** A profile screen can let people edit data that might change during the course of the study — such as weight or sleep habits — and remind them of upcoming activities. A profile screen can also provide an easy way to leave a study and view important information, such as the consent document and privacy policy.



**Use a dashboard to show progress and motivate participants to continue.** If appropriate for your study, use a dashboard to provide encouraging feedback, such as daily progress, weekly assessments, results from specific activities, and even results that compare the participant’s results with aggregated results from others in the study.



## Platform considerations

*No additional considerations for iOS or iPadOS. Not supported in macOS, tvOS, visionOS, or watchOS.*

## Resources

#### Related

[Research & Care > ResearchKit](https://www.researchandcare.org/researchkit/)

#### Developer documentation

[Research & Care > Developers](https://www.researchandcare.org/developers/)

[Protecting user privacy](/documentation/HealthKit/protecting-user-privacy) — HealthKit

[ResearchKit GitHub project](https://github.com/ResearchKit/ResearchKit)

#### Videos

- [What's new in CareKit](https://developer.apple.com/videos/play/wwdc2020/10151) - Build feature-rich research and care apps with CareKit: Learn about the latest advancements to our health framework, including new views for its modular architecture, improvements to the data store, and tighter integration with other frameworks on iOS. And discover how the open-source community continues to leverage CareKit to allow developers to push the boundaries of digital health&nbsp;—&nbsp;all while preserving privacy.
- [Build a research and care app, part 1: Setup onboarding](https://developer.apple.com/videos/play/wwdc2021/10068) - Learn how ResearchKit and CareKit can work together to take the tedium out of paper surveys. Code along with us and build a working care pilot app. Explore best practices for onboarding and consent with ResearchKit, and find out how your app can require participants to sign consent documents by leveraging CareKit’s store and UI components.

This is the first session in a three-part Code-Along series. To get the most out of this series, we recommend that you have some basic familiarity with both ResearchKit and CareKit. For more background, watch "ResearchKit and CareKit Reimagined” from WWDC19.
- [ResearchKit and CareKit Reimagined](https://developer.apple.com/videos/play/wwdc2019/217) - The ResearchKit and CareKit frameworks are the fastest route to delivering powerful native iOS apps for the research and patient care field.  Learn about the newest audio and speech active-tasks, a completely redesigned user experience, and modular architecture designed to make it a breeze to create care plan apps for any use case.

## Change log

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
