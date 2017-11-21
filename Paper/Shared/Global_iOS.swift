//
//  Global_iOS.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 24..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

extension Global: UIGlobalable {
    typealias Font = UIFont
    typealias Color = UIColor
    typealias ParagraphStyle = NSParagraphStyle
    
    static var currentDeviceIphone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static var paperColors: [UIColor] {
        return [
            UIColor(red: 255/255, green: 82/255, blue: 82/255, alpha: 1),
            UIColor(red: 6/255, green: 196/255, blue: 153/255, alpha: 1),
            UIColor(red: 249/255, green: 168/255, blue: 37/255, alpha: 1)]
    }
    
    static func userFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    static var textColor: UIColor {
        return UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
    }
    
    static var defaultParagraphStyle: NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = headIndent
        paragraphStyle.headIndent = headIndent
        paragraphStyle.tailIndent = tailIndent
        paragraphStyle.lineSpacing = lineSpacing
        return paragraphStyle
    }
    
    static func transformToFont(name: String) -> UIFont {
        switch name {
        case "xSmall":
            return UIFont.systemFont(ofSize: defaultFontSize - 2)
        case "small":
            return UIFont.systemFont(ofSize: defaultFontSize)
        case "medium":
            return UIFont.systemFont(ofSize: defaultFontSize + 2)
        case "large":
            return UIFont.systemFont(ofSize: defaultFontSize + 4)
        case "xLarge":
            return UIFont.systemFont(ofSize: defaultFontSize + 6)
        default:
            return UIFont.systemFont(ofSize: defaultFontSize)
        }
    }
    
    static func transformToColor(name: String) -> UIColor {
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
