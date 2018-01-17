//
//  Share_Extension.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 24..
//  Copyright © 2017년 Piano. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGPoint {
    func move(x: CGFloat, y: CGFloat) -> CGPoint{
        return CGPoint(x: self.x + x, y: self.y + y)
    }
}



infix operator +: AdditionPrecedence

func +(left: NSRange, right: NSRange) -> NSRange {
    return NSMakeRange(left.location + right.location, left.length + right.length)
}

extension NSAttributedString {
    //썸네일이 존재하면(nil이 아니면), 무조건 더보기가 있어야 함.
    //1. 썸네일은 첫 3문단 안에 이미지가 있을 경우 생김
    //2. 썸네일은 첫 3문단이 300글자를 넘어갈 경우 생김(300글자를 잘라줌)
    //3. 썸네일은 전체 스트링이 3문단을 넘어갈 경우 생김
    
    //1. 전체 스트링이 4문단 이상이면 3문단까지 자른 썸네일 생성
    //1-1. 3문단까지 자른 썸네일을 문단을 돌면서 이미지가 있다면 거기까지 잘라 썸네일 생성
    //1-1. 3문단까지 자른 썸네일을 문단을 돌면서 300글자가 넘어가면 거기까지 잘라 썸네일 생성
    
    //2. 전체 스트링이 4문단 미만인데 이미지 존재하면 거기까지 잘라 썸네일 생성(단, 전체 스트링이 이미지 존재하는 문단까지만 있다면 nil, 이걸 확인하기 위해선 다음문단이 없어야 함)
    //3. 전체 스트링이 4문단 미만인데 300글자를 넘어가면 300글자까지 잘라 썸네일 생성
    //4. 전체 스트링이 4문단 미만인데 300글자를 넘지 않고, 전체 스트링의 길이와 같다면 nil
    
    func thumbnail() -> NSAttributedString? {
        guard length != 0 else { return nil }
        
        var index = 0
        let result = NSMutableAttributedString()
        for _ in 0...2 {
            
            let range = NSMakeRange(index, 0)
            let paraRange = (string as NSString).paragraphRange(for: range)
            let attrString = self.attributedSubstring(from: paraRange)
            
            //이미지가 존재할 때, 첫번째 문단이라면 이미지만 리턴, 첫번째 문단이 아니라면 기존에 저장해둔 result 리턴
            guard !attrString.containsAttachments(in: NSMakeRange(0, attrString.length)) else {
                return result.length != 0 ? result : attrString
            }
            
            result.append(attrString)
            
            //문단 길이가 300보다 크다면 300글자까지 자르고 리턴
            guard result.length <= 300 else {
                return result.attributedSubstring(from: NSMakeRange(0, 300))
            }
            
            index = paraRange.location + paraRange.length
            
            //문단이 3문단보다 적을 경우 nil 리턴
            guard index < length else { return nil }
        }
        
        return result
    }
}

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
