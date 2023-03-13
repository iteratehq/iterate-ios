//
//  URL.swift
//  
//
//  Created by Matthew Bischoff on 3/13/23.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

public extension URL {
    
    /// Returns true 
    var isIteratePreviewURL: Bool {
        return URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems?.contains { $0.name == Iterate.PreviewParameter } ?? false
    }
}
