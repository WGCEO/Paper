//
//  PaperCell.swift
//  Paper-mac
//
//  Created by changi kim on 2017. 10. 27..
//  Copyright © 2017년 Piano. All rights reserved.
//

import Cocoa

class PaperCell: NSTableCellView, Reusable {
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.white.cgColor
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
