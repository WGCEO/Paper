//
//  PianoTextView_Form.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 9..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

//MARK: Paste
extension PianoTextView {
    override func paste(_ sender: Any?) {
        
        if let attrString = transformAttrStringFromPasteboard() {
            textStorage.replaceCharacters(in: selectedRange, with: attrString)
        }
    }
    
    private func transformAttrStringFromPasteboard() -> NSAttributedString? {
        var attrString: NSAttributedString? = nil

        //하나를 복사해도 여러가지의 타입이 생성되는데 그중에 우선순위 pasteboard가 있어서 그에 맞춰 코딩함
        if let data = UIPasteboard.general.data(forPasteboardType: "com.apple.flat-rtfd") {
            do {
                attrString = try NSAttributedString(data: data, options: [:], documentAttributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        } else if let data = UIPasteboard.general.data(forPasteboardType: "com.apple/webarchive") {
            do {
                attrString = try NSAttributedString(data: data, options: [:], documentAttributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        } else if let data = UIPasteboard.general.data(forPasteboardType: "com.evernote.app.htmlData") {
            do {
                attrString = try NSAttributedString(data: data, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        } else if let data = UIPasteboard.general.data(forPasteboardType: "Apple Web Archive pasteboard type") {
            do {
                attrString = try NSAttributedString(data: data, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if let attrText = attrString {
            let mutableAttrText = NSMutableAttributedString(attributedString: attrText)
            
            //이미지는 ImageAttachment로 바꿔서 저장
            mutableAttrText.enumerateAttribute(.attachment, in: NSMakeRange(0, mutableAttrText.length), options: [], using: { (value, range, stop) in
                guard let attachment = value as? NSTextAttachment else { return }
                
                if let image = attachment.image {
                    let transformImage = image.transform3by4AndFitScreen()
                    let imageAttachment = ImageAttachment()
                    imageAttachment.image = transformImage
                    let imageAttrString = NSAttributedString(attachment: imageAttachment)
                    mutableAttrText.replaceCharacters(in: range, with: imageAttrString)
                } else if let fileWrapper = attachment.fileWrapper,
                    let data = fileWrapper.regularFileContents {
                    let image = UIImage(data: data)
                    let transformImage = image?.transform3by4AndFitScreen()
                    let imageAttachment = ImageAttachment()
                    imageAttachment.image = transformImage
                    let imageAttrString = NSAttributedString(attachment: imageAttachment)
                    mutableAttrText.replaceCharacters(in: range, with: imageAttrString)
                } else {
                    print("예외상황발생!!!! 처리해야함")
                }
                //
            })
            
            //폰트, 글자 색상 변경
            let formManager = FormManager.sharedInstance
            mutableAttrText.addAttributes([.foregroundColor : formManager.textColor,
                                           .font: formManager.paperFont,
                                           .paragraphStyle: formManager.defaultParagraphStyle],
                                          range: NSMakeRange(0, mutableAttrText.length))
            attrString = mutableAttrText
        }
        return attrString
    }
}

