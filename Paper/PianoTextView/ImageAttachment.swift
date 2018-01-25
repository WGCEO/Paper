//
//  ImageAttachment.swift
//  Paper
//
//  Created by changi kim on 2017. 9. 26..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class ImageAttachment: NSTextAttachment {
    
    weak var parentTextView: PianoTextView?
    
    override func image(forBounds imageBounds: CGRect, textContainer: NSTextContainer?, characterIndex charIndex: Int) -> UIImage? {
    
        var isVisible = false
        guard let textView = parentTextView else {return nil}
        if let range = textView.visibleRange {
            isVisible = range.contains(charIndex)
        }

        
        return isVisible ? image : nil
    }
    
    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        
        let imageSize: CGSize = image?.size ?? CGSize.zero
        let headIndent = FormManager.sharedInstance.headIndent
//        return CGRect(x: headIndent, y:0, width:240, height: imageSize.height * 240/imageSize.width)
        return CGRect(x:headIndent, y:0, width:240, height: 180)
//        var scalingFactor: CGFloat = 3.0
//
//
//
//        if let image = self.image {
//            let imageSize: CGSize = image.size
//            let headIndent = FormManager.sharedInstance.headIndent
//            if lineFrag.width - (headIndent * 2) < imageSize.width {
//                scalingFactor = (lineFrag.width - (headIndent * 2)) / imageSize.width
//            }
//            let rect = CGRect(x: headIndent, y: 0, width: imageSize.width * scalingFactor, height: imageSize.height * scalingFactor)
//            return CGRect(x: headIndent, y:0, width:249, height: 187)
//        } else {
//            return CGRect.zero
//        }
    }
}
