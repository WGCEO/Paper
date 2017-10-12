//
//  Primitive_Extension.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 9..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

extension NSAttributedString {
    func resetParagraphStyle() -> NSAttributedString {
        let mutableAttrString = NSMutableAttributedString(attributedString: self)
        let paragraphStyle = NSParagraphStyle()
        if mutableAttrString.length != 0 {
            mutableAttrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
        }
        return mutableAttrString
    }
    
    //썸네일이 존재하면(nil이 아니면), 무조건 더보기가 있어야 함.
    //1. 썸네일은 첫 3문단 안에 이미지가 있을 경우 생김
    //2. 썸네일은 첫 3문단이 300글자를 넘어갈 경우 생김(300글자를 잘라줌)
    //3. 썸네일은 전체 스트링이 3문단을 넘어갈 경우 생김
    
    //1. 전체 스트링이 4문단 이상이면 3문단까지 자른 썸네일 생성
    //1-1. 3문단까지 자른 썸네일을 문단을 돌면서 이미지가 있다면 거기까지 잘라 썸네일 생성
    //1-1. 3문단까지 자른 썸네일을 문단을 돌면서 300글자가 넘어가면 거기까지 잘라 썸네일 생성
    
    //2. 전체 스트링이 4문단 미만인데 이미지 존재하면 거기까지 잘라 썸네일 생성(단, 전체 스트링이 이미지 존재하는 문단까지만 있다면 nil, 이걸 확인하기 위해선 다음문단이 없어야 함)
    //3. 전체 스트링이 4문단 미만인데 300글자를 넘어가면 300글자까지 잘라 썸네일 생성
    //4. 전체 스트링이 4문단 미만인데 300글자를 넘지 않고, 전체 스트링의 길이와 같다면 nil
    
    func thumbnailAttrString() -> NSAttributedString? {
        var index = 0
        var paragraphCount = 1
        let result = NSMutableAttributedString()
        
        if string.split(separator: "\n").count > 3 {
            //4문단 이상이면 3문단까지만 문단을 돌고, 이미지가 있다면 거기까지 잘라 썸네일 생성
            //4문단 이상이면 3문단까지만 문단을 돌고, 300글자가 넘어간다면 거기까지 잘라 썸네일 생성
            while paragraphCount < 4 {
                let range = NSMakeRange(index, 0)
                let paragraphRange = (string as NSString).paragraphRange(for: range)
                result.append(self.attributedSubstring(from: paragraphRange))
                
                //1. 썸네일은 첫 3문단 안에 이미지가 있을 경우 생김
                if result.containsAttachments(in: paragraphRange) {
                    return result
                }
                
                //2. 썸네일은 첫 3문단이 300글자를 넘어갈 경우 생김(300글자를 잘라줌)
                if result.length > 300 {
                    return result.attributedSubstring(from: NSMakeRange(0, 300))
                }
                
                index = paragraphRange.location + paragraphRange.length
                paragraphCount += 1
            }
            
            return (result.length != 0 && self.length != result.length)
                ? result
                : nil
            
        } else {
            //4문단 미만
            
            while index < self.length {
                let range = NSMakeRange(index, 0)
                let paragraphRange = (string as NSString).paragraphRange(for: range)
                result.append(self.attributedSubstring(from: paragraphRange))
    
                if result.containsAttachments(in: paragraphRange) {
                    //4문단 미만인데 이미지 존재하면 거기까지 잘라 썸네일 생성(단, 전체 스트링이 이미지 존재하는 문단까지만 있다면 nil, 이걸 확인하기 위해선 다음문단이 없어야 함)
                    return self.length != result.length ? result : nil
                }
                
                //2. 썸네일은 첫 3문단이 300글자를 넘어갈 경우 생김(300글자를 잘라줌)
                if result.length > 300 {
                    return result.attributedSubstring(from: NSMakeRange(0, 300))
                }
                
                index = paragraphRange.location + paragraphRange.length
            }
            return (result.length != 0 && self.length != result.length)
                ? result
                : nil
        }
    }
}

