//
//  PianoTextView_Form.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 9..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

//MARK: completed formatter
extension PianoTextView {
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
                resetFormStyle(form: form, paraRange: paraRange)
                
            } else if inputNewLine(replacementText: replacementText) {
                if existTextAfterForm(paraRange: paraRange, formRange: formatRange) {
                    addFormToNextParagraph(form: form, formatRange: formatRange)
                    
                    return false
                } else {
                    //텍스트가 없다면 해당 패러그랲 스타일 리셋시켜버리고 다 지워버리기
                    delete(form: form, paraRange: paraRange)
                    return false
                }
            }
            return true
        } else {
            return true
        }
    }
    
    private func delete(form: PaperForm, paraRange: NSRange) {
        let move = form.type != .number ? 1 : 2
        
        //텍스트가 없다면 해당 패러그랲 스타일 리셋시켜버리고 다 지워버리기
        textStorage.addAttributes([
            .font : CoreData.sharedInstance.paperFont,
            .foregroundColor : Global.textColor,
            .paragraphStyle : Global.defaultParagraphStyle],
                                  range: paraRange)
        //다음 행이 있다면 지워졌던 개행도 삽입해줘야함
        let existNextParagraph = attributedText.length > paraRange.location + paraRange.length
        textStorage.replaceCharacters(in: paraRange, with: existNextParagraph ? "\n" : "")
        if existNextParagraph {
            //리스트 + 띄어쓰기 를 지웠으므로 커서를 다시 왼쪽으로 돌려놓아야함
            selectedRange.location -= (form.range.length + move + form.range.location - paraRange.location)
        }
    }
    
    private func resetFormStyle(form: PaperForm, paraRange: NSRange) {
        if form.type != .number {
            let resetStr = form.type.reserved
            let resetRange = form.range
            let mutableAttrText = NSMutableAttributedString(string: resetStr, attributes: [
                .font : CoreData.sharedInstance.paperFont,
                .foregroundColor : Global.textColor])
            textStorage.replaceCharacters(in: resetRange, with: mutableAttrText)
            textStorage.addAttributes([.paragraphStyle : Global.defaultParagraphStyle], range: paraRange)
        } else {
            let resetRange = NSMakeRange(form.range.location, form.range.length + 1)
            textStorage.addAttributes([.foregroundColor : Global.textColor,
                                       .font : CoreData.sharedInstance.paperFont],
                                      range: resetRange)
            textStorage.addAttributes([.paragraphStyle : Global.defaultParagraphStyle],
                                      range: paraRange)
        }
    }
    
    private func existTextAfterForm(paraRange: NSRange, formRange: NSRange) -> Bool {
        let behindRange = NSMakeRange(formRange.location + formRange.length, paraRange.location + paraRange.length - (formRange.location + formRange.length))
        let str = attributedText.attributedSubstring(from: behindRange).string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return str.count != 0 ? true : false
    }
    
    private func addFormToNextParagraph(form: PaperForm,formatRange: NSRange) {
        if form.type != .number {
            let formatString = NSMutableAttributedString(attributedString: attributedText.attributedSubstring(from: formatRange))
            insertText("\n")
            textStorage.replaceCharacters(in: selectedRange, with: formatString)
            selectedRange.location += formatString.length
        } else {
            let formatString = NSMutableAttributedString(attributedString: attributedText.attributedSubstring(from: formatRange))
            let rangeInFormat = NSMakeRange(form.range.location - formatRange.location, form.range.length)
            let nextNumber = UInt64(formatString.attributedSubstring(from: rangeInFormat).string)! + 1
            
            formatString.replaceCharacters(in: rangeInFormat, with: String(nextNumber))
            insertText("\n")
            textStorage.replaceCharacters(in: selectedRange, with: formatString)
            selectedRange.location += formatString.length
        }
    }
    
    private func cursorIn(formatRange: NSRange) -> Bool {
        return formatRange.location + formatRange.length > selectedRange.location
    }
    
    private func cursorWillBeIn(formRange: NSRange, replacementText text: String) -> Bool {
        return text == "" &&
            selectedRange.location == formRange.location + formRange.length
    }
    
    private func inputNewLine(replacementText text: String) -> Bool {
        return text == "\n"
    }
}

//MARK: formatter
extension PianoTextView {
    
