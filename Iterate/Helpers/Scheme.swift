//
//  Scheme.swift
//  Iterate
//
//  Created by Michael Singleton on 6/18/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import UIKit

extension UIApplication {
    
    /// Get the url scheme for the app, this is used to enable preview mode
    class func URLScheme() -> String? {
        guard let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [AnyObject],
            let urlTypeDictionary = urlTypes.first as? [String: AnyObject],
            let urlSchemes = urlTypeDictionary["CFBundleURLSchemes"] as? [AnyObject],
            let scheme = urlSchemes.first as? String else { return nil }

        return scheme
    }
}


