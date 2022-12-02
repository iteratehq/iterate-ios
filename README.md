![Iterate for iOS](https://github.com/iteratehq/iterate-ios/blob/master/Assets/static-banner.png?raw=true)

# Iterate for iOS

[![build](https://img.shields.io/travis/com/iteratehq/iterate-ios)](https://travis-ci.com/github/iteratehq/iterate-ios) [![version](https://img.shields.io/codeclimate/maintainability/iteratehq/iterate-ios)](https://codeclimate.com/github/iteratehq/iterate-ios) [![version](https://img.shields.io/github/v/tag/iteratehq/iterate-ios?label=version)](https://github.com/iteratehq/iterate-ios/releases) [![CocoaPod](https://img.shields.io/cocoapods/v/Iterate)](https://cocoapods.org/pods/Iterate) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![license](https://img.shields.io/github/license/iteratehq/iterate-ios?color=%23000000)](https://github.com/iteratehq/iterate-ios/blob/master/LICENSE.txt)

---

[Iterate](https://iteratehq.com) surveys put you directly in touch with your app users to learn how you can change for the better—from your product to your app experience.

Run surveys that are highly targeted, user-friendly, and on-brand. You’ll understand not just what your visitors are doing, but why.

## Requirements

✅ iOS 12 or higher  
✅ Works with iPhone or iPad  
✅ Swift 4.2 or higher  
👍 No 3rd party dependencies

## Install

**CocoaPods**

You can install Iterate using the [CocoaPods](http://cocoapods.org/) dependency manager by installing CocoaPods and adding the following to your Podfile:

```ruby
pod 'Iterate', '~> 1.0'
```

Then run

```bash
$ pod install
```

**Carthage**

You can install Iterate using the [Carthage](https://github.com/Carthage/Carthage) dependency manager by installing Carthage and adding the following to your Cartfile:

```text
github "iteratehq/iterate-ios" ~> 1.0
```

Then run

```bash
$ carthage update
```

and follow the Carthage [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos) to copy the framework into your app.

**Swift Package Manager (SPM)**

- Xcode -> Project -> Package Dependencies -> Click "+"    
- Paste "https://github.com/iteratehq/iterate-ios" into search bar
- Specify versioning rules and select project to add library
- Press "Add Package"

## Usage

Within your app, surveys are shown in response to _events_. An event can be anything from viewing a screen, clicking a button, or any other user action. You use the Iterate SDK to send events to Iterate, then from your Iterate dashboard you create surveys that target those events.

**Quickstart**

Log in to or Sign up for an [Iterate](https://iteratehq.com) account if you haven't already.

1. Create a new survey and select "Install in your mobile app"

<img src="https://github.com/iteratehq/iterate-ios/raw/master/Assets/new-survey.png" width="800">

<br/>

2. Go to the "Preview & Publish" tab and copy your SDK API key

<img src="https://github.com/iteratehq/iterate-ios/raw/master/Assets/publish.png" width="500">

<br/>

3. Initialize the SDK in your AppDelegate class

```swift
import IterateSDK

class AppDelegate: UIResponder, UIApplicationDelegate {

    // ...

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Iterate.shared.configure(apiKey: YOUR_API_KEY)
        return true
    }

    // ...

}
```

If you're using SwiftUI, you can attach your App to an AppDelegate and initialize using the method above

```swift
@main
struct MyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Iterate.shared.configure(apiKey: YOUR_API_KEY)
        return true
    }
}
```

4. Implement events

Here's an example of an event being fired when the user views the activity feed screen

```swift
import IterateSDK

class ViewController: UIViewController {

  // ...

   override func viewDidAppear(_ animated: Bool) {
       Iterate.shared.sendEvent(name: "viewed-activity-feed")
   }

   // ...

}
```

Here's the same example using SwiftUI

```swift
struct ActivityFeed: View {
    var body: some View {
        NavigationView {
            VStack {
                // ...
            }
        }.onAppear {
            Iterate.shared.sendEvent(name: "viewed-activity-feed")
        }
    }
}
```

5. On the Targeting options tab of your Iterate survey, set the survey to show when that event is triggered

<img src="https://github.com/iteratehq/iterate-ios/blob/master/Assets/event-targeting.png?raw=true" width="500">

6. Publish your survey and you're done 🎉

## Previewing your survey

You'll likely want to preview your survey before publishing it so you can test it out and confirm everything is working correctly. You can preview using code or with a [custom URL scheme](https://developer.apple.com/documentation/uikit/inter-process_communication/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app). Previewing using code is easier during initial development to confirm you've installed everything correctly. Previewing using the custom URL scheme makes it easier to test on actual devices and for those without access to xcode.

**Using code**

In the "Preview & Publish" tab select 'Learn more' and copy the code.

<img src="https://github.com/iteratehq/iterate-ios/blob/master/Assets/preview-with-code.png?raw=true" width="500">

This makes use of the preview method which will ensure the survey is returned once the event your survey is targeting is fired.

```swift
    override func viewDidAppear(_ animated: Bool) {
       Iterate.shared.preview(surveyId: "YOUR_SURVEY_ID")
       Iterate.shared.sendEvent(name: "viewed-activity-feed")
   }
```

**Using a custom URL scheme**

First, make sure your app has a custom URL scheme set. Then add the following code when your app is opened from your app's URL scheme.

The `Iterate.shared.preview(url:)` method looks for the query parameter `?iterate_preview=YOUR_SURVEY_ID` which enables _preview mode_ allowing you to see the survey in response to your targeted event being fired, but before it's published for everyone.

If you're using scenes add the following code to your SceneDelegate

```swift
import IterateSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  // ...

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
      for context in URLContexts {
          if (URLComponents(url: context.url, resolvingAgainstBaseURL: false)?.queryItems?.contains { $0.name == Iterate.PreviewParameter } ?? false) {
              Iterate.shared.preview(url: context.url.absoluteURL)
          }
      }
  }

  // ...
}
```

otherwise add it to your AppDelegate

```swift
import IterateSDK

class AppDelegate: UIResponder, UIApplicationDelegate {

    // ...

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        if (URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.contains { $0.name == Iterate.PreviewParameter } ?? false) {
            Iterate.shared.preview(url: url.absoluteURL)
        }

        return true
    }

    // ...

}
```

Once that's added you can scan the QR code on the "Preview & Publish" tab of your survey which will open your app allowing you to preview the survey once the event you're targeting has fired.

## Recommendations

When implementing Iterate for the first time, we encourage you to implement events for _all_ of your core use cases which you may want to target surveys to in the future. e.g. signup, purchased, viewed X screen, tapped notification, etc. This way you can easily launch new surveys targeting these events without needing to instrument a new event each time.

## Associating data with a user

Using the [Identify](https://github.com/iteratehq/iterate-ios/wiki/Iterate#identifyuserproperties) method, you can easily add properties to a user that can be used to target surveys to them and associate the information with all of their future responses.

For more information see our [help article](https://help.iteratehq.com/en/articles/4457590-associating-data-with-a-user-or-response).

Note: if your app allows users to log out, you can call `Iterate.shared.reset()` method to clear all stored user data on logout.

## Survey eligibility and frequency

By default surveys are only shown once per person and user's can only see at most 1 survey every 72 hours (which is configurable). You can learn more about how [eligibility and frequency works](https://help.iteratehq.com/en/articles/2835008-survey-eligibility-and-frequency).

## Troubleshooting

If you have any issues you can head over to our [help center](https://help.iteratehq.com) to search for an answer or chat with our support team.
