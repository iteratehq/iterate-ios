//
//  Iterate.swift
//  Iterate
//
//  Created by Michael Singleton on 12/20/19.
//  Copyright © 2019 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

public class Iterate {
    public static let shared = Iterate()
    var apiKey: String?
    
    public func configure(apiKey: String) {
        self.apiKey = apiKey
    }
}
