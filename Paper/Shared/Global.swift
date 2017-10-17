//
//  Global.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 3..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

struct Global {
    static let backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
    
    static let paletteViewHeight: CGFloat = 70
    static let accessoryViewHeight: CGFloat = 44
    static let duration: Double = 0.2
    static let opacity: CGFloat = 1
    static let transparent: CGFloat = 0.3
    static let mirrorFont: CGFloat = 31
    
    static let numRegex = "^\\s*(\\d+)(?=\\. )"
    static let listRegex = "^\\s*([-•])(?= )"
    static let asteriskRegex = "^\\s*([\\*\\★])(?= )"
    static let atRegex = "^\\s*([@※])(?= )"
    
    static let colors: [UIColor] = [
        UIColor(red: 255/255, green: 82/255, blue: 82/255, alpha: 1),
        UIColor(red: 6/255, green: 196/255, blue: 153/255, alpha: 1),
        UIColor(red: 249/255, green: 168/255, blue: 37/255, alpha: 1)]
    
    static let colorStrs: [String] = ["red", "mint", "gold"]
    
    static let fontStrs: [String] = ["system16", "system17", "system19", "system21", "system23"]
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    static let defaultParagraphStyle: NSMutableParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 30
        paragraphStyle.headIndent = 30
        paragraphStyle.tailIndent = -20
        paragraphStyle.lineSpacing = 8
        return paragraphStyle
    }()
    
    static let textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
    
    
    static func transformToFont(name: String) -> UIFont {
        switch name {
        case "system16":
            return UIFont.systemFont(ofSize: 16)
        case "system17":
            return UIFont.systemFont(ofSize: 17)
        case "system19":
            return UIFont.systemFont(ofSize: 19)
        case "system21":
            return UIFont.systemFont(ofSize: 21)
        case "system23":
            return UIFont.systemFont(ofSize: 23)
        default:
            return UIFont.systemFont(ofSize: 17)
        }
    }
    
    static func transFormToColor(name: String) -> UIColor {
        switch name {
        case "red":
            return colors[0]
        case "mint":
            return colors[1]
        case "gold":
            return colors[2]
        default:
            return colors[0]
        }
    }
    
    static func textMargin(by screenWidth: CGFloat) -> CGFloat {
        if screenWidth < 415 {
            return 0
        } else if screenWidth < 600 {
            return screenWidth / 20
        } else if screenWidth < 750 {
            return screenWidth / 15
        } else if screenWidth < 850 {
            return screenWidth / 10
        } else {
            return screenWidth / 6.7
        }
    }
    
    static func userFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
