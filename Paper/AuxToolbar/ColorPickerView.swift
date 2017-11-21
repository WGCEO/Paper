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
    
    @IBAction func tapColorButton(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = button != sender ? false : true
        }
        
        let newColorStr = Global.colorStrs[sender.tag]
        let defaultColor = Global.textColor
        let newColor = Global.transformToColor(name: newColorStr)
        guard let textView = CoreData.sharedInstance.textView,
            let attrText = textView.attributedText, let paper = CoreData.sharedInstance.paper else { return }
        
        textView.tintColor = newColor
        //1 노트의 attributedText의 attribute를 루프로 돌면서 기존 note.color와 동일 했던 텍스트 색상을 newcolor로 바꿔주기
        attrText.enumerateAttribute(.foregroundColor, in: NSMakeRange(0, attrText.length), options: []) { (value, range, stop) in
            guard let textColor = value as? UIColor,
                !textColor.equal(defaultColor) else { return }
            textView.textStorage.addAttributes([.foregroundColor : newColor], range: range)
            textView.userEdited = true
        }
        
        attrText.enumerateAttribute(.underlineColor, in: NSMakeRange(0, attrText.length), options: []) { (value, range, stop) in
            guard let textColor = value as? UIColor,
            !textColor.equal(defaultColor) else { return }
            textView.textStorage.addAttributes([.underlineColor : newColor], range: range)
            textView.userEdited = true
        }
        
        attrText.enumerateAttribute(.strikethroughColor, in: NSMakeRange(0, attrText.length), options: []) { (value, range, stop) in
            guard let textColor = value as? UIColor,
                !textColor.equal(defaultColor) else { return }
            textView.textStorage.addAttributes([.strikethroughColor : newColor], range: range)
            textView.userEdited = true
        }
        
        //2 노트 컬러 세팅하기
        paper.color = newColorStr
    }
    

}
