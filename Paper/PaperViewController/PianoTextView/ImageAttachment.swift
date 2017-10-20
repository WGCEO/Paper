//
//  ImageAttachment.swift
//  Paper
//
//  Created by changi kim on 2017. 9. 26..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class ImageAttachment: NSTextAttachment {
    
    
    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        
        var scalingFactor: CGFloat = 1.0
        
        if let image = self.image {
            let imageSize: CGSize = image.size
            if lineFrag.width - (Global.headIndent * 2) < imageSize.width {
                scalingFactor = (lineFrag.width - (Global.headIndent * 2)) / imageSize.width
            }
            let rect = CGRect(x: Global.headIndent, y: 0, width: imageSize.width * scalingFactor, height: imageSize.height * scalingFactor)
            return rect
        } else {
            return CGRect.zero
        }
    }
}
