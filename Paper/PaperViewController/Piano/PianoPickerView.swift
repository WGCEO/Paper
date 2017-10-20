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
    @IBOutlet var headerPickerButtons: [UIButton]!
    
    @IBAction func tapPickerButton(_ sender: UIButton) {
        if wasDoubleTappedHeader(button: sender) {
            headerPickerView.isHidden = false
            
            for headerPickerButton in headerPickerButtons {
                headerPickerButton.alpha = sender.tag != headerPickerButton.tag ? 0.3 : 1
            }
            
            return
        }
        
        delegate?.pianoPickerView(self, didSelectPickerAt: sender.tag)
        changeAlpha(for: sender)
    }
    
    @IBAction func tapHeaderPickerButton(_ sender: UIButton) {
        headerButton.tag = sender.tag
        let image = sender.image(for: .normal)
        headerButton.setImage(image, for: .normal)
        headerPickerView.isHidden = true
        delegate?.pianoPickerView(self, didSelectPickerAt: sender.tag)
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
}