extension CGPoint {
    func move(x: CGFloat, y: CGFloat) -> CGPoint{
        return CGPoint(x: self.x + x, y: self.y + y)
    }
}

extension NSRange {
    func toTextRange(textInput:UITextInput) -> UITextRange? {
        guard let rangeStart = textInput.position(from: textInput.beginningOfDocument, offset: location),
            let rangeEnd = textInput.position(from: rangeStart, offset: length) else {
                return nil
        }
        
        return textInput.textRange(from: rangeStart, to: rangeEnd)
    }
}

infix operator +: AdditionPrecedence

func +(left: NSRange, right: NSRange) -> NSRange {
    return NSMakeRange(left.location + right.location, left.length + right.length)
}

extension UIColor {
    func equal(_ color: UIColor?) -> Bool {
        guard let color = color else { return false }
        
        var red:CGFloat   = 0
        var green:CGFloat = 0
        var blue:CGFloat  = 0
        var alpha:CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        var targetRed:CGFloat   = 0
        var targetGreen:CGFloat = 0
        var targetBlue:CGFloat  = 0
        var targetAlpha:CGFloat = 0
        color.getRed(&targetRed, green: &targetGreen, blue: &targetBlue, alpha: &targetAlpha)
        
        return (Int(red*255.0) == Int(targetRed*255.0) && Int(green*255.0) == Int(targetGreen*255.0) && Int(blue*255.0) == Int(targetBlue*255.0) && alpha == targetAlpha)
    }
}

extension UIImage {
    static func placeholder(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        color.setFill()
        UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: size)).fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
}

extension UITextView {
    func rangeForCurrentParagraph() -> NSRange {
        let paragraphRange = (textStorage.string as NSString).paragraphRange(for: selectedRange)
        return paragraphRange
    }
    
    func rangeForParagraph(with range: NSRange) -> NSRange {
        let paragraphRange = (textStorage.string as NSString).paragraphRange(for: range)
        return paragraphRange
    }
}

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

extension UILabel {
    func getGlyphIndex(from point: CGPoint) -> Int? {
        guard let attrText = self.attributedText else { return nil }
        let textStorage = NSTextStorage(attributedString: attrText)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        layoutManager.addTextContainer(textContainer)
        return layoutManager.glyphIndex(for: point, in: textContainer)
    }
}

extension NSLayoutManager {
    /// Determine the character ranges for an attachment
    private func rangesForAttachment(attachment: NSTextAttachment) -> [NSRange]?
    {
        guard let attributedString = self.textStorage else
        {
            return nil
        }
        
        // find character range for this attachment
        let range = NSRange(location: 0, length: attributedString.length)
        
        var refreshRanges = [NSRange]()
        
        attributedString.enumerateAttribute(.attachment, in: range, options: []) { (value, effectiveRange, nil) in
            
            guard let foundAttachment = value as? NSTextAttachment, foundAttachment == attachment else
            {
                return
            }
            
            // add this range to the refresh ranges
            refreshRanges.append(effectiveRange)
        }
        
        if refreshRanges.count == 0
        {
            return nil
        }
        
        return refreshRanges
    }
    
    /// Trigger a relayout for an attachment
    public func setNeedsLayout(forAttachment attachment: NSTextAttachment)
    {
        
        guard let ranges = rangesForAttachment(attachment: attachment) else
        {
            return
        }
        
        // invalidate the display for the corresponding ranges
        ranges.reversed().forEach { (range) in
            
            self.invalidateLayout(forCharacterRange: range, actualCharacterRange: nil)
            
            // also need to trigger re-display or already visible images might not get updated
            self.invalidateDisplay(forCharacterRange: range)
        }
    }
    
    /// Trigger a re-display for an attachment
    public func setNeedsDisplay(forAttachment attachment: NSTextAttachment)
    {
        guard let ranges = rangesForAttachment(attachment: attachment) else
        {
            return
        }
        
        // invalidate the display for the corresponding ranges
        ranges.reversed().forEach { (range) in
            
            self.invalidateDisplay(forCharacterRange: range)
        }
    }
}
