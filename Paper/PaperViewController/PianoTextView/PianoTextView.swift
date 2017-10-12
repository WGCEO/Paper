//
//  PianoTextView.swift
//  Paper
//
//  Created by changi kim on 2017. 9. 26..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class PianoTextView: UITextView {

    var userEdited: Bool = false
    @IBOutlet weak var mirrorScrollView: MirrorScrollView!
    @IBOutlet weak var mirrorScrollViewBottom: NSLayoutConstraint!
    
    override var typingAttributes: [String : Any] {
        get {
            var attributes: [String : Any] = [:]
            for (key, value) in defaultAttributes {
                attributes[key.rawValue] = value
            }
            return attributes
        } set {
        }
    }
    
    //MARK: Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //MARK: Piano
    public var control = PianoControl()
    internal var coverView: UIView?
 
    //MARK: Attribute
    lazy var defaultAttributes: [NSAttributedStringKey : Any] = {
        return calculateDefaultAttributes()
    }()
    
    lazy var defaultAttributesWithoutParaStyle : [NSAttributedStringKey : Any] = {
        return calculateDefaultAttributesWithoutParagraph()
    }()
    
    //calculate의 파라미터로 실제 구입한 패키지 정보 담기
    lazy var circleKern: CGFloat = { calculateCircleKern() }()
    lazy var starKern: CGFloat = { calculateStarKern() }()
    lazy var refKern: CGFloat = { calculateRefKern() }()
 
}

//MARK: setup
extension PianoTextView {
    internal func setup(){
        guard let paper = CoreData.sharedInstance.paper else { return }
        textColor = Global.textColor
        font = Global.transformToFont(name: paper.font!)
        attributedText = CoreData.sharedInstance.paperFullContent()
        tintColor = Global.transFormToColor(name: paper.color!)
        updateAllCalculateAttr()
        
        control.effectable = self
        delegate = self
        textContainer.lineFragmentPadding = 0
        textContainerInset.top = 16
        textContainerInset.bottom = 80
        
        //코어데이터 세팅
        CoreData.sharedInstance.textView = self
        
        //typingAttribute의 문단 세팅
        for (key, value) in defaultAttributes {
            typingAttributes[key.rawValue] = value
        }
        
        layoutManager.usesFontLeading = false
        textStorage.delegate = self
        
        //TODO: 아이패드의 하단 바를 숨기기위한 방법. 이거 나중에 체크하기
        inputAssistantItem.leadingBarButtonGroups = []
        inputAssistantItem.trailingBarButtonGroups = []
        
    }
    
}


extension PianoTextView: NSTextStorageDelegate {
    //    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
    //        if editedMask.rawValue == 3 && editedRange.length == 1 && self.isEditable  {
    //            textStorage.addAttributes(defaultAttributesWithoutParaStyle, range: editedRange)
    //        }
    //        print("\(editedMask) \(editedRange), \(delta)")
    //    }
    
    
    func textStorage(_ textStorage: NSTextStorage, willProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.rawValue == 3 &&
            self.isEditable &&
            (editedRange.length == 1 || !detectCompletedForm(in: editedRange))  {
            
            textStorage.addAttributes(defaultAttributesWithoutParaStyle, range: editedRange)
        }
    }
}
