//
//  TagPickerCell.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 10..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class TagPickerCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var label: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = UIColor.darkGray
                label.textColor = UIColor.white
            } else {
                backgroundColor = UIColor.white
                label.textColor = UIColor.darkGray
            }
            
        }
    }
    
}
