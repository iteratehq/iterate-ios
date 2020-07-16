//
//  Survey.swift
//  Iterate
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import UIKit

public struct Survey: Codable {
    let colorHex: String
    let companyId: String
    let id: String
    let prompt: Prompt?
    let triggers: [Trigger]?
    
    enum CodingKeys: String, CodingKey {
        case colorHex = "color"
        case companyId
        case id
        case prompt
        case triggers
    }
}

public struct Prompt: Codable {
    let buttonText: String?
    let message: String?
}

public struct Trigger: Codable {
    let type: TriggerType
    let options: TriggerOptions?
}

enum TriggerType: String, Codable {
    case immediately = "immediately"
    case seconds = "seconds"
}

public struct TriggerOptions: Codable {
    let seconds: Int?
}
