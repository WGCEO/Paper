//
//  PianoTextView_Cursor.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 9..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

//MARK: move cursor
extension PianoTextView {
    //텍스트 길이가 현재 커서 + 로케이션 + 1 이고 && 그 맨 마지막 텍스트가 개행인 경우 마지막 텍스트를 지워버리기.
//    internal func moveCursorToKeyboardTop(from textView: UITextView){
//
//        //TODO: 원인 모를 버그: 현재 커서 바로 다음에 개행이 딱 하나만 있으면 커서 추적이 이상하게 됨.
//        if selectedRange.location + selectedRange.length + 1 == attributedText.length {
//            let nextRange = NSMakeRange(selectedRange.location + selectedRange.length, 1)
//            if let nextTextRange = nextRange.toTextRange(textInput: textView),
//                let text = text(in: nextTextRange), text == "\n" {
//                textStorage.replaceCharacters(in: nextRange, with: "")
//            }
//        }
//
//        if let cursorTextPosition = textView.selectedTextRange?.end {
//            let cursorRect = textView.caretRect(for: cursorTextPosition)
//            moveCursor(from: cursorRect)
//        }
//    }
//
//    internal func moveCursor(from: CGRect){
//        guard let kbHeight = self.kbHeight else { return }
//        let screenHeight = UIScreen.main.bounds.height
//        let desY = screenHeight - (from.origin.y + from.size.height + kbHeight)
//
//        UIView.animate(withDuration: 0.3) { [weak self] in
//            guard let strongSelf = self else { return }
//            if desY > 0 {
//                strongSelf.contentInset.top = desY
//            }
//            strongSelf.contentInset.bottom = kbHeight - strongSelf.textContainerInset.bottom
//            strongSelf.contentOffset.y = -desY
//        }
//    }
    
    internal func jumpCursorToRightSide(paragraphRange: NSRange) {
        attributedText.enumerateAttribute(.attachment, in: paragraphRange, options: [], using: { (value, range, stop) in
            guard value is NSTextAttachment else { return }
            
            
            if selectedRange.location > range.location {
                //커서가 이미지보다 오른쪽에 있고 오른쪽이 존재하지 않는다면, 엔터 삽입, 존재한다면,오른쪽으로 이동
                if selectedRange.location + selectedRange.length <= attributedText.length {
                    insertText("\n")
                    return
                }
                selectedRange.location += 1
            } else {
                //커서가 이미지보다 왼쪽에 있다면 우선 이미지 오른쪽으로 옮긴다.
                selectedRange.location = range.location + range.length
                
                //오른쪽일 때와 동일 코드 삽입
                if selectedRange.location + selectedRange.length <= attributedText.length {
                    insertText("\n")
                    return
                }
                selectedRange.location += 1
            }
            
            stop.pointee = true
        })
    }
}
