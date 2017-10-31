//
//  Reference_iOS.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 24..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class Reference: Stringable {
    typealias AtrributedString = NSAttributedString
    
    static let sharedInstance: Reference = {
        return Reference()
    }()
    weak var textView: PianoTextView?
    var attrText: NSAttributedString? {
        return textView?.attributedText
    }
}
