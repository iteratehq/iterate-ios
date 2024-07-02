//
//  Survey.swift
//  Iterate
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import UIKit

public struct Survey: Codable {
    let appearance: String?
    let colorHex: String
    let colorDarkHex: String?
    let companyId: String
    let id: String
    let primaryLanguage: String?
    let prompt: Prompt?
    let translations: [Translation]?
    let triggers: [Trigger]?
    
    enum CodingKeys: String, CodingKey {
        case appearance
        case colorHex = "color"
        case colorDarkHex = "colorDark"
        case companyId
        case id
        case primaryLanguage
        case prompt
        case translations
        case triggers
    }
}

public struct Prompt: Codable {
    let buttonText: String?
    let message: String?
}

public struct Translation: Codable {
    let language: String
    let items: [TranslationKey: TranslationItem]?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        language = try container.decode(String.self, forKey: .language)
        
        if let itemsDict = try? container.decode([String: TranslationItem].self, forKey: .items) {
            items = Dictionary(uniqueKeysWithValues: itemsDict.compactMap { key, value in
                guard let translationKey = TranslationKey(rawValue: key) else { return nil }
                return (translationKey, value)
            })
        } else {
            items = nil
        }
    }
}

public struct TranslationItem: Codable {
    let text: String
}

enum TranslationKey: String, Codable {
    case promptMessage = "survey.prompt.text"
    case promptButton = "survey.prompt.buttonText"
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
