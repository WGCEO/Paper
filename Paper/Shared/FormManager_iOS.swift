//
//  FormManager_iOS.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 24..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

extension FormManager: TextAttributes {
    typealias Color = UIColor
    typealias MutableParagraphStyle = NSMutableParagraphStyle
    typealias Font = UIFont
    
   
    //TODO: 상수는 모두 FormManager의 프로퍼티에 박아두고 여기에는 변수로 참조하기
    
//    var paperFont: UIFont {
//        get {
//            return font
//        } set {
//            self.font = newValue
//        }
//    }
//    
//    var paperColor: UIColor {
//        get {
//            return color
//        } set {
//            self.color = newValue
//        }
//    }
    

    
    func calculateFormKern(formStr: String) -> CGFloat {
        let font = paperFont
        let numberingFont = UIFont(name: "Avenir Next", size: font.pointSize)!
        let num = NSAttributedString(string: "4", attributes: [
            .font : numberingFont]).size()
        let dot = NSAttributedString(string: ".", attributes: [
            .font : font]).size()
        let form = NSAttributedString(string: formStr, attributes: [
            .font : font]).size()
        return form.width > num.width + dot.width ? 0 : (num.width + dot.width - form.width)/2
    }
    
    func calculateDefaultAttributes() -> [NSAttributedStringKey : Any] {
        return [.paragraphStyle : Global.defaultParagraphStyle,
                .font : paperFont,
                .foregroundColor: Global.textColor,
                .backgroundColor: UIColor.clear,
                .underlineStyle: 0,
                .strikethroughStyle: 0,
                .kern: 0
        ]
    }
    
    func calculateDefaultAttributesWithoutParagraph() -> [NSAttributedStringKey : Any] {
        return [.font : paperFont,
                .foregroundColor: Global.textColor,
                .backgroundColor: UIColor.clear,
                .underlineStyle: 0,
                .strikethroughStyle: 0,
                .kern: 0
        ]
    }
    
    func numParagraphStyle(gapRange: NSRange, attributedText: NSAttributedString) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        let font = paperFont
        let numberingFont = UIFont(name: "Avenir Next", size: font.pointSize)!
        let num = NSAttributedString(string: "4", attributes: [.font : numberingFont])
        let dotAndSpace = NSAttributedString(string: ". ", attributes: [.font : font])
        let firstLineHeadIndent = Global.headIndent - (num.size().width + dotAndSpace.size().width)
        let headIndent = Global.headIndent + attributedText.attributedSubstring(from: gapRange).size().width
        paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
        paragraphStyle.headIndent = headIndent
        paragraphStyle.tailIndent = Global.tailIndent
        paragraphStyle.lineSpacing = Global.lineSpacing
        return paragraphStyle
    }
    
    func formParagraphStyle(form: PaperForm, gapRange: NSRange, attributedText: NSAttributedString) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        let font = paperFont
        
        let numberingFont = UIFont(name: "Avenir Next", size: font.pointSize)!
        let num = NSAttributedString(string: "4", attributes: [
            .font : numberingFont]).size()
        let dot = NSAttributedString(string: ".", attributes: [
            .font : font]).size()
        let space = NSAttributedString(string: " ", attributes: [
            .font : font]).size()
        let form = NSAttributedString(string: form.type.converted, attributes: [
            .font : font]).size()
        let firstLineHeadIndent = form.width > num.width + dot.width ?
            Global.headIndent - (space.width + form.width) :
            Global.headIndent - (space.width + (num.width + dot.width + form.width )/2)
        let headIndent = Global.headIndent + attributedText.attributedSubstring(from: gapRange).size().width
        
        paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
        paragraphStyle.headIndent = headIndent
        paragraphStyle.tailIndent = Global.tailIndent
        paragraphStyle.lineSpacing = Global.lineSpacing
        return paragraphStyle
    }
    
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
            let numberingFont = UIFont(name: "Avenir Next",
                                       size: paperFont.pointSize)!
            
            let dotRange = NSMakeRange(form.range.location + form.range.length, 1)
            let gapRange = NSMakeRange(paraRange.location, form.range.location - paraRange.location)
            mutableAttrString.addAttributes([.font : numberingFont,
                                             .foregroundColor : paperColor],
                                            range: form.range)
            mutableAttrString.addAttributes([.foregroundColor : UIColor.lightGray,
                                             .font : paperFont],
                                            range: dotRange)
            mutableAttrString.addAttributes([.paragraphStyle : numParagraphStyle(gapRange: gapRange, attributedText: mutableAttrString)],
                                            range: paraRange)
        }
    }
    

    
    
}
