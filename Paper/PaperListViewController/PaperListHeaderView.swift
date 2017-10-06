//
//  PaperListHeaderView.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 3..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class PaperListHeaderView: UIView {

    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //여기서 width 컨스트레인트를 결정
        let margin = Global.textMargin(by: bounds.width)
        leftConstraint.constant = margin
        rightConstraint.constant = margin
    }

}
