//
//  Language.swift
//  IterateSDK
//
//  Created by Pickaxe on 6/28/24.
//  Copyright © 2024 Iterate. All rights reserved.
//

import Foundation

let LanguageUserProperty = "language"

func getDevicePreferredLanguageCodes() -> [String] {
    return Locale.preferredLanguages.compactMap { preferredLanguage in
        Locale(identifier: preferredLanguage).languageCode
    }
}

func availableLanguages(survey: Survey) -> [String] {
    let primaryLanguage = survey.primaryLanguage
    let translations = survey.translations ?? []
    let allLanguages = translations.map { $0.language }.filter { $0 != "" }
    return [primaryLanguage].compactMap { $0 } + allLanguages
}


func getPreferredLanguage(survey: Survey) -> String {
    let devicePreferredLanguages = getDevicePreferredLanguageCodes()
    let available = availableLanguages(survey: survey)
    let languageUserProperty = Iterate.shared.userProperties?[LanguageUserProperty]?.value as? String
    let languageUserPropertyCode = languageUserProperty?.prefix(2).lowercased()
    
    if let languageUserPropertyCode = languageUserPropertyCode, available.contains(languageUserPropertyCode) {
        return languageUserPropertyCode
    }
    
    for language in devicePreferredLanguages {
        if available.contains(language) {
            return language
        }
    }
    return survey.primaryLanguage ?? "en"
}

func getTranslationForKey(key: TranslationKey, survey: Survey) -> String? {
    let preferredLanguage = getPreferredLanguage(survey: survey)
    let translations = survey.translations ?? []
    for translation in translations {
        if translation.language == preferredLanguage {
            return translation.items?[key]?.text
        }
    }
    return nil
}
