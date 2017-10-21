//
//  PianoTextView.swift
//  Paper
//
//  Created by changi kim on 2017. 9. 26..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit
import MobileCoreServices

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
            typingAttributes = newValue
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
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
        textContainer.lineFragmentPadding = 0
        textContainerInset.top = 20
        textContainerInset.bottom = 120
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
        allowsEditingTextAttributes = true
    }
}


extension PianoTextView: NSTextStorageDelegate {
    
    func textStorage(_ textStorage: NSTextStorage, willProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.rawValue == 3 &&
            self.isEditable &&
            (editedRange.length == 1 || convertedPaperForm(text: textStorage.string, range: editedRange) == nil)  {
            textStorage.addAttributes(defaultAttributesWithoutParaStyle, range: editedRange)
        }
    }
}
