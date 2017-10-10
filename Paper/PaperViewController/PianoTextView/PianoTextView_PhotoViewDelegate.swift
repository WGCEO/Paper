//
//  PianoTextView_PhotoViewDelegate.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 9..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

extension PianoTextView: PhotoViewDelegate {
    
    func photoView(_ photoView: PhotoView?, didSelect image: UIImage) {
        //현재 커서 위치의 왼쪽, 오른쪽에 각각 개행이 없으면 먼저 넣어주기
        //우선 왼쪽 범위, 오른쪽 범위가 각각 존재하는 지도 체크해야함.
        
        //왼쪽 범위가 존재하고 && 왼쪽에 개행이 아니면 개행 삽입하기
        if selectedRange.location != 0 && attributedText.attributedSubstring(from: NSMakeRange(selectedRange.location - 1, 1)).string != "\n" {
            insertText("\n")
        }
        
        //오른쪽 범위가 존재하고 오른쪽에 개행이 아니면 개행 삽입하기
        
        
        let attachment = ImageAttachment()
        attachment.image = image
        let attrString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        attrString.addAttributes(defaultAttributes, range: NSMakeRange(0, attrString.length))
        textStorage.replaceCharacters(in: selectedRange, with: attrString)
        CoreData.sharedInstance.textView?.userEdited = true
        
        selectedRange = NSMakeRange(selectedRange.location + 1, 0)
        
        if selectedRange.location < attributedText.length && attributedText.attributedSubstring(from: NSMakeRange(selectedRange.location, 1)).string != "\n" {
            insertText("\n")
        }
        
        scrollRangeToVisible(selectedRange)
    }
}
