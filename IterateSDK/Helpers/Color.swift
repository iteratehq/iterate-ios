//
//  Color.swift
//  Iterate
//
//  Created by Michael Singleton on 6/9/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        let hex: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        if (hex.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }

    func luminance() -> CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return 0
        }

        // Linearize sRGB values (gamma correction) per WCAG spec
        // https://www.w3.org/TR/WCAG20/#relativeluminancedef
        let linearize: (CGFloat) -> CGFloat = { channel in
            if channel <= 0.03928 {
                return channel / 12.92
            } else {
                return pow((channel + 0.055) / 1.055, 2.4)
            }
        }
        
        let r = linearize(red)
        let g = linearize(green)
        let b = linearize(blue)
        
        // Calculate relative luminance using WCAG formula
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }

    func contrastingTextColor() -> UIColor {
        return luminance() < 0.5 ? .white : .black
    }
}

enum Colors: String {
    case LightBlack = "#1f1f1f"
}
