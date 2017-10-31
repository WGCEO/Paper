//
//  TagCollectionView.swift
//  Paper-mac
//
//  Created by changi kim on 2017. 10. 25..
//  Copyright © 2017년 Piano. All rights reserved.
//

import Cocoa
import CoreData

protocol Filterable: class {
    func filter(before: [Tag], after: [Tag])
}

class TagCollectionView: NSCollectionView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
