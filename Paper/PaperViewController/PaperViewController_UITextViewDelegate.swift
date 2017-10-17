//
//  PaperViewController_UITextViewDelegate.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 12..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

extension PaperViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let textView = textView as? PianoTextView,
            CoreData.sharedInstance.preference.showMirroring,
            kbHeight != nil {
            textView.mirrorScrollView.showMirroring(from: textView)
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if let textView = textView as? PianoTextView, CoreData.sharedInstance.preference.showMirroring, kbHeight != nil {
            textView.mirrorScrollView.showMirroring(from: textView)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let textView = textView as? PianoTextView else { return true}
        
        let currentParagraphRange = textView.rangeForCurrentParagraph()
        
        if textView.attributedText.containsAttachments(in: currentParagraphRange)
            && !textView.attributedText.containsAttachments(in: range)
            && text != "\n"
            && text != "" {
            textView.jumpCursorToRightSide(paragraphRange: currentParagraphRange)
        }
        
        return textView.removeAttrOrInsertFormAtNextLineifNeeded(in: currentParagraphRange, replacementText: text)
    }
    
    //현재 문단에 이미지가 있는데, 양 옆에 개행이 없는 곳이 있다면 넣어주기
    
    func textViewDidChange(_ textView: UITextView) {
        guard let textView = textView as? PianoTextView else { return }
        
        textView.userEdited = true
        CoreData.sharedInstance.paper.modifiedDate = Date()
        textView.addAttrToFormIfNeeded(in: textView.rangeForCurrentParagraph())
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let textView = scrollView as? PianoTextView, !textView.isEditable else { return }
        textView.attachControl()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let textView = scrollView as? PianoTextView, !textView.isEditable, !decelerate else { return }
        textView.attachControl()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let textView = scrollView as? PianoTextView, !textView.isEditable else { return }
        textView.detachControl()
    }

}
