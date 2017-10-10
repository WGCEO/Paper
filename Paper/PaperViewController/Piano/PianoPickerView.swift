//
//  PianoPickerView.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 9..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

protocol PianoPickerViewDelegate: class {
    func pianoPickerView(_ pickerView: PianoPickerView, didSelectPickerAt index: Int)
}

class PianoPickerView: UIView {

    weak var delegate: PianoPickerViewDelegate?
    @IBOutlet weak var headerPickerView: UIView!
    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet var pickerButtons: [UIButton]!
    
    @IBAction func tapPickerButton(_ sender: UIButton) {
        if wasDoubleTappedHeader(button: sender) {
            headerPickerView.isHidden = false
            return
        }
        
        delegate?.pianoPickerView(self, didSelectPickerAt: sender.tag)
        changeAlpha(for: sender)
    }
    
    private func wasDoubleTappedHeader(button: UIButton) -> Bool {
        return button.alpha == Global.opacity && button == headerButton
    }
    
    private func changeAlpha(for selectedButton: UIButton){
        for button in pickerButtons {
            UIView.animate(withDuration: Global.duration, animations: {
                if button == selectedButton {
                    button.alpha = Global.opacity
                } else {
                    button.alpha = Global.transparent
                }
            })
        }
    }
    
    internal func updatePianoPickerView(colorName: String){
        
        for button in pickerButtons {
            switch button.tag {
            case 0:
                let image = UIImage(named: colorName + "Color")
                button.setImage(image, for: .normal)
                
                //4. 첫번째 컬러 세팅하기(첫번째 버튼이 탭된 것처럼 델리게이트에 전달해주기)
                delegate?.pianoPickerView(self, didSelectPickerAt: 0)
            case 3:
                let image = UIImage(named: colorName + "Underline")
                button.setImage(image, for: .normal)
            case 4:
                let image = UIImage(named: colorName + "Strikethrough")
                button.setImage(image, for: .normal)
            default:
                ()
            }
        }
    }
    
}
