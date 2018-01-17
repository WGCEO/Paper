//
//  TagCell.swift
//  Paper
//
//  Created by changi kim on 2017. 9. 27..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var label: UILabel!
    
    var userSelected: Bool = false {
        didSet {
            updateView(userSelected: userSelected)
        }
    }
    
    private func updateView(userSelected: Bool) {
        backgroundColor = userSelected ? .darkGray : .white
        label.textColor = userSelected ? .white : .darkGray
    }
}
