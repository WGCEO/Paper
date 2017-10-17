//
//  PianoPickerButton.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 12..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class PianoPickerButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let colorString = CoreData.sharedInstance.paper.color else { return }
        switch tag {
        case 0:
            let image = UIImage(named: colorString + "Color")
            setImage(image, for: .normal)
        case 3:
            let image = UIImage(named: colorString + "Underline")
            setImage(image, for: .normal)
        case 4:
            let image = UIImage(named: colorString + "Strikethrough")
            setImage(image, for: .normal)
        default:
            ()
        }
    }

}
