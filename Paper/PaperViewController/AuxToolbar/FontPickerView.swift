//
//  FontPickerView.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 10..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class FontPickerView: UIView {

    @IBOutlet weak var slider: FontSlider!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func fontChanged(_ sender: UISlider) {
        let value = lroundf(sender.value)
        sender.setValue(Float(value), animated: true)
        let fontStr = FormManager.sharedInstance.fontStrs[value]
        //1. 애니메이션으로 비동기를 준비한다.
        
        //2. 폰트사이즈가 다른 것들의 범위를 다 찾아내고, 기존 폰트와의 크기 차이를 구한다.
        guard let textView = CoreData.sharedInstance.textView,
            let paper = CoreData.sharedInstance.paper else { return }
        
        let range = NSMakeRange(0, textView.attributedText.length)
        var tuplesForUpdateSize: [(range: NSRange, sizeDifference: Int)] = []
        textView.attributedText.enumerateAttribute(.font, in: range, options: []) { (value, range, stop) in
            guard let font = value as? UIFont else { return }
            let sizeDifference = Int(font.pointSize)
                - Int(FormManager.sharedInstance.paperFont.pointSize)
            if sizeDifference != 0 {
                tuplesForUpdateSize.append((range, sizeDifference))
            }
        }

        //3. 노트의 폰트, 텍스트뷰 자체의 폰트 값을 세팅해버린다.
        paper.font = fontStr
        textView.font = FormManager.sharedInstance.transformToFont(name: fontStr)
        
        //4. 크기가 다른 것들에 대해 크기 바꾼다.
        for tuple in tuplesForUpdateSize {
            let font = FormManager.sharedInstance.transformToFont(name: fontStr)
            
            let newSize = font.pointSize + CGFloat(tuple.sizeDifference)
            let newFont: UIFont
            switch tuple.sizeDifference {
            case 3:
                newFont = UIFont.systemFont(ofSize: newSize, weight: .heavy)
            case 6:
                newFont = UIFont.systemFont(ofSize: newSize, weight: .black)
            case 9:
                newFont = UIFont.systemFont(ofSize: newSize, weight: .black)
            default:
                newFont = UIFont.systemFont(ofSize: newSize, weight: .black)
            }
            
            textView.textStorage.addAttributes([.font: newFont], range: tuple.range)
            CoreData.sharedInstance.textView?.userEdited = true
        }
        
        //5. 폰트에 영향 받는 것들 업데이트한다.
        FormManager.sharedInstance.updateAllFormAttributes()
        
        //6. 모든 문단을 돌면서 정규식 검사를 해 문단을 재배치하고 속성값을 입힌다.
        var paraRange = textView.rangeForParagraph(with: NSMakeRange(0, 0))
        
        while !(paraRange.location + paraRange.length > textView.attributedText.length) {
            FormManager.sharedInstance.addAttrToFormIfNeeded(in: paraRange, mutableAttrString: textView.textStorage)
            
            let index = paraRange.location + paraRange.length
            if index < textView.attributedText.length {
                paraRange = textView.rangeForParagraph(with: NSMakeRange(index + 1, 0))
            } else {
                break
            }
        }
        
        //7. 애니메이션으로 완료라는 hud와 함께 끝낸다.
    }
    
    
}
