//
//  PaperForm.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 21..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

public protocol EnumCollection: Hashable {
    static func cases() -> AnySequence<Self>
    static var allValues: [Self] { get }
}

enum PaperFormType: EnumCollection {

    case number
    case one
    case two
    case three
    
//    TODO: 나중에 서식 아이디어 반영할 때 Global에 있는거 이쪽으로 다 옮기기
    var regexString: String {
        get {
            switch self {
            case .number:
                return Global.numRegex
            case .one:
                return Global.oneRegex
            case .two:
                return Global.twoRegex
            case .three:
                return Global.threeRegex
            }
        }
    }
    
    var reserved: String {
        get {
            switch self {
            case .number:
                return "TODO: 어케 처리할 것인가"
            case .one:
                return "1"
            case .two:
                return "2"
            case .three:
                return "3"
            }
        }
    }
    
    var converted: String {
        get {
            switch self {
            case .number:
                return "TODO: 어케 처리할 것인가"
            case .one:
                return "•"
            case .two:
                return "★"
            case .three:
                return "※"
            }
        }
    }
    
    var kern: CGFloat {
        get {
            let font = CoreData.sharedInstance.paperFont
            let numberingFont = UIFont(name: "Avenir Next", size: font.pointSize)!
            let num = NSAttributedString(string: "4", attributes: [
                .font : numberingFont]).size()
            let dot = NSAttributedString(string: ".", attributes: [
                .font : font]).size()
            let form = NSAttributedString(string: self.converted, attributes: [
                .font : font]).size()
            return form.width > num.width + dot.width ? 0 : (num.width + dot.width - form.width)/2
        }
    }
    
    static func cases() -> AnySequence<PaperFormType> {
        return AnySequence { () -> AnyIterator<PaperFormType> in
            var raw = 0
            return AnyIterator {
                let current: PaperFormType = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }

    public static var allValues: [PaperFormType] {
        return Array(self.cases())
    }
}

struct PaperForm {
    let type: PaperFormType
    var range: NSRange
}

