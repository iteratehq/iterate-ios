//
//  Markdown.swift
//  IterateSDK
//
//  Created by Mike Singleton on 1/4/24.
//  Copyright © 2024 Iterate. All rights reserved.
//
// A simplified versions of https://github.com/christianselig/Markdownosaur
// which adds support for images

import Foundation

import UIKit
import Markdown

public struct MarkdownRenderer: MarkupVisitor {
    let baseFontSize: CGFloat = 16.0
    let font: UIFont
    // The rerender method is set by the caller and indicates the UITextView needs to be re-rendered because
    // we've finished an async method like downloading an image from a url.
    var rerender: () -> Void

    public init(withFontName: String?) {
        if let fontName = withFontName, let customFont = UIFont(name: fontName, size: baseFontSize) {
            font = customFont
        } else {
            font = UIFont.systemFont(ofSize: baseFontSize, weight: .regular)
        }
        
        rerender = { () -> Void in }
    }
    
    public mutating func attributedString(from document: Document) -> NSAttributedString {
        return visit(document)
    }
    
    mutating public func defaultVisit(_ markup: Markup) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in markup.children {
            result.append(visit(child))
        }
        
        return result
    }
    
    mutating public func visitText(_ text: Text) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 23
        paragraphStyle.alignment = .center
        
        let attrString = NSAttributedString(string: text.plainText, attributes: [
            .font: font,
            .paragraphStyle: paragraphStyle
        ])
        
        return attrString
    }
    
    mutating public func visitEmphasis(_ emphasis: Emphasis) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in emphasis.children {
            result.append(visit(child))
        }
        
        result.applyEmphasis()
        
        return result
    }
    
    mutating public func visitImage(_ image: Image) -> NSAttributedString {
        guard let urlString = image.source, let url = URL(string: urlString) else {
            return NSMutableAttributedString()
        }
        
        if let image = ImageCache.shared.getImage(for: urlString) {
            // Check if we've downloaded the image
            let textAttachment = NSTextAttachment()
            textAttachment.image = image
            let result = NSMutableAttributedString(attachment: textAttachment)
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            result.addAttribute(.paragraphStyle, value: style)
            return result
        } else {
            // Otherwise download it and save to the cache
            let rerender = self.rerender
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else {
                    return
                }
                
                DispatchQueue.main.async {
                    ImageCache.shared.setImage(image, for: urlString)
                    rerender()
                }
            }.resume()
        }
        
        return NSMutableAttributedString()
    }
    
    mutating public func visitStrong(_ strong: Strong) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in strong.children {
            result.append(visit(child))
        }
        
        result.applyStrong()
        
        return result
    }
    
    mutating public func visitParagraph(_ paragraph: Paragraph) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in paragraph.children {
            result.append(visit(child))
        }
        
        if paragraph.hasSuccessor {
            result.append(.doubleNewline(withFontSize: baseFontSize))
        }
        
        return result
    }
    
    mutating public func visitHeading(_ heading: Heading) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in heading.children {
            result.append(visit(child))
        }
        
        result.applyHeading(withLevel: heading.level)
        
        if heading.hasSuccessor {
            result.append(.doubleNewline(withFontSize: baseFontSize))
        }
        
        return result
    }
    
    mutating public func visitLink(_ link: Link) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in link.children {
            result.append(visit(child))
        }
        
        let url = link.destination != nil ? URL(string: link.destination!) : nil
        
        result.applyLink(withURL: url)
        
        return result
    }
    
    mutating public func visitStrikethrough(_ strikethrough: Strikethrough) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        for child in strikethrough.children {
            result.append(visit(child))
        }
        
        result.applyStrikethrough()
        
        return result
    }
}

// MARK: - Extensions Land

extension NSMutableAttributedString {
    func applyEmphasis() {
        enumerateAttribute(.font, in: NSRange(location: 0, length: length), options: []) { value, range, stop in
            guard let font = value as? UIFont else { return }
            
            let newFont = font.apply(newTraits: .traitItalic)
            addAttribute(.font, value: newFont, range: range)
        }
    }
    
    func applyStrong() {
        enumerateAttribute(.font, in: NSRange(location: 0, length: length), options: []) { value, range, stop in
            guard let font = value as? UIFont else { return }
            
            let newFont = font.apply(newTraits: .traitBold)
            addAttribute(.font, value: newFont, range: range)
        }
    }
    
    func applyLink(withURL url: URL?) {
        if let url = url {
            addAttribute(.link, value: url)
        }
    }
    
    func applyHeading(withLevel headingLevel: Int) {
        enumerateAttribute(.font, in: NSRange(location: 0, length: length), options: []) { value, range, stop in
            guard let font = value as? UIFont else { return }
            
            let newFont = font.apply(newTraits: .traitBold, newPointSize: 28.0 - CGFloat(headingLevel * 2))
            addAttribute(.font, value: newFont, range: range)
        }
    }
    
    func applyStrikethrough() {
        addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue)
    }
}

extension UIFont {
    func apply(newTraits: UIFontDescriptor.SymbolicTraits, newPointSize: CGFloat? = nil) -> UIFont {
        var existingTraits = fontDescriptor.symbolicTraits
        existingTraits.insert(newTraits)
        
        guard let newFontDescriptor = fontDescriptor.withSymbolicTraits(existingTraits) else { return self }
        return UIFont(descriptor: newFontDescriptor, size: newPointSize ?? pointSize)
    }
}

extension NSMutableAttributedString {
    func addAttribute(_ name: NSAttributedString.Key, value: Any) {
        addAttribute(name, value: value, range: NSRange(location: 0, length: length))
    }
    
    func addAttributes(_ attrs: [NSAttributedString.Key : Any]) {
        addAttributes(attrs, range: NSRange(location: 0, length: length))
    }
}

extension Markup {
    /// Returns true if this element has sibling elements after it.
    var hasSuccessor: Bool {
        guard let childCount = parent?.childCount else { return false }
        return indexInParent < childCount - 1
    }
}

extension NSAttributedString {
    static func singleNewline(withFontSize fontSize: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: "\n", attributes: [.font: UIFont.systemFont(ofSize: fontSize, weight: .regular)])
    }
    
    static func doubleNewline(withFontSize fontSize: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: "\n\n", attributes: [.font: UIFont.systemFont(ofSize: fontSize, weight: .regular)])
    }
}

// Small image cache to hold images we've already downloaded
class ImageCache {
    static let shared = ImageCache()

    private init() {}

    private var cache = NSCache<NSString, UIImage>()

    func setImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func getImage(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
