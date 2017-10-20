//
//  PianoTextView_Effectable.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 9..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

//MARK: Effectable
extension PianoTextView: Effectable {
    
    func preparePiano(from point: CGPoint) -> PianoViewDataTrigger {
        return { [weak self] in
            guard let strongSelf = self
                else {
                    return PianoViewData(rect: CGRect.zero, labelInfos: [])
            }
            
            let relativePoint = point.move(x: 0, y: strongSelf.contentOffset.y + strongSelf.contentInset.top - strongSelf.textContainerInset.top)
            
            let index = strongSelf.layoutManager.glyphIndex(for: relativePoint, in: strongSelf.textContainer)
            var range = NSRange()
            var rect = strongSelf.layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &range)
            rect.origin.y += strongSelf.textContainerInset.top
            rect.origin.x += strongSelf.textContainerInset.left
            //TODO: cover뷰 추가하는 코드. 코드 위치 리펙토링 대상
            strongSelf.addCoverView(rect: rect)
            // effectable 스크롤 안되도록 고정
            strongSelf.isUserInteractionEnabled = false
            //여기까지
            
            let attrText = strongSelf.attributedText.attributedSubstring(from: range).resetParagraphStyle()
            
            var labelInfos: [(label: UILabel, center: CGPoint, frame: CGRect, font: UIFont)] = []
            for (index, character) in attrText.string.enumerated() {
                let pointX = strongSelf.layoutManager.location(forGlyphAt: range.location + index).x
                
                let label = UILabel()
                let attrCharaceter = NSAttributedString(string: String(character), attributes: attrText.attributes(at: index, effectiveRange: nil))
                label.attributedText = attrCharaceter
                label.sizeToFit()
                label.frame.origin.x = pointX + strongSelf.textContainerInset.left + strongSelf.contentInset.left
                label.frame.origin.y = rect.origin.y - strongSelf.contentOffset.y
                labelInfos.append((label: label, center: label.center, frame: label.frame, font: label.font))
            }
            return PianoViewData(rect: rect, labelInfos: labelInfos)
        }
    }
    
    func endPiano(with result: PianoResult) {
        setAttribute(with: result)
        removeCoverView()
        isUserInteractionEnabled = true
    }
}

//MARK: Piano
extension PianoTextView {
    internal func addCoverView(rect: CGRect) {
        removeCoverView()
        let coverView = UIView()
        coverView.backgroundColor = backgroundColor
        coverView.frame = rect
        insertSubview(coverView, belowSubview: control)
        
        self.coverView = coverView
    }
    
    internal func attachControl() {
        control.removeFromSuperview()
        let point = CGPoint(x: 0, y: contentOffset.y + contentInset.top)
        var size = bounds.size
        size.height -= (contentInset.top + contentInset.bottom)
        control.frame = CGRect(origin: point, size: size)
        addSubview(control)
    }
    
    internal func detachControl() {
        control.removeFromSuperview()
    }
    
    internal func removeCoverView(){
        coverView?.removeFromSuperview()
        coverView = nil
    }
    
    internal func setAttribute(with result: PianoResult) {
        
        //TODO: 2는 어떤 줄이 윗 줄에 적용되는 버그에 대한 임시 해결책
        let final = result.final.move(x: -textContainerInset.left, y: -textContainerInset.top + 2)
        let farLeft = result.farLeft.move(x: -textContainerInset.left, y: -textContainerInset.top + 2)
        let farRight = result.farRight.move(x: -textContainerInset.left, y: -textContainerInset.top + 2)
        
        let applyRange = getRangeForApply(farLeft: farLeft, final: final)
        if applyRange.length > 0 {
            
            layoutManager.textStorage?.addAttributes(result.applyAttribute, range: applyRange)
            userEdited = true
            CoreData.sharedInstance.paper.modifiedDate = Date()
        }
        
        let removeRange = getRangeForRemove(final: final, farRight: farRight)
        if removeRange.length > 0 {
            let mutableAttrText = NSMutableAttributedString(attributedString: attributedText)
            mutableAttrText.addAttributes(result.removeAttribute, range: removeRange)
            attributedText = mutableAttrText
            layoutManager.textStorage?.addAttributes(result.removeAttribute, range: removeRange)
            userEdited = true
            CoreData.sharedInstance.paper.modifiedDate = Date()
        }
    }
    
    internal func getRangeForApply(farLeft: CGPoint, final: CGPoint) -> NSRange {
        let beginIndex = layoutManager.glyphIndex(for: farLeft, in: textContainer)
        let endIndex = layoutManager.glyphIndex(for: final, in: textContainer)
        let endFrame = layoutManager.boundingRect(forGlyphRange: NSMakeRange(endIndex, 1), in: textContainer)
        
        let length = endFrame.origin.x + endFrame.size.width < final.x ? endIndex - beginIndex + 1 : endIndex - beginIndex
        
        return NSRange(location: beginIndex, length: length)
    }
    
    internal func getRangeForRemove(final: CGPoint, farRight: CGPoint) -> NSRange {
        let beginIndex = layoutManager.glyphIndex(for: final, in: self.textContainer)
        let endIndex = layoutManager.glyphIndex(for: farRight, in: self.textContainer)
        let beginFrame = layoutManager.boundingRect(forGlyphRange: NSMakeRange(beginIndex, 1), in: self.textContainer)
        let location = beginFrame.origin.x > final.x ? beginIndex : beginIndex + 1
        let length = beginFrame.origin.x > final.x ? endIndex - beginIndex + 1 : endIndex - beginIndex
        return NSRange(location: location, length: length)
    }
}
