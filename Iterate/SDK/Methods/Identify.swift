//
//  Identify.swift
//  Iterate
//
//  Created by Michael Singleton on 6/29/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import Foundation

extension Iterate {
    
    public func identify(userProperties: UserProperties?) {
        self.userProperties = userProperties
    }
    
    public func identify(responseProperties: ResponseProperties?) {
        self.responseProperties = responseProperties
    }
    
}
