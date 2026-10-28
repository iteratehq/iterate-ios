# Architecture: Iterate iOS SDK

The Iterate iOS SDK delivers surveys to iOS app users and collects their responses. This document
describes the delivery model, event flow, targeting architecture, callbacks, and integration model.
For installation and usage examples, see the [README](README.md).

**Requirements:** iOS 12 or higher. Works with iPhone and iPad.
**Language:** Swift. The podspec declares Swift 4.2, 5.0, 5.1, 5.2, and 5.3.
**Install:** Swift Package Manager, Carthage (`~> 1.6.4`), CocoaPods (`~> 1.6.4`).
**Dependencies:** [apple/swift-markdown](https://github.com/apple/swift-markdown) (from 0.3.0), used by
`PromptViewController` to render Markdown in the prompt text. It transitively pulls
`swiftlang/swift-cmark`. The SDK also links `WebKit` from the system frameworks.
**License:** MIT.

There is a separate [React Native
SDK](https://help.iteratehq.com/en/articles/5002440-installing-the-iterate-react-native-sdk).

---

## Delivery Architecture

Surveys are delivered inside the host app in response to in-app events. The user is never handed off
to Safari or to an external domain, and no survey URL is opened outside the app.

### Presentation

`PassthroughWindow` is a `UIWindow` placed one level above the frontmost application window, capped
just below `.alert`, so a survey can be shown from anywhere in the app without the host app having to
present it. Both the window and `PassthroughView` override `hitTest` to return `nil` for hits that do
not land on Iterate's own views, so touches outside the survey pass through to the interface
underneath. `ContainerWindowDelegate` owns the lifecycle and dispatches the displayed and dismiss
events.

The prompt, meaning the small invitation shown before the survey opens, is native UIKit built from
`Surveys.storyboard`: `PromptViewController` with a `UITextView` and `UIButton`s, styled for light and
dark mode, with Markdown in the prompt text rendered through swift-markdown.

### The survey body

The survey itself renders as HTML inside a `WKWebView` owned by `SurveyViewController`. At survey
time the SDK requests the survey's markup from the Iterate API host, at
`<host>/<companyId>/<surveyId>/mobile`, passing the user's auth token, any response properties, the
theme, and paths to bundled custom fonts as query parameters. The returned markup is then injected
with `loadHTMLString(_:baseURL:)`, using the app's own bundle URL as the base.

Two consequences worth being precise about. The web view never navigates to an Iterate URL and the
user is never handed off to Safari or an external browser, so the survey opens over the screen the
person was already on. But the markup is fetched over the network at survey time rather than shipped
in the binary, so the survey does require connectivity, and a failed fetch dismisses the survey rather
than showing an error. Using the app bundle as the base URL is also what lets bundled font files
resolve for the web layer's CSS.

Theme follows the survey's own `appearance` setting or the current `traitCollection`, so a survey
renders dark when the app is in dark mode.

Navigation inside the web view is filtered. Any request whose scheme, host, and port do not match the
API host is cancelled and handed to `UIApplication.shared.open` instead, so a link in survey copy
opens in the user's browser rather than inside the survey. Everything else is allowed. If the initial
navigation fails, the view shows an error state with a close button rather than dismissing.

### Native to web bridge

The web layer talks back to the SDK through a `WKScriptMessageHandler` registered as
`iterateMessageHandler`. It carries four message types: `close`, `progress`, `response`, and
`surveyComplete`. These drive the native callbacks described below, which is why response and progress
data is available to app code without any additional configuration.

Custom fonts available in the app bundle can be used in survey views, passed at configuration time:

```swift
Iterate.shared.configure(
    apiKey: YOUR_API_KEY,
    surveyTextFontName: "Merriweather-Regular",
    buttonFontName: "WorkSans-Regular"
)
```

`buttonFontName` applies to all survey interface buttons (question responses, previous and next).
`surveyTextFontName` applies to all other survey text (question prompts, explanatory copy). True Type
and Open Type fonts are supported. Font assets are loaded from the app bundle, not from an external
domain.

`configure` also accepts an `apiHost` parameter, which defaults to `Iterate.DefaultAPIHost` and
normally does not need to be set.

---

## Event Model

Survey delivery is tied to in-app events. An event can represent any product interaction: viewing a
screen, completing a flow, reaching a lifecycle state. Events are instrumented in the app with
`sendEvent`:

```swift
Iterate.shared.sendEvent(name: "viewed-activity-feed")
```

`sendEvent` takes an optional completion handler, `((Survey?, Error?) -> Void)?`, if the app needs to
know whether an event returned a survey.

Targeting logic, meaning which surveys fire on which events and for which users, is configured in the
Iterate dashboard rather than in the SDK. The SDK sends the event to the embed endpoint with device,
user, and targeting context, and the platform decides whether a survey is returned. This separation
means new surveys can be created and targeted to already-instrumented events without additional SDK
instrumentation and without a new app release.

Because of that, we recommend instrumenting events for all core use cases at integration time
(signup, purchase, key screen views, notification taps, lifecycle transitions) so that any future
survey can be targeted to an existing event without returning to the SDK.

A survey can also be requested directly, outside the event model, with
`install(surveyId:complete:)`.

---

## Localization

A survey can carry a primary language plus a set of translations, and the SDK resolves which one to
use for the native prompt text and prompt button label. `Language.swift` picks in this order: the
`language` user property, normalized to a lowercase two-letter code, if it names an available
language; then each entry of `Locale.preferredLanguages` in the user's own order, taking the first
that is available; then the survey's `primaryLanguage`, and finally English. If no translation matches,
the prompt falls back to the survey's own `prompt.message` and `prompt.buttonText`.

So setting `language` through `identify` lets the app override the device setting. Note that the
Android SDK resolves this slightly differently: it matches the `language` trait exactly rather than
normalizing it, consults only `Locale.getDefault().language` rather than the ordered list, and falls
back to English rather than the survey's primary language. An app passing a regional code such as
`en-US` will match on iOS and not on Android.

---

## Eligibility and Frequency

Eligibility is decided by the platform, not by the SDK. A person sees a survey only if they match the
targeting criteria configured in the survey builder, and once a survey has been displayed they will
not see it again unless it is configured to allow multiple submissions.

Separately, a person is limited to one survey in any 72 hour period, counting surveys they complete,
dismiss, or ignore. That window is configurable by administrators in company settings. The one
exception is the "No limit" targeting option for allowing repeat submissions, intended for cases where
a survey should always show, such as a post-checkout survey or a feedback button.

See [Survey Eligibility And Frequency](https://help.iteratehq.com/en/articles/2835008-survey-eligibility-and-frequency)
for the full rule set.

---

## Preview

A survey can be previewed before it is published, so the delivery path can be verified end to end
without exposing the survey to real users. In preview mode the survey's targeting is overridden with
frequency `always`, so the frequency cap does not suppress it. There are two mechanisms.

**In code**, `preview(surveyId:)` marks a specific survey as previewable, so it is returned when the
event it targets fires:

```swift
Iterate.shared.preview(surveyId: "YOUR_SURVEY_ID")
Iterate.shared.sendEvent(name: "viewed-activity-feed")
```

**Via a custom URL scheme**, `preview(url:)` reads the `iterate_preview` query parameter from an
inbound URL and enables preview mode for the survey it names. This is the more practical path for
testing on physical devices and for testers without Xcode. Handle it in `SceneDelegate` if the app
uses scenes, otherwise in `AppDelegate`:

```swift
if context.url.isIteratePreviewURL {
    Iterate.shared.preview(url: context.url.absoluteURL)
}
```

`Iterate.PreviewParameter` exposes the parameter name for apps that inspect `URLComponents` directly.

The app's URL scheme is detected automatically, read from the first entry of `CFBundleURLSchemes` in
the first `CFBundleURLTypes` dictionary in `Info.plist`, and reported to the platform so a preview
link can be generated for the app. There is nothing to configure, but an app with no registered URL
scheme cannot use the URL-based preview path. The Android SDK takes this as an explicit `init`
parameter instead.

---

## Callbacks

`onEvent` is the single callback entry point. It fires for four interaction event types:

```swift
Iterate.shared.onEvent { event in
    switch event.type {
    case .displayed:      // prompt or survey displayed
    case .dismiss:        // prompt or survey dismissed
    case .response:       // question response submitted
    case .surveyComplete: // user reached the thank you screen
    }
}
```

`displayed` and `dismiss` carry `event.source`, which is `.prompt` or `.survey`. `dismiss` from the
survey may carry `event.progress`, an `InteractionEventProgress` of `completed`, `total`, and an
optional `currentQuestion`, describing how far into the survey the user got. `response` carries
`event.question` and `event.response`, which is how response data reaches the client as each answer is
submitted. `surveyComplete` fires once.

`event.question` is an `InteractionEventQuestion` carrying `id` and `prompt`, not the full question
definition. `event.response` is typed `Any?`, since a response may be a string, a number, or a
collection depending on the question type.

Lifecycle event callbacks were added in 1.6.4. Note that iOS has no separate `onResponse` method; on
iOS, responses arrive through `onEvent` with `type == .response`. The Android SDK does expose a
distinct `onResponse`, so cross-platform code cannot assume a shared shape here.

---

## Targeting and User Association

`identify` has two overloads, and the distinction between them matters.

**User properties** persist against the person and are associated with all of their future responses.
They also become available as targeting attributes in the survey builder:

```swift
Iterate.shared.identify(userProperties: [
    "email": UserPropertyValue("user@email.com"),
    "external_id": UserPropertyValue("12abc34")
])
```

**Response properties** are associated only with the responses to the survey the person is currently
filling out, and not with any future survey:

```swift
Iterate.shared.identify(responseProperties: [
    "order_id": ResponsePropertyValue(123)
])
```

Both overloads take `mergeWithExisting`, which defaults to `false`. Property values must be a boolean,
string, or number, and once a property's type is established it cannot be changed.

`email`, `first_name`, `last_name`, and `external_id` are treated as special properties and surface
the person's identity on the dashboard alongside their responses. `external_id` is a string holding
your own internal ID for the user, and setting it lets Iterate match one person across platforms and
sessions, which prevents the same survey being shown twice to the same person arriving from different
places. We recommend setting it. See
[Identifying users across multiple platforms](https://help.iteratehq.com/en/articles/8582987-identifying-users-across-multiple-platforms).

Note that on Android, response properties are passed per-event through `sendEvent` with `EventTraits`
rather than through `identify`. The two platforms differ here.

If the app allows users to log out, call `reset()` on logout to clear all stored user data, including
the user API key and any properties set through `identify`:

```swift
Iterate.shared.reset()
```

---

## Integration Model

When a user answers a survey question, the response is transmitted to the Iterate platform. From
there, responses route to connected integrations based on the configuration in the Iterate dashboard,
so the routing and the writeback themselves are platform-side and no transport code is needed in the
app.

There is one thing the app does have to do. For a survey delivered through this SDK, rather than sent
from the engagement platform itself, Iterate needs the destination platform's identifier for the
person in order to write to the right profile. For Braze that means passing `braze_id` or
`braze_external_id` as a user property through `identify`, and then enabling the integration on the
survey:

```swift
Iterate.shared.identify(userProperties: [
    "braze_external_id": UserPropertyValue(brazeExternalId)
])
```

Without that identifier, responses are collected normally but there is no profile to attach them to.
Surveys deployed from a Braze Canvas or an Iterable Journey do not need this, because the engagement
platform supplies the identity.

With the integration enabled, each response is written back two ways. It is set as a **custom user
attribute**, named after the question prompt by default, and renameable or excludable per question in
the survey's integration settings. It also fires a **custom event** named `survey-question-response`,
once per answered question, carrying `question`, `label`, and `response`, plus one typed field
(`response_int`, `response_string`, or `response_array`) depending on the question type.

See the [Braze integration](https://help.iteratehq.com/en/articles/3303016-braze-integration) and
[Iterable integration](https://help.iteratehq.com/en/articles/3366005-iterable-integration) articles
for the current setup steps and plan requirements.
