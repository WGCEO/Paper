//
//  ToolbarButton.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 19..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class ToolbarButton: UIButton {

    override var isSelected: Bool {
        willSet {
            //선택을 당하는 버튼만 애니메이션 진행
            if !isSelected && newValue {
                self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                UIView.transition(with: self, duration: 0.3, options: [], animations: {
                    self.transform = CGAffineTransform.identity
                }, completion: nil)
            }
        }
    }

}
