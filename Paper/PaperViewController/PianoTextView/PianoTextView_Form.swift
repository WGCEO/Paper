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
    internal func removeAttrOrInsertFormAtNextLineifNeeded(in range: NSRange, replacementText text: String) -> Bool {
        if let bool = detectCompletedNumbering(in: range, replacementText: text) {
            return bool
        } else if let bool = detectCompletedListing(in: range, replacementText: text) {
            return bool
        } else if let bool = detectCompletedAsterisk(in: range, replacementText: text) {
            return bool
        } else if let bool = detectCompletedAt(in: range, replacementText: text) {
            return bool
        } else { return true }
    }
    
    private func detectCompletedNumbering(in range: NSRange, replacementText: String) -> Bool? {
        guard let numRange = formRange(paraRange: range, regexString: Global.numRegex)
            else { return nil }
        //여기서 2는 점과 띄어쓰기 length
        let formatRange = NSMakeRange(range.location, numRange.location + numRange.length + 2 - range.location)
        
        //커서가 영역 내에 존재하거나 영역 내에 존재하지 않지만 백스페이스 동작이고 커서 로케이션이 영역바로 다음에 위치해 있는 경우
        if  cursorIn(formatRange: formatRange) ||
            cursorWillBeIn(formRange: formatRange, replacementText: replacementText) {
            resetNumStyle(currentParaRange: range, numRange: numRange)
            
        } else if inputNewLine(replacementText: replacementText) {
            if existTextAfterForm(paraRange: range, formRange: formatRange) {
                addNumToNextParagraph(formRange: formatRange, numRange: numRange)
                return false
            } else {
                //텍스트가 없다면 해당 패러그랲 스타일 리셋시켜버리고 다 지워버리기
                deleteNum(to: range, numRange: numRange)
                return false
            }
        }
        return true
    }
    
    private func detectCompletedListing(in range: NSRange, replacementText: String) -> Bool? {
        guard let listRange = formRange(paraRange: range, regexString: Global.listRegex)
            else { return nil }
        let formatRange = NSMakeRange(range.location, listRange.location + listRange.length  + 1 - range.location)
        
        if cursorIn(formatRange: formatRange) ||
            cursorWillBeIn(formRange: formatRange, replacementText: replacementText) {
            resetListStyle(currentParaRange: range, listRange: listRange)
            
        } else if inputNewLine(replacementText: replacementText) {
            if existTextAfterForm(paraRange: range, formRange: formatRange) {
                addListToNextParagraph(formRange: formatRange)
                return false
            } else {
                deleteList(to: range, listRange: listRange)
                return false
            }
        }
        return true
    }
    
    private func detectCompletedAsterisk(in range: NSRange, replacementText: String) -> Bool? {
        guard let asteriskRange = formRange(paraRange: range, regexString: Global.asteriskRegex)
            else { return nil }
        let formatRange = NSMakeRange(range.location, asteriskRange.location + asteriskRange.length  + 1 - range.location)
        
        if cursorIn(formatRange: formatRange) ||
            cursorWillBeIn(formRange: formatRange, replacementText: replacementText) {
            resetAsteriskStyle(currentParaRange: range, asteriskRange: asteriskRange)
            
        } else if inputNewLine(replacementText: replacementText) {
            if existTextAfterForm(paraRange: range, formRange: formatRange) {
                addAsteriskToNextParagraph(formRange: formatRange)
                return false
            } else {
                deleteAsterisk(to: range, asteriskRange: asteriskRange)
                return false
            }
        }
        return true
    }
    
    private func detectCompletedAt(in range: NSRange, replacementText: String) -> Bool? {
        guard let atRange = formRange(paraRange: range, regexString: Global.atRegex)
            else { return nil }
        let formatRange = NSMakeRange(range.location, atRange.location + atRange.length  + 1 - range.location)
        
        if cursorIn(formatRange: formatRange) ||
            cursorWillBeIn(formRange: formatRange, replacementText: replacementText) {
            resetAtStyle(currentParaRange: range, atRange: atRange)
            
        } else if inputNewLine(replacementText: replacementText) {
            if existTextAfterForm(paraRange: range, formRange: formatRange) {
                addAtToNextParagraph(formRange: formatRange)
                return false
            } else {
                deleteAt(to: range, atRange: atRange)
                return false
            }
        }
        return true
    }
    
    private func deleteNum(to range: NSRange, numRange: NSRange){
        textStorage.addAttributes([
            .font : CoreData.sharedInstance.paperFont,
            .foregroundColor : Global.textColor,
            .paragraphStyle : Global.defaultParagraphStyle], range: range)
        //다음 행이 있다면 지워졌던 개행도 삽입해줘야함
        let existNextParagraph = attributedText.length > range.location + range.length
        textStorage.replaceCharacters(in: range, with: existNextParagraph ? "\n" : "")
        if existNextParagraph {
            //숫자 + 점 + 띄어쓰기 + 를 지웠으므로 커서를 다시 왼쪽으로 돌려놓아야함
            selectedRange.location -= (numRange.length + 2 + numRange.location - range.location)
        }
    }
    
    private func deleteList(to range: NSRange, listRange: NSRange) {
        //텍스트가 없다면 해당 패러그랲 스타일 리셋시켜버리고 다 지워버리기
        textStorage.addAttributes([
            .font : CoreData.sharedInstance.paperFont,
            .foregroundColor : Global.textColor,
            .paragraphStyle : Global.defaultParagraphStyle],
                                  range: range)
        //다음 행이 있다면 지워졌던 개행도 삽입해줘야함
        let existNextParagraph = attributedText.length > range.location + range.length
        textStorage.replaceCharacters(in: range, with: existNextParagraph ? "\n" : "")
        if existNextParagraph {
            //리스트 + 띄어쓰기 를 지웠으므로 커서를 다시 왼쪽으로 돌려놓아야함
            selectedRange.location -= (listRange.length + 1 + listRange.location - range.location)
        }
    }
    
    private func deleteAsterisk(to range: NSRange, asteriskRange: NSRange) {
        //텍스트가 없다면 해당 패러그랲 스타일 리셋시켜버리고 다 지워버리기
        textStorage.addAttributes([
            .font : CoreData.sharedInstance.paperFont,
            .foregroundColor : Global.textColor,
            .paragraphStyle : Global.defaultParagraphStyle],
                                  range: range)
        //다음 행이 있다면 지워졌던 개행도 삽입해줘야함
        let existNextParagraph = attributedText.length > range.location + range.length
        textStorage.replaceCharacters(in: range, with: existNextParagraph ? "\n" : "")
        if existNextParagraph {
            //리스트 + 띄어쓰기 를 지웠으므로 커서를 다시 왼쪽으로 돌려놓아야함
            selectedRange.location -= (asteriskRange.length + 1 + asteriskRange.location - range.location)
        }
    }
    
    private func deleteAt(to range: NSRange, atRange: NSRange) {
        //텍스트가 없다면 해당 패러그랲 스타일 리셋시켜버리고 다 지워버리기
        textStorage.addAttributes([
            .font : CoreData.sharedInstance.paperFont,
            .foregroundColor : Global.textColor,
            .paragraphStyle : Global.defaultParagraphStyle],
                                  range: range)
        //다음 행이 있다면 지워졌던 개행도 삽입해줘야함
        let existNextParagraph = attributedText.length > range.location + range.length
        textStorage.replaceCharacters(in: range, with: existNextParagraph ? "\n" : "")
        if existNextParagraph {
            //리스트 + 띄어쓰기 를 지웠으므로 커서를 다시 왼쪽으로 돌려놓아야함
            selectedRange.location -= (atRange.length + 1 + atRange.location - range.location)
        }
    }
    
    private func resetNumStyle(currentParaRange: NSRange, numRange: NSRange) {
        let numAndDotRange = NSMakeRange(numRange.location, numRange.length + 1)
        textStorage.addAttributes([.foregroundColor : Global.textColor,
                                   .font : CoreData.sharedInstance.paperFont],
                                  range: numAndDotRange)
        textStorage.addAttributes([.paragraphStyle : Global.defaultParagraphStyle],
                                  range: currentParaRange)
    }
    
    private func resetListStyle(currentParaRange: NSRange, listRange: NSRange) {
        let mutableAttrText = NSMutableAttributedString(string: "-", attributes: [
            .font : CoreData.sharedInstance.paperFont,
            .foregroundColor : Global.textColor])
        textStorage.replaceCharacters(in: listRange, with: mutableAttrText)
        textStorage.addAttributes([.paragraphStyle : Global.defaultParagraphStyle], range: currentParaRange)
    }
    
    private func resetAsteriskStyle(currentParaRange: NSRange, asteriskRange: NSRange) {
        let mutableAttrText = NSMutableAttributedString(string: "*", attributes: [
            .font : CoreData.sharedInstance.paperFont,
            .foregroundColor : Global.textColor])
        textStorage.replaceCharacters(in: asteriskRange, with: mutableAttrText)
        textStorage.addAttributes([.paragraphStyle : Global.defaultParagraphStyle], range: currentParaRange)
    }
    
    private func resetAtStyle(currentParaRange: NSRange, atRange: NSRange) {
        let mutableAttrText = NSMutableAttributedString(string: "@", attributes: [
            .font : CoreData.sharedInstance.paperFont,
            .foregroundColor : Global.textColor])
        textStorage.replaceCharacters(in: atRange, with: mutableAttrText)
        textStorage.addAttributes([.paragraphStyle : Global.defaultParagraphStyle], range: currentParaRange)
    }
    
    private func existTextAfterForm(paraRange: NSRange, formRange: NSRange) -> Bool {
        let behindRange = NSMakeRange(formRange.location + formRange.length, paraRange.location + paraRange.length - (formRange.location + formRange.length))
        let str = attributedText.attributedSubstring(from: behindRange).string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return str.count != 0 ? true : false
    }
    
    private func addNumToNextParagraph(formRange: NSRange, numRange: NSRange){
        let formString = NSMutableAttributedString(attributedString: attributedText.attributedSubstring(from: formRange))
        let numRangeInForm = NSMakeRange(numRange.location - formRange.location, numRange.length)
        let nextNumber = UInt64(formString.attributedSubstring(from: numRangeInForm).string)! + 1
        
        formString.replaceCharacters(in: numRangeInForm, with: String(nextNumber))
        insertText("\n")
        textStorage.replaceCharacters(in: selectedRange, with: formString)
        selectedRange.location += formString.length
    }
    
    private func addListToNextParagraph(formRange: NSRange) {
        let formString = NSMutableAttributedString(attributedString: attributedText.attributedSubstring(from: formRange))
        insertText("\n")
        textStorage.replaceCharacters(in: selectedRange, with: formString)
        selectedRange.location += formString.length
    }
    
    private func addAsteriskToNextParagraph(formRange: NSRange) {
        let formString = NSMutableAttributedString(attributedString: attributedText.attributedSubstring(from: formRange))
        insertText("\n")
        textStorage.replaceCharacters(in: selectedRange, with: formString)
        selectedRange.location += formString.length
    }
    
    private func addAtToNextParagraph(formRange: NSRange) {
        let formString = NSMutableAttributedString(attributedString: attributedText.attributedSubstring(from: formRange))
        insertText("\n")
        textStorage.replaceCharacters(in: selectedRange, with: formString)
        selectedRange.location += formString.length
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
    
    internal func addAttrToFormIfNeeded(in currentParaRange: NSRange, mutableAttrString: NSMutableAttributedString) {
        if var numRange = detectNumbering(in: currentParaRange) {
            if numRange.length > 20 {
                //예외처리(UInt가 감당할 수 있는 숫자 제한, true를 리턴하면, 숫자는 감지했지만 아무것도 할 수 없음을 의미함)
                return
            }
            
            replaceNumIfNeeded(currentParaRange: currentParaRange, numRange: &numRange)
            let newParaRange = rangeForParagraph(with: numRange)
            addAttributeForNumbering(paraRange: newParaRange ,numRange: numRange, mutableAttrString: mutableAttrString)
            replaceNextNumsIfNeeded(numRange: &numRange)
            
            
            return
        } else if let listRange = detectListing(in: currentParaRange) {
            replaceListIfNeeded(listRange: listRange)
            addAttributeForListing(paraRange: currentParaRange, listRange: listRange, mutableAttrString: mutableAttrString)
            
            return
        } else if let asteriskRange = detectAsterisk(in: currentParaRange) {
            replaceAsteriskIfNeeded(asteriskRange: asteriskRange)
            addAttributeForAsterisk(paraRange: currentParaRange, asteriskRange: asteriskRange, mutableAttrString: mutableAttrString)
            return
        } else if let atRange = detectAt(in: currentParaRange) {
            replaceAtIfNeeded(atRange: atRange)
            addAttributeForAt(paraRange: currentParaRange, atRange: atRange, mutableAttrString: textStorage)
            return
        } else if let circleRange = detectCircle(in: currentParaRange) {
            addAttributeForCircle(paraRange: currentParaRange, circleRange: circleRange, mutableAttrString: mutableAttrString)
            return
        } else if let _ = detectRef(in: currentParaRange){
            return
        } else if let _ = detectStar(in: currentParaRange){
            return
        } else {
            //서식 없는 경우
            mutableAttrString.addAttributes([.paragraphStyle : Global.defaultParagraphStyle], range: currentParaRange)
            return
        }
    }
    
    internal func detectCompletedForm(in range: NSRange) -> Bool {
        return detectNumbering(in: range) != nil || detectRef(in: range) != nil || detectCircle(in: range) != nil || detectStar(in:range) != nil
    }
    
    private func detectNumbering(in range: NSRange) -> NSRange? {
        guard let numRange = formRange(paraRange: range, regexString: Global.numRegex)
            else { return nil }
        return numRange
    }
    
    
    
    private func detectListing(in range: NSRange) -> NSRange? {
        guard let listRange = formRange(paraRange: range, regexString: Global.listRegex)
            else { return nil }
        return listRange
    }
    
    private func detectAsterisk(in range: NSRange) -> NSRange? {
        guard let asteriskRange = formRange(paraRange: range, regexString: Global.asteriskRegex)
            else { return nil }
        return asteriskRange
    }
    
    private func detectAt(in range: NSRange) -> NSRange? {
        guard let atRange = formRange(paraRange: range, regexString: Global.atRegex)
            else { return nil }
        return atRange
    }
    
    private func detectCircle(in range: NSRange) -> NSRange? {
        guard let circleRange = formRange(paraRange: range, regexString: Global.listRegex)
            else { return nil }
        return circleRange
    }
    
    private func detectStar(in range: NSRange) -> NSRange? {
        guard let starRange = formRange(paraRange: range, regexString: Global.asteriskRegex)
            else { return nil }
        return starRange
    }
    
    private func detectRef(in range: NSRange) -> NSRange? {
        guard let refRange = formRange(paraRange: range, regexString: Global.atRegex)
            else { return nil }
        return refRange
    }
    
    private func formRange(paraRange: NSRange, regexString: String) -> NSRange? {
        do {
            let regularExpression = try NSRegularExpression(pattern: regexString, options: .anchorsMatchLines)
            guard let result = regularExpression.matches(in: text, options: .withTransparentBounds, range: paraRange).first else { return nil }
            
            return result.range(at: 1)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    private func replaceNumIfNeeded(currentParaRange: NSRange, numRange: inout NSRange){
        //이전 패러그랲이 없으면 리턴
        guard currentParaRange.location != 0
            else { return }
        let prevParaRange = rangeForParagraph(with: NSMakeRange(currentParaRange.location - 1, 0))
        guard let prevNumRange = formRange(paraRange: prevParaRange, regexString: Global.numRegex)
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
    
    private func replaceNextNumsIfNeeded(numRange: inout NSRange){
        var currentParaRange = rangeForParagraph(with: numRange)
        while currentParaRange.location + currentParaRange.length < attributedText.length {
            let nextParaRange = rangeForParagraph(with: NSMakeRange(currentParaRange.location + currentParaRange.length + 1, 0))
            guard let nextNumRange = formRange(paraRange: nextParaRange, regexString: Global.numRegex)
                else { return }
            let nextGapRange = NSMakeRange(nextParaRange.location,
                                           nextNumRange.location - nextParaRange.location)
            let currGapRange = NSMakeRange(currentParaRange.location,
                                           numRange.location - currentParaRange.location)
            guard attributedText.attributedSubstring(from: currGapRange).string ==
                attributedText.attributedSubstring(from: nextGapRange).string,
                UInt(attributedText.attributedSubstring(from: nextNumRange).string)! - 1 !=
                    UInt(attributedText.attributedSubstring(from: numRange).string)!
                else { return }
            
            let correctNextNum = "\(Int(attributedText.attributedSubstring(from: numRange).string)! + 1)"
            textStorage.replaceCharacters(in: nextNumRange, with: correctNextNum)
            numRange = NSMakeRange(nextNumRange.location, correctNextNum.count)
            let newParaRange = rangeForParagraph(with: numRange)
            addAttributeForNumbering(paraRange: newParaRange,numRange: numRange, mutableAttrString: textStorage)
            currentParaRange = rangeForParagraph(with: numRange)
        }
    }
    
    private func replaceListIfNeeded(listRange: NSRange) {
        textStorage.replaceCharacters(in: listRange, with: "•")
    }
    
    private func replaceAsteriskIfNeeded(asteriskRange: NSRange) {
        textStorage.replaceCharacters(in: asteriskRange, with: "★")
    }
    
    private func replaceAtIfNeeded(atRange: NSRange) {
        textStorage.replaceCharacters(in: atRange, with: "※")
    }
    
    private func addAttributeForNumbering(paraRange: NSRange, numRange: NSRange, mutableAttrString: NSMutableAttributedString) {
        let numberingFont = UIFont(name: "Avenir Next",
                                   size: CoreData.sharedInstance.paperFont.pointSize)!
        
        let dotRange = NSMakeRange(numRange.location + numRange.length, 1)
        let gapRange = NSMakeRange(paraRange.location, numRange.location - paraRange.location)
        mutableAttrString.addAttributes([.font : numberingFont,
                                   .foregroundColor : CoreData.sharedInstance.paperColor],
                                  range: numRange)
        mutableAttrString.addAttributes([.foregroundColor : UIColor.lightGray,
                                   .font : CoreData.sharedInstance.paperFont],
                                  range: dotRange)
        mutableAttrString.addAttributes([.paragraphStyle : numParagraphStyle(gapRange: gapRange)],
                                  range: paraRange)
    }
    
    private func addAttributeForListing(paraRange: NSRange, listRange: NSRange, mutableAttrString: NSMutableAttributedString) {
        let gapRange = NSMakeRange(paraRange.location, listRange.location - paraRange.location)
        
        mutableAttrString.addAttributes([
            .font : CoreData.sharedInstance.paperFont,
            .foregroundColor : CoreData.sharedInstance.paperColor,
            .kern : circleKern], range: listRange)
        mutableAttrString.addAttributes([.paragraphStyle : circleParagraphStyle(gapRange: gapRange)], range: paraRange)
    }
    
    private func addAttributeForAsterisk(paraRange: NSRange, asteriskRange: NSRange, mutableAttrString: NSMutableAttributedString) {
        let gapRange = NSMakeRange(paraRange.location, asteriskRange.location - paraRange.location)
        mutableAttrString.addAttributes([
            .font : CoreData.sharedInstance.paperFont,
            .foregroundColor : CoreData.sharedInstance.paperColor,
            .kern : starKern], range: asteriskRange)
        
        mutableAttrString.addAttributes([.paragraphStyle : starParagraphStyle(gapRange: gapRange)], range: paraRange)
    }
    
    private func addAttributeForAt(paraRange: NSRange, atRange: NSRange, mutableAttrString: NSMutableAttributedString) {
        let gapRange = NSMakeRange(paraRange.location, atRange.location - paraRange.location)
        mutableAttrString.addAttributes([
            .font : CoreData.sharedInstance.paperFont,
            .foregroundColor : CoreData.sharedInstance.paperColor,
            .kern : refKern], range: atRange)
        
        mutableAttrString.addAttributes([.paragraphStyle : refParagraphStyle(gapRange: gapRange)], range: paraRange)
    }
    
    private func addAttributeForCircle(paraRange: NSRange, circleRange: NSRange, mutableAttrString: NSMutableAttributedString) {
        let gapRange = NSMakeRange(paraRange.location, circleRange.location - paraRange.location)
        mutableAttrString.addAttributes([
            .font : CoreData.sharedInstance.paperFont,
            .foregroundColor : CoreData.sharedInstance.paperColor,
            .kern : circleKern], range: circleRange)
        
        mutableAttrString.addAttributes([.paragraphStyle : circleParagraphStyle(gapRange: gapRange)], range: paraRange)
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

