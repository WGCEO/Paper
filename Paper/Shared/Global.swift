//
//  Global.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 3..
//  Copyright © 2017년 Piano. All rights reserved.
//

import Foundation
import CoreGraphics

protocol UIGlobalable {
    associatedtype Font
    associatedtype Color
    associatedtype ParagraphStyle
    
    static var currentDeviceIphone: Bool { get }
    static var paperColors: [Color] { get }
    
    static func transformToFont(name: String) -> Font
    static func transformToColor(name: String) -> Color
    
    static var textColor: Color { get }
    static var defaultParagraphStyle: ParagraphStyle { get }
}

struct Global {
    static let pdfFontSize: CGFloat = 12
    static let duration: Double = 0.2
    static let opacity: CGFloat = 1
    static let transparent: CGFloat = 0.3
    static let lineSpacing: CGFloat = 10
    //TODO: 폰트를 제작 후에 regex를 변환전과 변환 후로 나눠서
    static let numRegex = "^\\s*(\\d+)(?=\\. )"
    //    static let listRegex = "^\\s*([-•])(?= )"
    //    static let asteriskRegex = "^\\s*([\\*\\★])(?= )"
    //    static let atRegex = "^\\s*([@※])(?= )"
    static let oneRegex = "^\\s*([1•])(?= )"
    static let twoRegex = "^\\s*([2★])(?= )"
    static let threeRegex = "^\\s*([3※])(?= )"
    
    static let formOne = "•"
    static let formTwo = "★"
    static let formThree = "※"
    
    static let colorStrs: [String] = ["red", "mint", "gold"]
    static let fontStrs: [String] = ["xSmall", "small", "medium", "large", "xLarge"]
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    static let defaultFontSize: CGFloat = {
        return currentDeviceIphone ? 17 : 23
    }()
    
    static var headIndent: CGFloat {
        return currentDeviceIphone ? 30 : 40
    }
    
    static var tailIndent: CGFloat {
        return currentDeviceIphone ? -20 : -30
    }
}
protocol Stringable {
    associatedtype AtrributedString
    var attrText: AtrributedString? { get }
}
