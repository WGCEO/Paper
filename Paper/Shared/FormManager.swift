//
//  FormManager.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 23..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

protocol Cursorable: class {
    var cursorRange: NSRange { get set }
    func insertNewLine()
}

class FormManager {
    static let sharedInstance = FormManager()
    weak var delegate: Cursorable?
    
    //TODO: 폰트를 제작 후에 regex를 변환전과 변환 후로 나눠서
    let numRegex = "^\\s*(\\d+)(?=\\. )"
    //    static let listRegex = "^\\s*([-•])(?= )"
    //    static let asteriskRegex = "^\\s*([\\*\\★])(?= )"
    //    static let atRegex = "^\\s*([@※])(?= )"
    let oneRegex = "^\\s*([1•])(?= )"
    let twoRegex = "^\\s*([2★])(?= )"
    let threeRegex = "^\\s*([3※])(?= )"
    
    let formOne = "•"
    let formTwo = "★"
    let formThree = "※"
    
    let defaultFontSize: CGFloat = Global.iphone ? 17 : 23
    let headIndent: CGFloat = Global.iphone ? 30 : 40
    let tailIndent: CGFloat = Global.iphone ? -20 : -30
    let lineSpacing: CGFloat = 10
    
    
    let colors: [UIColor] = [
        UIColor(red: 255/255, green: 82/255, blue: 82/255, alpha: 1),
        UIColor(red: 6/255, green: 196/255, blue: 153/255, alpha: 1),
        UIColor(red: 249/255, green: 168/255, blue: 37/255, alpha: 1)]
    
    let colorStrs: [String] = ["red", "mint", "gold"]
    let fontStrs: [String] = ["xSmall", "small", "medium", "large", "xLarge"]
    let textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
    
    lazy var defaultAttributes: [NSAttributedStringKey : Any] = {
        return calculateDefaultAttributes()
    }()
    
    lazy var defaultAttributesWithoutParaStyle : [NSAttributedStringKey : Any] = {
        return calculateDefaultAttributesWithoutParagraph()
    }()
    
    lazy var oneKern: CGFloat = {
        return calculateFormKern(formStr: formOne)
    }()
    
    lazy var twoKern: CGFloat = {
        return calculateFormKern(formStr: formTwo)
    }()
    
    lazy var threeKern: CGFloat = {
        return calculateFormKern(formStr: formThree)
    }()
    
