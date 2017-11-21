//
//  ConvertPickerView.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 10..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class ConvertPickerView: UIView {

    @IBAction func tapConvertPDFButton(_ sender: Any) {
        
        
        ActivityIndicator.startAnimating()
        
        DispatchQueue.main.async {
            guard let textView = CoreData.sharedInstance.textView,
                let attrString = textView.attributedText else { return }
            
            //해당 페이퍼의 크기를 가져와서 pdf 기본 폰트 (11?)와의 차이값을 모든 폰트 사이즈에서 빼주기
            let mutableAttrText = NSMutableAttributedString(attributedString: attrString)
//            let diff = FormManager.sharedInstance.paperFont.pointSize - Global.pdfFontSize
//            mutableAttrText.enumerateAttribute(.font, in: NSMakeRange(0, mutableAttrText.length), options: [], using: { (value, range, stop) in
//                guard let font = value as? UIFont else { return }
//                let resizeFont = font.withSize(font.pointSize - diff)
//
//                mutableAttrText.addAttribute(.font, value: resizeFont, range: range)
//            })
            
            
            
            //text 와 image를 분리시키기
            var datas: [Any] = []
            var index = 0
            mutableAttrText.enumerateAttribute(.attachment, in: NSMakeRange(0, mutableAttrText.length), options: []) { (value, range, stop) in
                guard let attachment = value as? NSTextAttachment,
                    let image = attachment.image else { return }
                
                //이미지 다시 그리기
                // Setup a new context with the correct size
                let width = image.size.width + 60
                let height = image.size.height + 20
                UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0.0)
                let context = UIGraphicsGetCurrentContext()
                UIGraphicsPushContext(context!)
                // Now we can draw anything we want into this new context.
                let origin = CGPoint(x: 30, y: 10)
                image.draw(at: origin)
                
                //clean up and get the new image.
                UIGraphicsPopContext()
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                
                let prevRange = NSMakeRange(index, range.location - index)
                datas.append(mutableAttrText.attributedSubstring(from: prevRange))
                //TODO: iPAD일 경우 이미지 사이즈 줄여줘야할 경우 생길거같다!
                datas.append(newImage!)
                index = range.location + range.length
            }
            let finalRange = NSMakeRange(index, mutableAttrText.length - index)
            datas.append(mutableAttrText.attributedSubstring(from: finalRange))
            
            //차례차례 pdf에 담기
            let pdf = PDFGenerator(format: .a4, info: PDFInfo())
            pdf.setIndentation(indent: -30)
            
            for data in datas {
                if let attrString = data as? NSAttributedString {
                    pdf.addAttributedText(text: attrString)
                } else if let image = data as? UIImage {
                    //마진을 줘서 다시 그리는 방법이 있음
                    pdf.addImage(image: image)
                    
                }
            }
            ActivityIndicator.stopAnimating()
            
            AppNavigator.currentViewController?.performSegue(withIdentifier: "PDFViewController", sender: pdf)
            
        }

        
    }
    
}
