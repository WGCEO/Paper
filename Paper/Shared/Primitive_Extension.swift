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
    
    func thumbnail() -> NSAttributedString? {
        guard length != 0 else { return nil }
        
        var index = 0
        let result = NSMutableAttributedString()
        for _ in 0...2 {
        
            let range = NSMakeRange(index, 0)
            let paraRange = (string as NSString).paragraphRange(for: range)
            let attrString = self.attributedSubstring(from: paraRange)
            
            //이미지가 존재할 때, 첫번째 문단이라면 이미지만 리턴, 첫번째 문단이 아니라면 기존에 저장해둔 result 리턴
            guard !attrString.containsAttachments(in: NSMakeRange(0, attrString.length)) else {
                return result.length != 0 ? result : attrString
            }
            
            result.append(attrString)
            
            //문단 길이가 300보다 크다면 300글자까지 자르고 리턴
            guard result.length <= 300 else {
                return result.attributedSubstring(from: NSMakeRange(0, 300))
            }
            
            index = paraRange.location + paraRange.length
            
            //문단이 3문단보다 적을 경우 nil 리턴
            guard index < length else { return nil }
        }
        
        return result
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
    
    func transform3by4AndFitScreen() -> UIImage? {
        var croppedImage: UIImage? = self
        
        //1. 비율 줄이기 ifNeeded
        //가로 * 3  < 세로 * 4 이면 (4:3 비율보다 세로 이미지 비율이 더 크다면)
        let width = self.size.width
        let height = self.size.height
        if width * 3 < height * 4 {
            let x: CGFloat = 0
            let y: CGFloat = (4 * height - 3 * width) / 8
            let cropRect = CGRect(x: x, y: y, width: width, height: width * 3 / 4)
            if let imageRef = self.cgImage?.cropping(to: cropRect) {
                croppedImage = UIImage(cgImage: imageRef, scale: 0, orientation: self.imageOrientation)
            }
        }
        
        guard let resultImage = croppedImage else { return nil }
        
        //2. 크기 줄이기 ifNeeded
        let ratio = UIScreen.main.bounds.width / resultImage.size.width
        if ratio < 1 {
            let size = resultImage.size.applying(CGAffineTransform(scaleX: ratio, y: ratio))
            UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
            resultImage.draw(in: CGRect(origin: CGPoint.zero, size: size))
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let resultImage = scaledImage {
                return resultImage
            }
        }
        return resultImage
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
