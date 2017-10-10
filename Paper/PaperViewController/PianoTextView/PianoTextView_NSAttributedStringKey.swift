//
//  PianoTextView_NSAttributedStringKey.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 9..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

extension PianoTextView {
    
    internal func updateAllCalculateAttr(){
        defaultAttributes = calculateDefaultAttributes()
        defaultAttributesWithoutParaStyle = calculateDefaultAttributesWithoutParagraph()
        circleKern = calculateCircleKern()
        starKern = calculateStarKern()
        refKern = calculateRefKern()
    }
    
    //특정 서식이 4.의 width 보다 좁다면,
    //(4.의 width - 서식의 width)/2 를 커닝값으로 하고,
    //indent는 30 - (띄어쓰기 + (4.의 width + 서식 width)/2) 로 해야한다.
    
    //특정 서식이 4.의 width 보다 크다면(단, 30 - 띄어쓰기크기(최대 5.06)보다는 반드시 작아야 함)
    //커닝값은 0이며
    //indent는 30 - (띄어쓰기 + 서식 width)로 해야한다.
    
    internal func calculateDefaultAttributes() -> [NSAttributedStringKey : Any] {
        return [.paragraphStyle : Global.defaultParagraphStyle,
                .font : CoreData.sharedInstance.paperFont,
                .foregroundColor: Global.textColor,
                .backgroundColor: UIColor.clear,
                .underlineStyle: 0,
                .strikethroughStyle: 0
        ]
    }
    
    internal func calculateDefaultAttributesWithoutParagraph() -> [NSAttributedStringKey : Any] {
        return [.font : CoreData.sharedInstance.paperFont,
                .foregroundColor: Global.textColor,
                .backgroundColor: UIColor.clear,
                .underlineStyle: 0,
                .strikethroughStyle: 0
        ]
    }
    
    internal func calculateCircleKern() -> CGFloat {
        let font = CoreData.sharedInstance.paperFont
        let numberingFont = UIFont(name: "Avenir Next", size: font.pointSize)!
        let num = NSAttributedString(string: "4", attributes: [
            .font : numberingFont]).size()
        let dot = NSAttributedString(string: ".", attributes: [
            .font : font]).size()
        let circle = NSAttributedString(string: "•", attributes: [
            .font : font]).size()
        return circle.width > num.width + dot.width ? 0 : (num.width + dot.width - circle.width)/2
    }
    
    internal func calculateStarKern() -> CGFloat {
        let font = CoreData.sharedInstance.paperFont
        let numberingFont = UIFont(name: "Avenir Next", size: font.pointSize)!
        let num = NSAttributedString(string: "4", attributes: [
            .font : numberingFont]).size()
        let dot = NSAttributedString(string: ".", attributes: [
            .font : font]).size()
        let star = NSAttributedString(string: "★", attributes: [
            .font : font]).size()
        return star.width > num.width + dot.width ? 0 : (num.width + dot.width - star.width)/2
    }
    
    internal func calculateRefKern() -> CGFloat {
        let font = CoreData.sharedInstance.paperFont
        let numberingFont = UIFont(name: "Avenir Next", size: font.pointSize)!
        let num = NSAttributedString(string: "4", attributes: [
            .font : numberingFont]).size()
        let dot = NSAttributedString(string: ".", attributes: [
            .font : font]).size()
        let ref = NSAttributedString(string: "※", attributes: [
            .font : font]).size()
        return ref.width > num.width + dot.width ? 0 : (num.width + dot.width - ref.width)/2
    }
    
    internal func numParagraphStyle(gapRange: NSRange) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        let font = CoreData.sharedInstance.paperFont
        let numberingFont = UIFont(name: "Avenir Next", size: font.pointSize)!
        let num = NSAttributedString(string: "4", attributes: [.font : numberingFont])
        let dotAndSpace = NSAttributedString(string: ". ", attributes: [.font : font])
        let firstLineHeadIndent = 30 - (num.size().width + dotAndSpace.size().width)
        let headIndent = 30 + attributedText.attributedSubstring(from: gapRange).size().width
        paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
        paragraphStyle.headIndent = headIndent
        paragraphStyle.tailIndent = -20
        paragraphStyle.lineSpacing = 8
        return paragraphStyle
    }
    
    internal func circleParagraphStyle(gapRange: NSRange) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        let font = CoreData.sharedInstance.paperFont
        let numberingFont = UIFont(name: "Avenir Next", size: font.pointSize)!
        let num = NSAttributedString(string: "4", attributes: [
            .font : numberingFont]).size()
        let dot = NSAttributedString(string: ".", attributes: [
            .font : font]).size()
        let space = NSAttributedString(string: " ", attributes: [
            .font : font]).size()
        let circle = NSAttributedString(string: "•", attributes: [
            .font : font]).size()
        let firstLineHeadIndent = circle.width > num.width + dot.width ?
            30 - (space.width + circle.width) :
            30 - (space.width + (num.width + dot.width + circle.width )/2)
        let headIndent = 30 + attributedText.attributedSubstring(from: gapRange).size().width
        
        paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
        paragraphStyle.headIndent = headIndent
        paragraphStyle.tailIndent = -20
        paragraphStyle.lineSpacing = 8
        return paragraphStyle
    }
    
    internal func starParagraphStyle(gapRange: NSRange) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        let font = CoreData.sharedInstance.paperFont
        let numberingFont = UIFont(name: "Avenir Next", size: font.pointSize)!
        let num = NSAttributedString(string: "4", attributes: [
            .font : numberingFont]).size()
        let dot = NSAttributedString(string: ".", attributes: [
            .font : font]).size()
        let space = NSAttributedString(string: " ", attributes: [
            .font : font]).size()
        let star = NSAttributedString(string: "★", attributes: [
            .font : font]).size()
        let firstLineHeadIndent = star.width > num.width + dot.width ?
            30 - (space.width + star.width) :
            30 - (space.width + (num.width + dot.width + star.width )/2)
        let headIndent = 30 + attributedText.attributedSubstring(from: gapRange).size().width
        
        paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
        paragraphStyle.headIndent = headIndent
        paragraphStyle.tailIndent = -20
        paragraphStyle.lineSpacing = 8
        return paragraphStyle
    }
    
    internal func refParagraphStyle(gapRange: NSRange) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        let font = CoreData.sharedInstance.paperFont
        let numberingFont = UIFont(name: "Avenir Next", size: font.pointSize)!
        let num = NSAttributedString(string: "4", attributes: [
            .font : numberingFont]).size()
        let dot = NSAttributedString(string: ".", attributes: [
            .font : font]).size()
        let space = NSAttributedString(string: " ", attributes: [
            .font : font]).size()
        let ref = NSAttributedString(string: "※", attributes: [
            .font : font]).size()
        let firstLineHeadIndent = ref.width > num.width + dot.width ?
            30 - (space.width + ref.width) :
            30 - (space.width + (num.width + dot.width + ref.width )/2)
        let headIndent = 30 + attributedText.attributedSubstring(from: gapRange).size().width
        
        paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
        paragraphStyle.headIndent = headIndent
        paragraphStyle.tailIndent = -20
        paragraphStyle.lineSpacing = 8
        return paragraphStyle
    }
}
