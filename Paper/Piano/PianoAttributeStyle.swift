//
//  PianoAttributeStyle.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 9..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

enum PianoAttributeStyle {
    case color(UIColor)
    case bold(CGFloat)
    case header1(CGFloat)
    case underline(UIColor)
    case strikeThrough(UIColor)
    case header2(CGFloat)
    case header3(CGFloat)
    
    func attr() -> [NSAttributedStringKey : Any] {
        switch self {
        case .color(let x):
            
            return [.foregroundColor : x]
        case .bold(let x):
            return [.font : UIFont.boldSystemFont(ofSize: x)
            ]
        case .header1(let x):
            return [.font : UIFont.systemFont(ofSize: x + 3, weight: UIFont.Weight.bold)]
        case .underline(let x):
            return [.underlineStyle : 1, .underlineColor : x]
        case .strikeThrough(let x):
            return [.strikethroughStyle : 1, .strikethroughColor : x]
        case .header2(let x):
            return [.font : UIFont.systemFont(ofSize: x + 6, weight: UIFont.Weight.bold)]
        case .header3(let x):
            return [.font : UIFont.systemFont(ofSize: x + 9, weight: UIFont.Weight.bold)]
        }
    }
    
    func removeAttr() -> [NSAttributedStringKey : Any] {
        switch self {
        case .color:
            return [.foregroundColor : FormManager.sharedInstance.textColor]
        case .bold(let x):
            return [.font : UIFont.systemFont(ofSize: x)]
        case .header1(let x):
            return [.font : UIFont.systemFont(ofSize: x)]
        case .underline:
            return [NSAttributedStringKey.underlineStyle : 0]
        case .strikeThrough:
            return [NSAttributedStringKey.strikethroughStyle : 0]
        case .header2(let x):
            return [.font : UIFont.systemFont(ofSize: x)]
        case .header3(let x):
            return [.font : UIFont.systemFont(ofSize: x)]
        }
    }
}
