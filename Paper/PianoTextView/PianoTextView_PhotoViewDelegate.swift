//
//  PianoTextView_PhotoViewDelegate.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 9..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

extension PianoTextView: PhotoViewDelegate {
    
    internal func insertNewLineToLeftSideIfNeeded(location: Int){
        if location != 0 && attributedText.attributedSubstring(from: NSMakeRange(location - 1, 1)).string != "\n" {
            insertText("\n")
        }
    }
    
    internal func insertNewlineToRightSideIfNeeded(location: Int){
        if location < attributedText.length && attributedText.attributedSubstring(from: NSMakeRange(location, 1)).string != "\n" {
            insertText("\n")
        }
    }
    
    func photoView(_ photoView: PhotoView?, didSelect image: UIImage) {
        //현재 커서 위치의 왼쪽, 오른쪽에 각각 개행이 없으면 먼저 넣어주기
        //우선 왼쪽 범위, 오른쪽 범위가 각각 존재하는 지도 체크해야함.
        
        //왼쪽 범위가 존재하고 && 왼쪽에 개행이 아니면 개행 삽입하기
        insertNewLineToLeftSideIfNeeded(location: selectedRange.location)
        
       
        let imageURL = NSURL(string: "https://www.cocoanetics.com/files/Cocoanetics_Square.jpg")!
//        let attachment = ImageAttachment(data: <#T##Data?#>, ofType: <#T##String?#>)//AsyncTextAttachment(imageURL: imageURL)
        //        attachment.displaySize = CGSize(width: 100, height: 134)
        //        attachment.image = UIImage.placeholder(UIColor.grayColor(), size: attachment.displaySize!)
//        let attrString = NSMutableAttributedString(attributedString:NSAttributedString(attachment: attachment))
        
        let attachment = ImageTextAttachment()
        attachment.image = image
//        attachment.parentTextView = self
//        attachment.contents = "Hii".data(using: .utf8)
        let attrString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        attrString.addAttributes(FormManager.sharedInstance.defaultAttributes, range: NSMakeRange(0, attrString.length))
        textStorage.replaceCharacters(in: selectedRange, with: attrString)
        Reference.sharedInstance.textView?.userEdited = true
        
        selectedRange = NSMakeRange(selectedRange.location + 1, 0)
        
        //오른쪽 범위가 존재하고 오른쪽에 개행이 아니면 개행 삽입하기
        insertNewlineToRightSideIfNeeded(location: selectedRange.location)
        
        scrollRangeToVisible(selectedRange)
    }
}
