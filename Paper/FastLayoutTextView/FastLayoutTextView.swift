//
//  FastLayoutTextView.swift
//  ViewAttachmentTest
//
//  Created by 김범수 on 2018. 1. 23..
//  Copyright © 2018년 piano. All rights reserved.
//

import UIKit


class FastLayoutTextView: UITextView, UIScrollViewDelegate {
    
    /*
     * attachment attribute들이 img tag로 치환된 string
     */
    var unmarkedString: NSAttributedString {
        let attributedString = NSMutableAttributedString.init(attributedString: self.textStorage)
        
        textStorage.enumerateAttributes(in: NSMakeRange(0, attributedString.length), options: .reverse) { (dic, range, _) in
            if let attachment = dic[NSAttributedStringKey.attachment] as? ImageTextAttachment {
                attributedString.replaceCharacters(in: range, with: attachment.placeholderText)
            }
        }
        
        return attributedString
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        let container = FastTextContainer()
        container.widthTracksTextView = true
        
        let textStorage = NSTextStorage(string: "")
        
        let layoutManger = FastLayoutManager()
        
        
        textStorage.addLayoutManager(layoutManger)
        layoutManger.addTextContainer(container)
        layoutManger.allowsNonContiguousLayout = true
        
        super.init(frame: frame, textContainer: container)
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
    }
    
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        let newTextView = FastLayoutTextView(frame: self.frame)
        var constraints: Array<NSLayoutConstraint> = []
        self.constraints.forEach {
            let firstItem: AnyObject!, secondItem: AnyObject!
            
            if let unwrappedFirst = $0.firstItem as? FastLayoutTextView, unwrappedFirst == self {
                firstItem = self
            } else {
                firstItem = $0.firstItem
            }
            
            if let unwrappedSecond = $0.secondItem as? FastLayoutTextView, unwrappedSecond == self {
                secondItem = self
            } else {
                secondItem = $0.secondItem
            }
            
            constraints.append(
                NSLayoutConstraint(item: firstItem,
                                   attribute: $0.firstAttribute,
                                   relatedBy: $0.relation,
                                   toItem: secondItem,
                                   attribute: $0.secondAttribute,
                                   multiplier: $0.multiplier,
                                   constant: $0.constant))
        }
        
        
        /*Note 여기서 스토리보드에서 세팅한 값이 전부 투영되어야한다. 현재는 constraints와 text만*/
        
        newTextView.addConstraints(constraints)
        newTextView.autoresizingMask = self.autoresizingMask
        newTextView.translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints
        newTextView.attributedText = self.attributedText
        newTextView.tag = self.tag

        return newTextView
    }
}

class FastLayoutManager: NSLayoutManager {
//    override func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
//
//        guard let container = textContainer(forGlyphAt: glyphsToShow.location, effectiveRange: nil) as? FastTextContainer, let textView = container.textView, let visibleRange = textView.visibleRange else {return}
//
////        print("\(glyphsToShow) \(visibleRange)")
//        if let _ = glyphsToShow.intersection(visibleRange) {
//            super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)
//        }
////        self.textStorage?.enumerateAttribute(.attachment, in: NSMakeRange(0, textStorage?.length ?? 0), options: .longestEffectiveRangeNotRequired, using: { (value, range, _) in
////            guard let attachment = value as? ImageTextAttachment else {return}
////            if let _ = glyphsToShow.intersection(range) {
////                attachment.isVisible = true
////            } else {
////                attachment.isVisible = false
////            }
////
////        })
//
//
////        super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)
//
//    }
}
extension NSRange {
    func tooFar(range: NSRange) -> Bool {
        if range.location > self.location {
            return (range.location - (self.location+self.length)) > 4
        } else {
            return (self.location - (range.location+range.length)) > 4
        }
    }
}

extension UITextView {
    var visibleRange: NSRange? {
        if let start = closestPosition(to: contentOffset) {
            
            if let end = characterRange(at: CGPoint(x: contentOffset.x + bounds.maxX, y: contentOffset.y + bounds.maxY))?.end {
                return NSMakeRange(offset(from: beginningOfDocument, to: start), offset(from: start, to: end))
            }
        }
        return nil
    }
    
    var visibleBounds: CGRect {
        return CGRect(x: self.contentOffset.x, y:self.contentOffset.y,width: self.bounds.size.width,height: self.bounds.size.height)
    }
}


class FastTextContainer: NSTextContainer {
    weak var textView: UITextView?
}
