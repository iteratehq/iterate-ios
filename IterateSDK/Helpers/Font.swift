//
//  Font.swift
//  IterateSDK
//
//  Created by Pickaxe on 7/14/22.
//  Copyright © 2022 Iterate. All rights reserved.
//

import UIKit
import Foundation

func fontNamesFromFile(for file: URL) -> [String]? {
    var fontNames: [String] = []

    guard let data = try? Data(contentsOf: file) else {
        return nil
    }
    guard let provider = CGDataProvider(data: data as CFData) else {
        return nil
    }
    guard let font = CGFont(provider) else {
        return nil
    }

    if let postScriptName = font.postScriptName {
        fontNames.append(String(postScriptName))
    } else if let fullName = font.fullName {
        fontNames.append(String(fullName))
    }
    
    if (fontNames.count > 0) {
        return fontNames
    } else {
        return nil
    }
}

func fileNameFromFontName(fontName: String) -> String? {
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    
    let directoryItems = try? fm.contentsOfDirectory(atPath: path)

    if let items = directoryItems {
        for item in items {
            if (item.hasSuffix(".otf") || item.hasSuffix(".ttf")) {
                let url = URL(fileURLWithPath: "\(path)/\(item)")
                
                if let fontNames = fontNamesFromFile(for: url), fontNames.contains(fontName) {
                    return item
                }
            }
        }
    }
    
    return nil
}