    lazy var defaultParagraphStyle: NSMutableParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = headIndent
        paragraphStyle.headIndent = headIndent
        paragraphStyle.tailIndent = tailIndent
        paragraphStyle.lineSpacing = lineSpacing
        return paragraphStyle
    }()
    
    internal func updateAllFormAttributes(){
        defaultAttributes = calculateDefaultAttributes()
        defaultAttributesWithoutParaStyle = calculateDefaultAttributesWithoutParagraph()
        oneKern = calculateFormKern(formStr: formOne)
        twoKern = calculateFormKern(formStr: formTwo)
        threeKern = calculateFormKern(formStr: formThree)
    }
    
    
    internal func transformToFont(name: String) -> UIFont {
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
    
    internal func transFormToColor(name: String) -> UIColor {
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
    
}

//MARK: calculate
extension FormManager {
    internal var paperFont: UIFont {
        get {
            let fontStr = CoreData.sharedInstance.paper.font!
            return transformToFont(name: fontStr)
        }
    }
    
    internal var paperColor: UIColor {
        let colorStr = CoreData.sharedInstance.paper.color!
        return transFormToColor(name: colorStr)
    }
    
    internal func calculateFormKern(formStr: String) -> CGFloat {
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
    
    internal func calculateDefaultAttributes() -> [NSAttributedStringKey : Any] {
        return [.paragraphStyle : defaultParagraphStyle,
                .font : paperFont,
                .foregroundColor: textColor,
                .backgroundColor: UIColor.clear,
                .underlineStyle: 0,
                .strikethroughStyle: 0,
                .kern: 0
        ]
    }
    
    internal func calculateDefaultAttributesWithoutParagraph() -> [NSAttributedStringKey : Any] {
        return [.font : paperFont,
                .foregroundColor: textColor,
                .backgroundColor: UIColor.clear,
                .underlineStyle: 0,
                .strikethroughStyle: 0,
                .kern: 0
        ]
    }
    
    //특정 서식이 4.의 width 보다 좁다면,
    //(4.의 width - 서식의 width)/2 를 커닝값으로 하고,
    //indent는 Global.headIndent - (띄어쓰기 + (4.의 width + 서식 width)/2) 로 해야한다.
    
    //특정 서식이 4.의 width 보다 크다면(단, Global.headIndent - 띄어쓰기크기(최대 5.06)보다는 반드시 작아야 함)
    //커닝값은 0이며
    //indent는 Global.headIndent - (띄어쓰기 + 서식 width)로 해야한다.
    
    
    
    internal func numParagraphStyle(gapRange: NSRange, attributedText: NSAttributedString) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        let font = paperFont
        let numberingFont = UIFont(name: "Avenir Next", size: font.pointSize)!
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
    
    internal func formParagraphStyle(form: PaperForm, gapRange: NSRange, attributedText: NSAttributedString) -> NSMutableParagraphStyle {
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

extension FormManager {
    internal func addAttrToFormIfNeeded(in paraRange: NSRange, mutableAttrString: NSMutableAttributedString) {
        if var paperForm = paperForm(text: mutableAttrString.string, range: paraRange) {
            switch paperForm.type {
            case .number:
                if paperForm.range.length > 20 {
                    //예외처리(UInt가 감당할 수 있는 숫자 제한, true를 리턴하면, 숫자는 감지했지만 아무것도 할 수 없음을 의미함)
                    return
                }
                replaceNumIfNeeded(mutableAttrString: mutableAttrString,currentParaRange: paraRange, numRange: &paperForm.range)
                let newParaRange = (mutableAttrString.string as NSString).paragraphRange(for: paperForm.range)
                addAttributeFor(form: paperForm, paraRange: newParaRange, mutableAttrString: mutableAttrString)
                replaceNextNumsIfNeeded(form: paperForm, mutableAttrString: mutableAttrString)
                
            case .one, .two, .three:
                replaceForm(form: paperForm, toConvert: true, mutableAttrString: mutableAttrString)
                addAttributeFor(form: paperForm, paraRange: paraRange, mutableAttrString: mutableAttrString)
            }
        } else {
            mutableAttrString.addAttributes([.paragraphStyle : defaultParagraphStyle], range: paraRange)
        }
    }
    
    private func formRange(text: String, range: NSRange, regex: String) -> NSRange? {
        do {
            let regularExpression = try NSRegularExpression(pattern: regex, options: .anchorsMatchLines)
            guard let result = regularExpression.matches(in: text, options: .withTransparentBounds, range: range).first else { return nil }
            return result.range(at: 1)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func replaceForm(form: PaperForm, toConvert: Bool, mutableAttrString: NSMutableAttributedString) {
        mutableAttrString.replaceCharacters(in: form.range, with: toConvert ? form.type.converted : form.type.reserved)
    }
    
    
    private func replaceNumIfNeeded(mutableAttrString: NSMutableAttributedString, currentParaRange: NSRange, numRange: inout NSRange){
        //이전 패러그랲이 없으면 리턴
        guard currentParaRange.location != 0
            else { return }
        let prevParaRange = (mutableAttrString.string as NSString)
            .paragraphRange(for: NSMakeRange(currentParaRange.location - 1, 0))
        
        guard let prevNumRange = formRange(text: mutableAttrString.string, range: prevParaRange, regex: numRegex)
            else { return }
        let prevGapRange = NSMakeRange(prevParaRange.location,
                                       prevNumRange.location - prevParaRange.location)
        let currGapRange = NSMakeRange(currentParaRange.location,
                                       numRange.location - currentParaRange.location)
        guard mutableAttrString.attributedSubstring(from: prevGapRange).string ==
            mutableAttrString.attributedSubstring(from: currGapRange).string,
            UInt(mutableAttrString.attributedSubstring(from: prevNumRange).string)! + 1 !=
                UInt(mutableAttrString.attributedSubstring(from: numRange).string)!
            else { return }
        
        let uncorrectCurrentNum = "\(UInt(mutableAttrString.attributedSubstring(from: numRange).string)!)"
        let correctCurrentNum = "\(UInt(mutableAttrString.attributedSubstring(from: prevNumRange).string)! + 1)"
        
        mutableAttrString.replaceCharacters(in: numRange, with: correctCurrentNum)
        //resultRange 값 수정
        numRange.length = correctCurrentNum.count
        
        delegate?.cursorRange.location += (correctCurrentNum.count - uncorrectCurrentNum.count)
    }
    
    private func replaceNextNumsIfNeeded(form: PaperForm, mutableAttrString: NSMutableAttributedString){
        var form = form
        var currentParaRange = (mutableAttrString.string as NSString).paragraphRange(for: form.range)

        while currentParaRange.location + currentParaRange.length < mutableAttrString.length {
            let nextParaRange = (mutableAttrString.string as NSString).paragraphRange(for: NSMakeRange(currentParaRange.location + currentParaRange.length + 1, 0))

            guard let nextNumRange = formRange(text: mutableAttrString.string, range: nextParaRange, regex: numRegex)
                
                else { return }
            let nextGapRange = NSMakeRange(nextParaRange.location,
                                           nextNumRange.location - nextParaRange.location)
            let currGapRange = NSMakeRange(currentParaRange.location,
                                           form.range.location - currentParaRange.location)
            guard mutableAttrString.attributedSubstring(from: currGapRange).string ==
                mutableAttrString.attributedSubstring(from: nextGapRange).string,
                UInt(mutableAttrString.attributedSubstring(from: nextNumRange).string)! - 1 !=
                    UInt(mutableAttrString.attributedSubstring(from: form.range).string)!
                else { return }
            
            let correctNextNum = "\(Int(mutableAttrString.attributedSubstring(from: form.range).string)! + 1)"
            mutableAttrString.replaceCharacters(in: nextNumRange, with: correctNextNum)
            form.range = NSMakeRange(nextNumRange.location, correctNextNum.count)
            let newParaRange = (mutableAttrString.string as NSString).paragraphRange(for: form.range)
            addAttributeFor(form: form, paraRange: newParaRange, mutableAttrString: mutableAttrString)
            
            currentParaRange = (mutableAttrString.string as NSString).paragraphRange(for: form.range)
        }
    }
    
    private func addAttributeFor(form: PaperForm, paraRange: NSRange, mutableAttrString: NSMutableAttributedString) {
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
    
    internal func paperForm(text: String, range: NSRange) -> PaperForm? {
        for type in PaperFormType.allValues {
            if let range = formRange(text: text, range: range, regex: type.regexString) {
                return PaperForm(type: type, range: range)
            }
        }
        return nil
    }
    
    internal func removeAttrOrInsertFormAtNextLineifNeeded(in paraRange: NSRange, mutableAttrString: NSMutableAttributedString, replacementText: String) -> Bool {
        
        if let form = paperForm(text: mutableAttrString.string, range: paraRange) {
            let range = form.range
            let extraLength = form.type != .number ? 1 : 2
            let formatRange = NSMakeRange(paraRange.location,
                                          range.location + range.length  + extraLength - paraRange.location)
            
            if  cursorIn(formatRange: formatRange) ||
                cursorWillBeIn(formRange: formatRange, replacementText: replacementText) {
                resetFormStyle(form: form, paraRange: paraRange, mutableAttrString: mutableAttrString)
                
            } else if inputNewLine(replacementText: replacementText) {
                if existTextAfterForm(paraRange: paraRange, formRange: formatRange, attributedText: mutableAttrString) {
                    addFormToNextParagraph(form: form, formatRange: formatRange, mutableAttrString: mutableAttrString)
                    
                    return false
                } else {
                    //텍스트가 없다면 해당 패러그랲 스타일 리셋시켜버리고 다 지워버리기
                    delete(form: form, paraRange: paraRange, mutableAttrString: mutableAttrString)
                    return false
                }
            }
            return true
        } else {
            return true
        }
    }
    
    private func delete(form: PaperForm, paraRange: NSRange, mutableAttrString: NSMutableAttributedString) {
        let move = form.type != .number ? 1 : 2
        
        //텍스트가 없다면 해당 패러그랲 스타일 리셋시켜버리고 다 지워버리기
        mutableAttrString.addAttributes([
            .font : paperFont,
            .foregroundColor : textColor,
            .paragraphStyle : defaultParagraphStyle],
                                  range: paraRange)
        //다음 행이 있다면 지워졌던 개행도 삽입해줘야함
        let existNextParagraph = mutableAttrString.length > paraRange.location + paraRange.length
        mutableAttrString.replaceCharacters(in: paraRange, with: existNextParagraph ? "\n" : "")
        if existNextParagraph {
            //리스트 + 띄어쓰기 를 지웠으므로 커서를 다시 왼쪽으로 돌려놓아야함
            delegate?.cursorRange.location -= (form.range.length + move + form.range.location - paraRange.location)
        }
    }
    
    private func resetFormStyle(form: PaperForm, paraRange: NSRange, mutableAttrString: NSMutableAttributedString) {
        if form.type != .number {
            let resetStr = form.type.reserved
            let resetRange = form.range
            let mutableAttrText = NSMutableAttributedString(string: resetStr, attributes: [
                .font : paperFont,
                .foregroundColor : textColor])
            mutableAttrString.replaceCharacters(in: resetRange, with: mutableAttrText)
            mutableAttrString.addAttributes([.paragraphStyle : defaultParagraphStyle], range: paraRange)
        } else {
            let resetRange = NSMakeRange(form.range.location, form.range.length + 1)
            mutableAttrString.addAttributes([.foregroundColor : textColor,
                                       .font : paperFont],
                                      range: resetRange)
            mutableAttrString.addAttributes([.paragraphStyle : defaultParagraphStyle],
                                      range: paraRange)
        }
    }
    
    private func existTextAfterForm(paraRange: NSRange, formRange: NSRange, attributedText: NSAttributedString) -> Bool {
        let behindRange = NSMakeRange(formRange.location + formRange.length, paraRange.location + paraRange.length - (formRange.location + formRange.length))
        let str = attributedText.attributedSubstring(from: behindRange).string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return str.count != 0 ? true : false
    }
    
    private func addFormToNextParagraph(form: PaperForm,formatRange: NSRange, mutableAttrString: NSMutableAttributedString) {
        if form.type != .number {
            let formatString = NSMutableAttributedString(attributedString: mutableAttrString.attributedSubstring(from: formatRange))
            
            if let delegate = delegate {
                delegate.insertNewLine()
                mutableAttrString.replaceCharacters(in: delegate.cursorRange, with: formatString)
                delegate.cursorRange.location += formatString.length
            }
            
            
        } else {
            let formatString = NSMutableAttributedString(attributedString: mutableAttrString.attributedSubstring(from: formatRange))
            let rangeInFormat = NSMakeRange(form.range.location - formatRange.location, form.range.length)
            let nextNumber = UInt64(formatString.attributedSubstring(from: rangeInFormat).string)! + 1
            
            formatString.replaceCharacters(in: rangeInFormat, with: String(nextNumber))
            if let delegate = delegate {
                delegate.insertNewLine()
                mutableAttrString.replaceCharacters(in: delegate.cursorRange, with: formatString)
                delegate.cursorRange.location += formatString.length
            }
        }
    }
    
    private func cursorIn(formatRange: NSRange) -> Bool {
        guard let delegate = delegate else { return false }
        return formatRange.location + formatRange.length > delegate.cursorRange.location
    }
    
    private func cursorWillBeIn(formRange: NSRange, replacementText text: String) -> Bool {
        guard let delegate = delegate else { return false }
        return text == "" &&
            delegate.cursorRange.location == formRange.location + formRange.length
    }
    
    private func inputNewLine(replacementText text: String) -> Bool {
        return text == "\n"
    }
}
