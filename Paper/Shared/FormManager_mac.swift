//
//  FormManager_mac.swift
//  Paper-mac
//
//  Created by changi kim on 2017. 10. 24..
//  Copyright © 2017년 Piano. All rights reserved.
//

import AppKit

extension FormManager: TextAttributes {
    func addAttributeFor(form: PaperForm, paraRange: NSRange, mutableAttrString: NSMutableAttributedString) {
        if form.type != .number {
            let range = form.range
            let gapRange = NSMakeRange(paraRange.location, range.location - paraRange.location)
            
            let kern: CGFloat
            switch form.type {
            case .number:
                kern = 0
            case .one:
                kern = oneKern
            case .two:
                kern = twoKern
            case .three:
                kern = threeKern
            }
            
            mutableAttrString.addAttributes([
                .font : paperFont,
                .foregroundColor : paperColor,
                .kern : kern], range: range)
            mutableAttrString.addAttributes([.paragraphStyle : formParagraphStyle(form: form, gapRange: gapRange, attributedText: mutableAttrString)], range: paraRange)
        } else {
            let numberingFont = NSFont(name: "Avenir Next",
                                       size: paperFont.pointSize)!
            
            let dotRange = NSMakeRange(form.range.location + form.range.length, 1)
            let gapRange = NSMakeRange(paraRange.location, form.range.location - paraRange.location)
            mutableAttrString.addAttributes([.font : numberingFont,
                                             .foregroundColor : paperColor],
                                            range: form.range)
            mutableAttrString.addAttributes([.foregroundColor : NSColor.lightGray,
                                             .font : paperFont],
                                            range: dotRange)
            mutableAttrString.addAttributes([.paragraphStyle : numParagraphStyle(gapRange: gapRange, attributedText: mutableAttrString)],
                                            range: paraRange)
        }
    }
    
    typealias Color = NSColor
    typealias MutableParagraphStyle = NSMutableParagraphStyle
    typealias Font = NSFont
    
    var paperFont: NSFont {
        let fontStr = CoreData.sharedInstance.paper.font!
        return transformToFont(name: fontStr)
    }
    
    var paperColor: NSColor {
        let colorStr = CoreData.sharedInstance.paper.color!
        return transFormToColor(name: colorStr)
    }
    
    var colors: [NSColor] {
        return [
                NSColor(red: 255/255, green: 82/255, blue: 82/255, alpha: 1),
                NSColor(red: 6/255, green: 196/255, blue: 153/255, alpha: 1),
                NSColor(red: 249/255, green: 168/255, blue: 37/255, alpha: 1)]
    }
    
    var defaultFontSize: CGFloat {
        return 23
    }
    
    var headIndent: CGFloat {
        return 40
    }
    
    var tailIndent: CGFloat {
        return -30
    }
    
    var textColor: NSColor {
        return NSColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
    }
    
    var defaultParagraphStyle: NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = headIndent
        paragraphStyle.headIndent = headIndent
        paragraphStyle.tailIndent = tailIndent
        paragraphStyle.lineSpacing = lineSpacing
        return paragraphStyle
    }
    
    func transformToFont(name: String) -> NSFont {
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
    
    func transFormToColor(name: String) -> NSColor {
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
    
    func calculateFormKern(formStr: String) -> CGFloat {
        let font = paperFont
        let numberingFont = NSFont(name: "Avenir Next", size: font.pointSize)!
        let num = NSAttributedString(string: "4", attributes: [
            .font : numberingFont]).size()
        let dot = NSAttributedString(string: ".", attributes: [
            .font : font]).size()
        let form = NSAttributedString(string: formStr, attributes: [
            .font : font]).size()
        return form.width > num.width + dot.width ? 0 : (num.width + dot.width - form.width)/2
    }
    
    func calculateDefaultAttributes() -> [NSAttributedStringKey : Any] {
        return [.paragraphStyle : defaultParagraphStyle,
                .font : paperFont,
                .foregroundColor: textColor,
                .backgroundColor: NSColor.clear,
                .underlineStyle: 0,
                .strikethroughStyle: 0,
                .kern: 0
        ]
    }
    
    func calculateDefaultAttributesWithoutParagraph() -> [NSAttributedStringKey : Any] {
        return [.font : paperFont,
                .foregroundColor: textColor,
                .backgroundColor: NSColor.clear,
                .underlineStyle: 0,
                .strikethroughStyle: 0,
                .kern: 0
        ]
    }
    
    func numParagraphStyle(gapRange: NSRange, attributedText: NSAttributedString) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        let font = paperFont
        let numberingFont = NSFont(name: "Avenir Next", size: font.pointSize)!
        let num = NSAttributedString(string: "4", attributes: [.font : numberingFont])
        let dotAndSpace = NSAttributedString(string: ". ", attributes: [.font : font])
        let firstLineHeadIndent = self.headIndent - (num.size().width + dotAndSpace.size().width)
        let headIndent = self.headIndent + attributedText.attributedSubstring(from: gapRange).size().width
        paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
        paragraphStyle.headIndent = headIndent
        paragraphStyle.tailIndent = tailIndent
        paragraphStyle.lineSpacing = lineSpacing
        return paragraphStyle
    }
    
    func formParagraphStyle(form: PaperForm, gapRange: NSRange, attributedText: NSAttributedString) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        let font = paperFont
        
        let numberingFont = NSFont(name: "Avenir Next", size: font.pointSize)!
        let num = NSAttributedString(string: "4", attributes: [
            .font : numberingFont]).size()
        let dot = NSAttributedString(string: ".", attributes: [
            .font : font]).size()
        let space = NSAttributedString(string: " ", attributes: [
            .font : font]).size()
        let form = NSAttributedString(string: form.type.converted, attributes: [
            .font : font]).size()
        let firstLineHeadIndent = form.width > num.width + dot.width ?
            self.headIndent - (space.width + form.width) :
            self.headIndent - (space.width + (num.width + dot.width + form.width )/2)
        let headIndent = self.headIndent + attributedText.attributedSubstring(from: gapRange).size().width
        
        paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
        paragraphStyle.headIndent = headIndent
        paragraphStyle.tailIndent = tailIndent
        paragraphStyle.lineSpacing = lineSpacing
        return paragraphStyle
    }
    
}
