//
//  InteractionEvents.swift
//  Iterate
//
//  Created by Michael Singleton on 6/9/26.
//  Copyright © 2026 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

public enum InteractionEventType: String {
    case dismiss
    case displayed
    case response
    case surveyComplete = "survey-complete"
}

public enum InteractionEventSource: String {
    case prompt
    case survey
}

public struct InteractionEventQuestion {
    public let id: String
    public let prompt: String
}

public struct InteractionEventProgress {
    public let completed: Int
    public let total: Int
    public let currentQuestion: InteractionEventQuestion?
}

public struct InteractionEvent {
    public let type: InteractionEventType
    public let survey: Survey
    public let source: InteractionEventSource?
    public let progress: InteractionEventProgress?
    public let question: InteractionEventQuestion?
    public let response: Any?

    init(
        type: InteractionEventType,
        survey: Survey,
        source: InteractionEventSource? = nil,
        progress: InteractionEventProgress? = nil,
        question: InteractionEventQuestion? = nil,
        response: Any? = nil
    ) {
        self.type = type
        self.survey = survey
        self.source = source
        self.progress = progress
        self.question = question
        self.response = response
    }
}
