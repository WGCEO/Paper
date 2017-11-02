//
//  PaperSegue.swift
//  Paper-mac
//
//  Created by changi kim on 2017. 10. 31..
//  Copyright © 2017년 Piano. All rights reserved.
//

import Cocoa

class PaperSegue: NSStoryboardSegue {
    override func perform() {
        let animator = PaperPresentationAnimator()
        let sourceVC  = self.sourceController as! NSViewController
        let destVC = self.destinationController as! NSViewController
        sourceVC.presentViewController(destVC, animator: animator)
    }
    
}
