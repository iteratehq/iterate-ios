//
//  Iterate.swift
//  Iterate
//
//  Created by Michael Singleton on 12/20/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

/// The Iterate class is the primary class of the SDK, the main entry point is the shared singleton property
public final class Iterate {
    // MARK: Properties
    
    /// The shared singleton instance is the primary entrypoint into the Iterate iOS SDK.
    /// Unless you have uncommon needs you should use this singleton to call methods
    /// on the Iterate class.
    public static let shared = Iterate()
    
    /// Query parameter used to set the preview mode
    public static let PreviewParameter = "iterate_preview"
    
    // Current version number, will be updated on each release
    private static let Version = "0.1.1"
    
    /// Default API host
    public static let DefaultAPIHost = "https://iteratehq.com"
    
    /// URL Scheme of the app, used for previewing surveys
    private lazy var urlScheme = URLScheme()
    
    /// API Client, which will be initialized when the API key is
    var api: APIClient?
    
    /// Optional API host override to use when creating the API client
    var apiHost: String?
    
    /// The id of the survey being previewed
    private var previewingSurveyId: String?
    
    /// Storage engine for storing user data like their API key and user attributes
    private var storage: StorageEngine
    
    /// Container manages the overlay window
    private let container = ContainerWindowDelegate()
    
    // Get the bundle by identifier or by url (needed when packaging in cocoapods)
    var bundle: Bundle? {
        let containerBundle = Bundle(for: ContainerWindowDelegate.self)
        if let bundleUrl = containerBundle.url(forResource: "Iterate", withExtension: "bundle") {
            return Bundle(url: bundleUrl)
        } else {
            return Bundle(identifier: "com.iteratehq.Iterate")
        }
    }
    
    // MARK: API Keys

    /// You Iterate API Key, you can get this from your settings page
    var companyApiKey: String? {
        didSet {
            updateApiKey()
        }
    }
    
    /// The API key for a user, this is returned by the server the first time a request is made by a new user
    var userApiKey: String? {
        get {
            if cachedUserApiKey == nil {
                cachedUserApiKey = storage.get(key: StorageKeys.UserApiKey) as? String
            }
            
            return cachedUserApiKey
        }
        set(newUserApiKey) {
            cachedUserApiKey = newUserApiKey
            storage.set(key: StorageKeys.UserApiKey, value: newUserApiKey)
            
            updateApiKey()
        }
    }
    
    /// Cached copy of the user API key that was loaded from UserDefaults
    private var cachedUserApiKey: String?
    
    
    // MARK: User Properties
    
    private var userProperties: UserProperties? {
        get {
            if cachedUserProperties == nil {
                if let data = storage.get(key: StorageKeys.UserProperties) as? Data,
                    let properties = try? JSONDecoder().decode(UserProperties.self, from: data) {
                    cachedUserProperties = properties
                }
            }
            
            return cachedUserProperties
        }
        set (newUserProperties) {
            if let newUserProperties = newUserProperties,
                let encodedNewUserProperties = try? JSONEncoder().encode(newUserProperties) {
                cachedUserProperties = newUserProperties
                
                storage.set(key: StorageKeys.UserProperties, value: encodedNewUserProperties)
            }
        }
    }
    
    /// Cached copy of the user properties that was loaded from UserDefaults
    private var cachedUserProperties: UserProperties?
    
    var responseProperties: ResponseProperties?
    
    // MARK: Init
    
    /// Initializer
    /// - Parameter storage: Storage engine to use
    init(storage: StorageEngine = Storage.shared) {
        self.storage = storage
    }
    
    // MARK: Public methods
    
