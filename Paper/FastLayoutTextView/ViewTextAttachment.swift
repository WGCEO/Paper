//
//  ViewTextAttachment.swift
//  ViewAttachmentTest
//
//  Created by 김범수 on 2018. 1. 22..
//  Copyright © 2018년 piano. All rights reserved.
//

import UIKit

class ImageTextAttachment: NSTextAttachment {

    /**
     * This is the text that will be substituted in pure string of attributed text
     */
    var placeholderText: String!
    
    override func image(forBounds imageBounds: CGRect, textContainer: NSTextContainer?, characterIndex charIndex: Int) -> UIImage? {
        guard let container = textContainer as? FastTextContainer, let textView = container.textView as? PianoTextView else {return nil}
        
        let outImage = !textView.isTyping || (imageBounds.intersects(textView.visibleBounds)) ? image : nil
        
        return outImage
    }
    
    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        return CGRect(x: 0, y: 0, width: 240, height: 180)
    }
}
