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
    
    //페이퍼의 color에 맞춰 세팅
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let colorString = CoreData.sharedInstance.paper.color else { return }
        for button in pickerButtons {
            switch button.tag {
            case 0:
                let image = UIImage(named: colorString + "Color")
                button.setImage(image, for: .normal)
            case 3:
                let image = UIImage(named: colorString + "Underline")
                button.setImage(image, for: .normal)
            case 4:
                let image = UIImage(named: colorString + "Strikethrough")
                button.setImage(image, for: .normal)
            default:
                ()
            }
        }
    }
    
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
}
