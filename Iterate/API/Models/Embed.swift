//
//  Embed.swift
//  Iterate
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2019 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

/// Represents the context of the request to the embed endpoint. This includes
/// things like device type, user traits, and targeting options.
struct EmbedContext {
    var targeting: TargetingContext?
    var trigger: TriggerContext?
    var type: EmbedType?
}

// MARK: Targeting

/// Contains targeting options that are overridden by the client
struct TargetingContext {
    var frequency: TargetingContextFrequency?
    var surveyId: String?
}

/// Targeting content frequecy options. e.g. 'Always' is used to force
/// a survey to be shown regardless of other targeting options set on
/// the server
enum TargetingContextFrequency: String {
    case always = "always"
}

// MARK: Triggering

/// Contains triggering options (e.g. indicate a survey was 'manually' triggered)
struct TriggerContext {
    var surveyId: String?
    var type: TriggerType?
}

/// Trigger types, currently the only option is manually triggered
enum TriggerType: String {
    case manual = "manual"
}

// MARK: Type

enum EmbedType: String {
    case mobile = "mobile"
    case web = "web"
}

