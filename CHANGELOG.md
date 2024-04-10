# Change Log

All notable changes to this project will be documented in this file.
`iterate-ios` adheres to [Semantic Versioning](https://semver.org/).

## [1.3.3](https://github.com/iteratehq/iterate-ios/releases/tag/v1.3.3)

Released 2024-04-10.

**Added**

- Dismiss survey on app background

## [1.3.2](https://github.com/iteratehq/iterate-ios/releases/tag/v1.3.2)

Released 2024-04-09.

**Fixed**

- Fixed prompt background color in dark mode

## [1.3.1](https://github.com/iteratehq/iterate-ios/releases/tag/v1.3.1)

Released 2024-02-05.

**Fixed**

- Fixed missing dependency in Package.swift

## [1.3.0](https://github.com/iteratehq/iterate-ios/releases/tag/v1.3.0)

Released 2024-01-16.

**Added**

- Added support for Markdown in the prompt

## [1.2.1](https://github.com/iteratehq/iterate-ios/releases/tag/v1.2.1)

Released 2023-09-20.

**Fixed**

- Fixed an issue causing surveys without a dark mode color specified from showing up

## [1.2.0](https://github.com/iteratehq/iterate-ios/releases/tag/v1.2.0)

Released 2023-06-07.

**Added**

- Added support for dark mode

## [1.1.0](https://github.com/iteratehq/iterate-ios/releases/tag/v1.1.0)

Released 2023-05-22.

**Added**

- Added support for date types in user and response properties

## [1.0.12](https://github.com/iteratehq/iterate-ios/releases/tag/v1.0.12)

Released 2023-02-15.

**Fixed**

- Fixed response properties not being sent in versions 1.0.9-1.0.11
- Fixed response and user properties not available in mustache templates in 1.0.9-1.0.11

## [1.0.11](https://github.com/iteratehq/iterate-ios/releases/tag/1.0.11)

Released 2023-01-16.

**Added**

- Added support for Swift Package Manager (SPM) (thank you [@MadGeorge](https://github.com/MadGeorge)!)

**Changed**

- The target name has changed to `Iterate` (formerly `import IterateSDK`)

## [1.0.10](https://github.com/iteratehq/iterate-ios/releases/tag/v1.0.10)

Released 2022-10-03.

**Fixed**

- Fixed a Main Thread Checker warning when opening the survey view

## [1.0.9](https://github.com/iteratehq/iterate-ios/releases/tag/v1.0.9)

Released on 2022-09-15.

**Fixed**

- Restored custom font support
- Fixed an issue that prevented external links in survey copy from opening

## [1.0.8](https://github.com/iteratehq/iterate-ios/releases/tag/v1.0.8)

Released on 2022-08-11.

**Fixed**

- Reverted the previous update with custom fonts support due to a related bug, which will be fixed in the next minor version

## [1.0.7](https://github.com/iteratehq/iterate-ios/releases/tag/v1.0.7)

Released on 2022-08-02.

**Added**

- Added support for custom fonts in survey UI

## [1.0.6](https://github.com/iteratehq/iterate-ios/releases/tag/v1.0.6)

Released on 2021-12-01.

**Added**

- Added `Iterate.shared.reset()` method to clear the current user. SHould be used when a user logs out

## [1.0.5](https://github.com/iteratehq/iterate-ios/releases/tag/v1.0.5)

Release on 2020-11-15.

**Fixed**

- Added 'last updated at' timestamp to ensure we don't count a user as an 'active user' more than once per month

## [1.0.4](https://github.com/iteratehq/iterate-ios/releases/tag/v1.0.4)

Release on 2020-10-29.

**Fixed**

- Fixed an issue that caused the survey view to be reloaded unexpectedly

## [1.0.3](https://github.com/iteratehq/iterate-ios/releases/tag/v1.0.3)

Released on 2020-10-15.

**Fixed**

- Override interface style until the full survey interface properly supports dark mode

## [1.0.2](https://github.com/iteratehq/iterate-ios/releases/tag/v1.0.2)

Released on 2020-09-28.

**Fixed**

- Display the survey on the correct window on iOS 14.2

## [1.0.1](https://github.com/iteratehq/iterate-ios/releases/tag/v1.0.1)

Released on 2020-09-25.

**Fixed**

- Prevent a survey from re-presenting if a survey is already presented

## [1.0.0](https://github.com/iteratehq/iterate-ios/releases/tag/v1.0.0)

Released on 2020-07-28.

**Added**

- Added [Identify](https://github.com/iteratehq/iterate-ios/wiki/Iterate#identifyuserproperties) methods to associate data with users and their responses
- Added [Preview](https://github.com/iteratehq/iterate-ios/wiki/Iterate#previewsurveyid) method to force a survey to show up while testing
- Swift binary compatility to automatically support future Swift 5.\* versions

**Fixed**

- Moved API key storage from UserDefaults to Keychain

## [0.1.1](https://github.com/iteratehq/iterate-ios/releases/tag/v0.1.1)

Released on 2020-06-27.

**Added**

- Support for cocoapods & carthage

**Fixed**

- UI fixes for notched devices

## [0.1.0](https://github.com/iteratehq/iterate-ios/releases/tag/v0.1.0)

Released on 2020-06-24.

**Added**

- Initial release of iterate-ios.
