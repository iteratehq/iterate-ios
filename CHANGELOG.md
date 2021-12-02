# Change Log

All notable changes to this project will be documented in this file.
`iterate-ios` adheres to [Semantic Versioning](https://semver.org/).

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
