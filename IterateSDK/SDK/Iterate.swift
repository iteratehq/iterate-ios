//
//  Iterate.swift
//  Iterate
//
//  Created by Michael Singleton on 12/20/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import UIKit

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
    static let Version = "1.0.8"
    
    /// Default API host
    public static let DefaultAPIHost = "https://iteratehq.com"
    
    /// URL Scheme of the app, used for previewing surveys
    lazy var urlScheme = UIApplication.URLScheme()
    
    /// API Client, which will be initialized when the API key is
    var api: APIClient?
    
    /// Optional API host override to use when creating the API client
    var apiHost: String?
    
    /// The id of the survey being previewed
    var previewingSurveyId: String?
    
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
            // If we're changing the company API key to a different company API key
            // clear the user api key since it won't work for a different company.
            // We don't want to clear the user api key if the companyApiKey is nil
            // since that would cause us to always clear the userApiKey that was loaded
            // from storage when Iterate.shared.configure is called to set the
            // companyApiKey.
            if oldValue != nil && companyApiKey != oldValue  {
                userApiKey = nil
            }
            
            updateApiKey()
        }
    }
    
    /// The API key for a user, this is returned by the server the first time a request is made by a new user
    var userApiKey: String? {
        get {
            storage.value(for: StorageKeys.UserApiKey)
        }
        
        set(newUserApiKey) {
            if let newUserApiKey = newUserApiKey {
                storage.set(value: newUserApiKey, for: StorageKeys.UserApiKey)
            } else {
                storage.delete(for: StorageKeys.UserApiKey)
            }
            
            updateApiKey()
        }
    }
    
    
    // MARK: User Properties
    
    var userProperties: UserProperties? {
        get {
            if let properties = storage.value(for: StorageKeys.UserProperties),
                let data = properties.data(using: .utf8) {
                return try? JSONDecoder().decode(UserProperties.self, from: data)
            }
            
            return nil
        }
        set (newUserProperties) {
            if let newUserProperties = newUserProperties,
                let encodedNewUserProperties = try? JSONEncoder().encode(newUserProperties),
                let userProperties = String(data: encodedNewUserProperties, encoding: .utf8) {
                storage.set(value: userProperties, for: StorageKeys.UserProperties)
            }
        }
    }
    
    // MARK: Tracking Last Updated
    
    var trackingLastUpdated: Int? {
        get {
            if let trackingLastUpdatedString = storage.value(for: StorageKeys.TrackingLastUpdated) {
                return Int(trackingLastUpdatedString)
            }
            
            return nil
        }
        set (newTrackingLastUpdated) {
            if let newTrackingLastUpdated = newTrackingLastUpdated {
                storage.set(value: String(newTrackingLastUpdated), for: StorageKeys.TrackingLastUpdated)
            }
        }
    }
    
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
        
        embedRequest(context: EmbedContext(self, withEventName: name)) { (response, error) in
            if let callback = complete {
                callback(response?.survey, error)
            }
            
            if let survey = response?.survey {
                // Show the survey after N seconds otherwise show immediately
                if survey.triggers?.first?.type == TriggerType.seconds {
                    let seconds: Int = survey.triggers?.first?.options?.seconds ?? 0
                    Timer.scheduledTimer(withTimeInterval: Double(seconds), repeats: false) { timer in
                        self.container.show(survey)
                    }
                } else {
                    self.container.show(survey)
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
    
    public func reset() {
        // Clear everything from storage
        self.storage.clear()
        
        // Update the API key
        updateApiKey()
        
        // Clear response properties
        responseProperties = nil
    }
    
    // MARK: Private methods
    
    /// Helper method used when calling the embed endpoint which is responsible for updating the user API key
    /// if a new one is returned
    /// - Parameters:
    ///   - context: Embed context data
    ///   - complete: Callback returning the response and error from the embed endpoint
    private func embedRequest(context: EmbedContext, complete: @escaping (EmbedResponse?, Error?) -> Void) {
        api?.embed(context: context, completion: { (response, error) in
            // Update the user API key if one was returned
            if let token = response?.auth?.token {
                self.userApiKey = token
            }
            
            // Update the last tracked date if one was returned
            if let lastUpdated = response?.tracking?.lastUpdated {
                self.trackingLastUpdated = lastUpdated
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
}
