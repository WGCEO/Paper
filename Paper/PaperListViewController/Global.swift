//
//  Global.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 3..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

struct Global {
    static func textMargin(by screenWidth: CGFloat) -> CGFloat {
        if screenWidth < 415 {
            return 0
        } else if screenWidth < 600 {
            return screenWidth / 20
        } else if screenWidth < 750 {
            return screenWidth / 15
        } else if screenWidth < 850 {
            return screenWidth / 10
        } else {
            return screenWidth / 6.7
        }
    }
}
