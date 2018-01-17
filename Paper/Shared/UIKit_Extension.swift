//
//  UIKit_Extension.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 24..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

extension NSRange {
    func toTextRange(textInput:UITextInput) -> UITextRange? {
        guard let rangeStart = textInput.position(from: textInput.beginningOfDocument, offset: location),
            let rangeEnd = textInput.position(from: rangeStart, offset: length) else {
                return nil
        }
        
        return textInput.textRange(from: rangeStart, to: rangeEnd)
    }
}

extension NSAttributedString {
    func resetParagraphStyle() -> NSAttributedString {
        let mutableAttrString = NSMutableAttributedString(attributedString: self)
        let paragraphStyle = NSParagraphStyle()
        if mutableAttrString.length != 0 {
            mutableAttrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
        }
        return mutableAttrString
    }
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
            var size = CGSize(width: 480, height: 360)//resultImage.size.applying(CGAffineTransform(scaleX: ratio, y: ratio))
            size.width *= 0.05
            size.height *= 0.05
            UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
            resultImage.draw(in: CGRect(origin: CGPoint.zero, size: size))
            var scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
//            scaledImage = UIImage(data: UIImageJPEGRepresentation(scaledImage!, 0.0)!)
            
//            print("\(resultImage.getCount()) \(scaledImage?.getCount()) \(UIImagePNGRepresentation(scaledImage!)?.count) \(UIImageJPEGRepresentation(scaledImage!, 0.0))")
            if let resultImage = scaledImage {
                return resultImage
            }
        }
        return resultImage
    }
}

extension UIImage {
    func getCount() -> Int {
        return (self.cgImage?.height ?? 0) * (self.cgImage?.bytesPerRow ?? 0)
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