    /// Send event to determine if a survey should be shown
    /// - Parameters:
    ///   - name: Event name
    ///   - complete: optional callback with the results of the request
    public func sendEvent(name: String, complete: ((Survey?, Error?) -> Void)? = nil) {
        guard self.api != nil else {
            if let callback = complete {
                callback(nil, IterateError.invalidAPIKey)
            }
            
            return
        }
        
        var context = initCurrentContext()
        context.event = EventContext(name: name)
        embedRequest(context: context) { (response, error) in
            if let callback = complete {
                callback(response?.survey, error)
            }
            
            if let survey = response?.survey {
                // Show the survey after N seconds otherwise show immediately
                if survey.triggers?.first?.type == TriggerType.seconds {
                    DispatchQueue.main.async {
                        let seconds: Int = survey.triggers?.first?.options?.seconds ?? 0
                        Timer.scheduledTimer(withTimeInterval: Double(seconds), repeats: false) { timer in
                            self.container.showPrompt(survey)
                        }
                    }
                } else {
                    self.container.showPrompt(survey)
                }
            }
        }
    }
    
    /// Configure sets the necessary configuration properties. This should be called before any other methods.
    /// - Parameter apiKey: Your Iterate API Key, you can find this on your settings page
    public func configure(apiKey: String, apiHost: String? = Iterate.DefaultAPIHost) {
        // Note: we need to set the apiHost before setting the companyApiKey
        // since updating the companyApiKey is what triggers to API client
        // to be set via a custom setter
        self.apiHost = apiHost
        
        // If we're changing the company API key to a different company API key
        // clear the user api key since it won't work for a different company
        if self.companyApiKey != nil && self.companyApiKey != apiKey {
            self.userApiKey = nil
        }
        
        self.companyApiKey = apiKey
    }
    
    /// Preview processes the custom scheme url that was used to open the app and sets
    /// the preview mode to the surveyId passed in
    /// - Parameter url: The URL that opened the application
    public func preview(url: URL) {
        let result = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first(where: { $0.name == Iterate.PreviewParameter })?.value
        previewingSurveyId = result
    }
    
    /// Preview a specific survey using it's id
    /// - Parameter surveyId: The id of the survey to preview
    public func preview(surveyId: String) {
        previewingSurveyId = surveyId
    }
    
    public func identify(userProperties: UserProperties?) {
        self.userProperties = userProperties
    }
    
    public func identify(responseProperties: ResponseProperties?) {
        self.responseProperties = responseProperties
    }
    
    // MARK: Private methods
    
    /// Helper method used when calling the embed endpoint which is responsible for updating the user API key
    /// if a new one is returned
    /// - Parameters:
    ///   - context: Embed context data
    ///   - complete: Callback returning the response and error from the embed endpoint
    private func embedRequest(context: EmbedContext, complete: @escaping (EmbedResponse?, Error?) -> Void) {
        api?.embed(context: context, complete: { (response, error) in
            // Update the user API key if one was returned
            if let token = response?.auth?.token {
                self.userApiKey = token
            }
            
            complete(response, error)
        })
    }
    
    /// Update the API client to use the latest API key. We prefer to use the user API key and fall back to the company key
    private func updateApiKey() {
        if let apiKey = userApiKey ?? companyApiKey {
            api = APIClient(apiKey: apiKey, apiHost: apiHost ?? Iterate.DefaultAPIHost)
        }
    }
    
    /// Generate a embed context that represents the current state of the user.
    /// In the future this may set the current 'view' the user is on, how long they've been
    /// in the app, etc. Anything that may be used for targeting.
    private func initCurrentContext() -> EmbedContext {
        // Include the url scheme of the app so we can generate a url to preview the survey
        var app: AppContext?
        if let urlScheme = Iterate.shared.urlScheme {
            app = AppContext(urlScheme: urlScheme, version: Iterate.Version)
        }
        
        // Include the survey id we're previewing
        var targeting: TargetingContext?
        if let previewingSurveyId = previewingSurveyId {
            targeting = TargetingContext(frequency: TargetingContextFrequency.always, surveyId: previewingSurveyId)
        }
        
        var userPropertiesContext: UserProperties?
        if let userProperties = Iterate.shared.userProperties {
            userPropertiesContext = userProperties
        }
        
        
        return EmbedContext(app: app, targeting: targeting, trigger: nil, type: EmbedType.mobile, userTraits: userPropertiesContext)
    }
}
