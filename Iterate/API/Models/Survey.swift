//
//  Survey.swift
//  Iterate
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

public struct Survey: Codable {
    let color: String
    let companyId: String
    let id: String
    let prompt: Prompt?
}

public struct Prompt: Codable {
    let buttonText: String?
    let message: String?
}
