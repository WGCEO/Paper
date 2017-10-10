//
//  ColorPickerView.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 10..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class ColorPickerView: UIView {
    @IBOutlet var buttons: [UIButton]!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //TODO: 초기 버튼 선택(코어데이터가 갖고 있는 페이퍼의 컬러를 기준으로)
        guard let colorString = CoreData.sharedInstance.paper.color else { return }
        colorLoop: for (index, str) in Global.colorStrs.enumerated() {
            if  colorString == str {
                for button in buttons {
                    if button.tag == index {
                        button.isSelected = true
                        break colorLoop
                    }
                }
            }
        }
    }
    @IBAction func tapColorButton(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = button != sender ? false : true
        }
        
        let newColorStr = Global.colorStrs[sender.tag]
        let newColor = Global.transFormToColor(name: newColorStr)
        
        guard let textView = CoreData.sharedInstance.textView,
            let attrText = textView.attributedText, let paper = CoreData.sharedInstance.paper else { return }
        
        textView.tintColor = newColor
        //1 노트의 attributedText의 attribute를 루프로 돌면서 기존 note.color와 동일 했던 텍스트 색상을 newcolor로 바꿔주기
        attrText.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, attrText.length), options: []) { (value, range, stop) in
            guard let textColor = value as? UIColor,
                !textColor.equal(Global.textColor) else { return }
            textView.textStorage.addAttributes([.foregroundColor : newColor], range: range)
            textView.userEdited = true
        }
        
        //2 노트 컬러 세팅하기
        paper.color = newColorStr
    }
    

}
