![Iterate for iOS](https://github.com/iteratehq/iterate-ios/blob/master/Assets/static-banner.png?raw=true)

# Iterate for iOS

[![build](https://img.shields.io/travis/com/iteratehq/iterate-ios)](https://travis-ci.com/github/iteratehq/iterate-ios) [![version](https://img.shields.io/codeclimate/maintainability/iteratehq/iterate-ios)](https://codeclimate.com/github/iteratehq/iterate-ios) [![version](https://img.shields.io/github/v/tag/iteratehq/iterate-ios?label=version)](https://github.com/iteratehq/iterate-ios/releases) [![CocoaPod](https://img.shields.io/cocoapods/v/Iterate)](https://cocoapods.org/pods/Iterate) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![license](https://img.shields.io/github/license/iteratehq/iterate-ios?color=%23000000)](https://github.com/iteratehq/iterate-ios/blob/master/LICENSE.txt)

---

Iterate surveys put you directly in touch with your app users to learn how you can change for the better—from your product to your app experience.

Run surveys that are highly targeted, user-friendly, and on-brand. You’ll understand not just what your visitors are doing, but why.

## Requirements

✅ iOS 12 or higher  
✅ Works with iPhone or iPad  
✅ Swift 4.2 or higher  
👌 No 3rd party dependencies

## Install

**CocoaPods**

You can install Iterate using the [CocoaPods](http://cocoapods.org/) dependency manager by installing CocoaPods and adding the following to your Podfile:

```ruby
pod 'Iterate', '~> 0.1'
```

Then run

```bash
$ pod install 
```

**Carthage**

You can install Iterate using the [Carthage](https://github.com/Carthage/Carthage) dependency manager by installing Carthage and adding the following to your Cartfile:

```text
github "iteratehq/iterate-ios" ~> 0.1
```

Then run

```bash
$ carthage update
```

and follow the Carthage [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos) to copy the framework into your app. 


## Usage

Within your app surveys are shown in response to _events_. An event can be anything from viewing a screen, clicking a button, or any other user action. You use the Iterate SDK to send events to Iterate, then from your Iterate dashboard you create surveys that target those events.

**Quickstart**

Creating your [Iterate](https://iteratehq.com) account if you haven't already, then go into your settings and copy your API key.

1. Initialize the SDK in your AppDelegate class

```swift
import Iterate

class AppDelegate: UIResponder, UIApplicationDelegate {

    // ...

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Iterate.shared.configure(apiKey: YOUR_API_KEY)
    }

    // ...

}
```

2. Implement events

Here's an example of an event being fired when the user views the activity feed screen

```swift
import Iterate

class ViewController: UIViewController {

  // ...

   override func viewDidAppear(_ animated: Bool) {
       Iterate.shared.sendEvent(name: "viewed-activity-feed")
   }

   // ...

}
```

3. Create your survey on iteratehq.com and target it to that event

<img src="https://github.com/iteratehq/iterate-ios/blob/master/Assets/event-targeting.png?raw=true" width="500">

4. Publish your survey and you're done 🎉

**Previewing your survey**

You'll likely want to preview your survey before publishing it so you can test it out and confirm everything is working correctly. To enable previewing you'll need to have a [custom URL scheme](https://developer.apple.com/documentation/uikit/inter-process_communication/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app) for you app and add the following code when your app is opened from your app's URL scheme.

The `Iterate.shared.preview(url:)` method looks for the query parameter `?iterate_preview=YOUR_SURVEY_ID` which enables _preview mode_ allowing you to see the survey in response to your targeted event being fired, but before it's published for everyone.

If you're using scenes add the following code to your SceneDelegate

```swift
import Iterate

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  // ...

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
      for context in URLContexts {
          if context.url.absoluteString.contains(Iterate.PreviewParameter) {
              Iterate.shared.preview(url: context.url.absoluteURL)
          }
      }
  }

  // ...
}
```

otherwise add it to your AppDelegate

```swift
import Iterate

class AppDelegate: UIResponder, UIApplicationDelegate {

    // ...

    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:] ) -> Bool {
        if url.absoluteString.contains(Iterate.PreviewParameter) {
            Iterate.shared.preview(url: url.absoluteURL)
        }
    }

    // ...

}
```

Once that's added you can scan the QR code on the "Preview & Publish" tab of your survey which will open your app allowing you to preview the survey once the event you're targeting has fired.

**Recommendations**

When implementing Iterate for the first time, we encurage you to implement events for _all_ of your core use cases which you may want to target surveys to in the future. e.g. signup, puchased, viewed X screen, tapped notification, etc. This way you can easily launch new surveys targeting these events without needing to instrument a new event each time.

**Survey eligibility and frequency**

By default surveys are only shown once per person and user's can only see at most 1 survey every 72 hours (which is configurable). You can learn more about how [eligibility and frequency works](https://help.iteratehq.com/en/articles/2835008-survey-eligibility-and-frequency).
