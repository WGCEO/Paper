//
//  PaperListHeaderView.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 3..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class PaperListHeaderView: UIView {

    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        widthConstraint.constant = bounds.width < 415 ? bounds.width : bounds.width * 0.9
    }

}
