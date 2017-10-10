//
//  PianoTextView_UITextViewDelegate.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 9..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

//MARK: TextViewDelegate
extension PianoTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if CoreData.sharedInstance.preference.showMirroring {
            mirrorScrollView.showMirroring(from: textView)
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if CoreData.sharedInstance.preference.showMirroring {
            mirrorScrollView.showMirroring(from: textView)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentParagraphRange = textView.rangeForCurrentParagraph()
        
        if attributedText.containsAttachments(in: currentParagraphRange)
            && !attributedText.containsAttachments(in: range)
            && text != "\n"
            && text != "" {
            jumpCursorToRightSide(paragraphRange: currentParagraphRange)
        }
        
        return removeAttrOrInsertFormAtNextLineifNeeded(in: currentParagraphRange, replacementText: text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        userEdited = true
        CoreData.sharedInstance.paper.modifiedDate = Date()
        addAttrToFormIfNeeded(in: rangeForCurrentParagraph())
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
