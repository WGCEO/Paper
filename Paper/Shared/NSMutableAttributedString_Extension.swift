//
//  NSAttributedString_Extension.swift
//  Paper
//
//  Created by changi kim on 2017. 9. 26..
//  Copyright © 2017년 Piano. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    
    //TODO: 이거 잘 돌아가는 지 체크하기
    func removeImages() {
        self.enumerateAttribute(.attachment, in: NSMakeRange(0, self.length), options: []) { (value, range, stop) in
            guard let _ = value as? ImageAttachment else { return }
            self.replaceCharacters(in: NSMakeRange(0, self.length), with: "(🖼)")
        }
        
    }
}
