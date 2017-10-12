//
//  MirroringButton.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 12..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class MirroringButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isSelected = CoreData.sharedInstance.preference.showMirroring
    }

}
