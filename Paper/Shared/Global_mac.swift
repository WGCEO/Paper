//
//  Global_mac.swift
//  Paper-mac
//
//  Created by changi kim on 2017. 11. 2..
//  Copyright © 2017년 Piano. All rights reserved.
//

import AppKit

extension Global: UIGlobalable {
    typealias Font = NSFont
    typealias Color = NSColor
    typealias ParagraphStyle = NSParagraphStyle
    
    static var currentDeviceIphone: Bool {
        return false
    }
    
    static var paperColors: [NSColor] {
        return [
            NSColor(red: 255/255, green: 82/255, blue: 82/255, alpha: 1),
            NSColor(red: 6/255, green: 196/255, blue: 153/255, alpha: 1),
            NSColor(red: 249/255, green: 168/255, blue: 37/255, alpha: 1)]
    }
    
    static var textColor: NSColor {
        return NSColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
    }
    
    static var defaultParagraphStyle: NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = headIndent
        paragraphStyle.headIndent = headIndent
        paragraphStyle.tailIndent = tailIndent
        paragraphStyle.lineSpacing = lineSpacing
        return paragraphStyle
    }
    
    static func transformToFont(name: String) -> NSFont {
        switch name {
        case "xSmall":
            return NSFont.systemFont(ofSize: defaultFontSize - 2)
        case "small":
            return NSFont.systemFont(ofSize: defaultFontSize)
        case "medium":
            return NSFont.systemFont(ofSize: defaultFontSize + 2)
        case "large":
            return NSFont.systemFont(ofSize: defaultFontSize + 4)
        case "xLarge":
            return NSFont.systemFont(ofSize: defaultFontSize + 6)
        default:
            return NSFont.systemFont(ofSize: defaultFontSize)
        }
    }
    
    static func transformToColor(name: String) -> NSColor {
        switch name {
        case "red":
            return paperColors[0]
        case "mint":
            return paperColors[1]
        case "gold":
            return paperColors[2]
        default:
            return paperColors[0]
        }
    }
    
    
    
}