    internal func addAttrToFormIfNeeded(in paraRange: NSRange, mutableAttrString: NSMutableAttributedString) {
        if let paperForm = paperForm(text: mutableAttrString.string, range: paraRange) {
            var range = paperForm.range
            switch paperForm.type {
            case .number:
                if range.length > 20 {
                    //예외처리(UInt가 감당할 수 있는 숫자 제한, true를 리턴하면, 숫자는 감지했지만 아무것도 할 수 없음을 의미함)
                    return
                }
                replaceNumIfNeeded(currentParaRange: paraRange, numRange: &range)
                let newParaRange = rangeForParagraph(with: range)
                addAttributeFor(form: paperForm, paraRange: newParaRange, mutableAttrString: mutableAttrString)
                replaceNextNumsIfNeeded(form: paperForm, mutableAttrString: mutableAttrString)
                
            case .one, .two, .three:
                replaceForm(form: paperForm, toConvert: true, mutableAttrString: mutableAttrString)
                addAttributeFor(form: paperForm, paraRange: paraRange, mutableAttrString: mutableAttrString)
            }
        } else {
            mutableAttrString.addAttributes([.paragraphStyle : Global.defaultParagraphStyle], range: paraRange)
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
    
    
    private func replaceNumIfNeeded(currentParaRange: NSRange, numRange: inout NSRange){
        //이전 패러그랲이 없으면 리턴
        guard currentParaRange.location != 0
            else { return }
        let prevParaRange = rangeForParagraph(with: NSMakeRange(currentParaRange.location - 1, 0))
        guard let prevNumRange = formRange(text: text, range: prevParaRange, regex: Global.numRegex)
            else { return }
        let prevGapRange = NSMakeRange(prevParaRange.location,
                                       prevNumRange.location - prevParaRange.location)
        let currGapRange = NSMakeRange(currentParaRange.location,
                                       numRange.location - currentParaRange.location)
        guard attributedText.attributedSubstring(from: prevGapRange).string ==
            attributedText.attributedSubstring(from: currGapRange).string,
            UInt(attributedText.attributedSubstring(from: prevNumRange).string)! + 1 !=
                UInt(attributedText.attributedSubstring(from: numRange).string)!
            else { return }
        
        let uncorrectCurrentNum = "\(UInt(attributedText.attributedSubstring(from: numRange).string)!)"
        let correctCurrentNum = "\(UInt(attributedText.attributedSubstring(from: prevNumRange).string)! + 1)"
        
        textStorage.replaceCharacters(in: numRange, with: correctCurrentNum)
        //resultRange 값 수정
        numRange.length = correctCurrentNum.count
        
        
        //수정된 값의 범위가 더 클 때에만 커서 이동시켜줘야함. 더 작을 때는 커서 위치가 알아서 움직임.
        if correctCurrentNum.count > uncorrectCurrentNum.count {
            selectedRange.location += (correctCurrentNum.count - uncorrectCurrentNum.count)
        }
    }
    
    private func replaceNextNumsIfNeeded(form: PaperForm, mutableAttrString: NSMutableAttributedString){
        var form = form
        var currentParaRange = rangeForParagraph(with: form.range)
        while currentParaRange.location + currentParaRange.length < attributedText.length {
            let nextParaRange = rangeForParagraph(with: NSMakeRange(currentParaRange.location + currentParaRange.length + 1, 0))
            guard let nextNumRange = formRange(text: text, range: nextParaRange, regex: Global.numRegex)
                
                else { return }
            let nextGapRange = NSMakeRange(nextParaRange.location,
                                           nextNumRange.location - nextParaRange.location)
            let currGapRange = NSMakeRange(currentParaRange.location,
                                           form.range.location - currentParaRange.location)
            guard attributedText.attributedSubstring(from: currGapRange).string ==
                attributedText.attributedSubstring(from: nextGapRange).string,
                UInt(attributedText.attributedSubstring(from: nextNumRange).string)! - 1 !=
                    UInt(attributedText.attributedSubstring(from: form.range).string)!
                else { return }
            
            let correctNextNum = "\(Int(attributedText.attributedSubstring(from: form.range).string)! + 1)"
            textStorage.replaceCharacters(in: nextNumRange, with: correctNextNum)
            form.range = NSMakeRange(nextNumRange.location, correctNextNum.count)
            let newParaRange = rangeForParagraph(with: form.range)
            addAttributeFor(form: form, paraRange: newParaRange, mutableAttrString: mutableAttrString)
            
            currentParaRange = rangeForParagraph(with: form.range)
        }
    }
    
    private func addAttributeFor(form: PaperForm, paraRange: NSRange, mutableAttrString: NSMutableAttributedString) {
        if form.type != .number {
            let range = form.range
            let gapRange = NSMakeRange(paraRange.location, range.location - paraRange.location)
            let kern = form.type.kern
            
            mutableAttrString.addAttributes([
                .font : CoreData.sharedInstance.paperFont,
                .foregroundColor : CoreData.sharedInstance.paperColor,
                .kern : kern], range: range)
            mutableAttrString.addAttributes([.paragraphStyle : formParagraphStyle(form: form, gapRange: gapRange)], range: paraRange)
        } else {
            let numberingFont = UIFont(name: "Avenir Next",
                                       size: CoreData.sharedInstance.paperFont.pointSize)!
            
            let dotRange = NSMakeRange(form.range.location + form.range.length, 1)
            let gapRange = NSMakeRange(paraRange.location, form.range.location - paraRange.location)
            mutableAttrString.addAttributes([.font : numberingFont,
                                             .foregroundColor : CoreData.sharedInstance.paperColor],
                                            range: form.range)
            mutableAttrString.addAttributes([.foregroundColor : UIColor.lightGray,
                                             .font : CoreData.sharedInstance.paperFont],
                                            range: dotRange)
            mutableAttrString.addAttributes([.paragraphStyle : numParagraphStyle(gapRange: gapRange)],
                                            range: paraRange)
        }
        
    }
    

}

//MARK: Paste
extension PianoTextView {
    override func paste(_ sender: Any?) {
        
        if let attrString = transformAttrStringFromPasteboard() {
            textStorage.replaceCharacters(in: selectedRange, with: attrString)
        }
    }
    
    private func transformAttrStringFromPasteboard() -> NSAttributedString? {
        var attrString: NSAttributedString? = nil

        //하나를 복사해도 여러가지의 타입이 생성되는데 그중에 우선순위 pasteboard가 있어서 그에 맞춰 코딩함
        if let data = UIPasteboard.general.data(forPasteboardType: "com.apple.flat-rtfd") {
            do {
                attrString = try NSAttributedString(data: data, options: [:], documentAttributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        } else if let data = UIPasteboard.general.data(forPasteboardType: "com.apple/webarchive") {
            do {
                attrString = try NSAttributedString(data: data, options: [:], documentAttributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        } else if let data = UIPasteboard.general.data(forPasteboardType: "com.evernote.app.htmlData") {
            do {
                attrString = try NSAttributedString(data: data, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        } else if let data = UIPasteboard.general.data(forPasteboardType: "Apple Web Archive pasteboard type") {
            do {
                attrString = try NSAttributedString(data: data, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if let attrText = attrString {
            let mutableAttrText = NSMutableAttributedString(attributedString: attrText)
            
            //이미지는 ImageAttachment로 바꿔서 저장
            mutableAttrText.enumerateAttribute(.attachment, in: NSMakeRange(0, mutableAttrText.length), options: [], using: { (value, range, stop) in
                guard let attachment = value as? NSTextAttachment else { return }
                
                if let image = attachment.image {
                    let transformImage = image.transform3by4AndFitScreen()
                    let imageAttachment = ImageAttachment()
                    imageAttachment.image = transformImage
                    let imageAttrString = NSAttributedString(attachment: imageAttachment)
                    mutableAttrText.replaceCharacters(in: range, with: imageAttrString)
                } else if let fileWrapper = attachment.fileWrapper,
                    let data = fileWrapper.regularFileContents {
                    let image = UIImage(data: data)
                    let transformImage = image?.transform3by4AndFitScreen()
                    let imageAttachment = ImageAttachment()
                    imageAttachment.image = transformImage
                    let imageAttrString = NSAttributedString(attachment: imageAttachment)
                    mutableAttrText.replaceCharacters(in: range, with: imageAttrString)
                } else {
                    print("예외상황발생!!!! 처리해야함")
                }
                //
            })
            
            //폰트, 글자 색상 변경
            mutableAttrText.addAttributes([.foregroundColor : Global.textColor,
                                           .font: Global.transformToFont(name: CoreData.sharedInstance.paper.font!),
                                           .paragraphStyle: Global.defaultParagraphStyle],
                                          range: NSMakeRange(0, mutableAttrText.length))
            attrString = mutableAttrText
        }
        return attrString
    }
}

