//
//  ColorPickerButton.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 12..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class ColorPickerButton: UIButton {
    
    enum ColorStyle: Int {
        case red = 0
        case mint
        case gold
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //TODO: 초기 버튼 선택(코어데이터가 갖고 있는 페이퍼의 컬러를 기준으로)
        guard let colorString = CoreData.sharedInstance.paper.color else { return }
        
        if let colorStyle = ColorStyle(rawValue: tag),
            colorString != String(describing: colorStyle) {
            isSelected = false
        } else {
            isSelected = true
        }
    }

}
