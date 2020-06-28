//
//  Embed.swift
//  Iterate
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

/// Represents the context of the request to the embed endpoint. This includes
/// things like device type, user traits, and targeting options.
struct EmbedContext: Codable {
    var app: AppContext?
    var event: EventContext?
    var targeting: TargetingContext?
    var trigger: TriggerContext?
    var type: EmbedType?
}

// MARK: App

// Contains data about the application
struct AppContext: Codable {
    var urlScheme: String?
    var version: String?
}

// MARK: Event

/// Contains event data
struct EventContext: Codable {
    var name: String?
}

// MARK: Targeting

/// Contains targeting options that are overridden by the client
struct TargetingContext: Codable {
    var frequency: TargetingContextFrequency?
    var surveyId: String?
}

/// Targeting content frequecy options. e.g. 'Always' is used to force
/// a survey to be shown regardless of other targeting options set on
/// the server
enum TargetingContextFrequency: String, Codable {
    case always = "always"
}

// MARK: Triggering

/// Contains triggering options (e.g. indicate a survey was 'manually' triggered)
struct TriggerContext: Codable {
    var surveyId: String?
    var type: TriggerType?
}

/// Trigger types, currently the only option is manually triggered
enum TriggerType: String, Codable {
    case manual = "manual"
}

// MARK: Type

enum EmbedType: String, Codable {
    case mobile = "mobile"
    case web = "web"
}

