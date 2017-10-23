//
//  Global.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 3..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

struct Global {
    static let backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
    
    static let paletteViewHeight: CGFloat = 70
    static let accessoryViewHeight: CGFloat = 44
    static let duration: Double = 0.2
    static let opacity: CGFloat = 1
    static let transparent: CGFloat = 0.3
    static let mirrorFont: CGFloat = 31
    static let iphone = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()

    
    static func userFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
