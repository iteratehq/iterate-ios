//
//  Environment.swift
//  ModalExample
//
//  Created by Michael Singleton on 1/22/20.
//  Copyright © 2020 Iterate. All rights reserved.
//

import Foundation

enum Environment {
    enum Keys {
        static let apiKey = "API_KEY"
        static let apiHost = "API_HOST"
    }
    
    private static let infoDictionary: [String: Any] = {
      guard let dict = Bundle.main.infoDictionary else {
        fatalError("Plist file not found")
      }
      return dict
    }()
    
    static let apiKey: String = {
        guard let apiKey = Environment.infoDictionary[Keys.apiKey] as? String else {
            fatalError("API_KEY not set in plist for this environment")
        }
        return apiKey
    }()
    
    static let apiHost: String = {
        guard let apiHost = Environment.infoDictionary[Keys.apiHost] as? String else {
            fatalError("API_KEY not set in plist for this environment")
        }
        return apiHost
    }()
}
