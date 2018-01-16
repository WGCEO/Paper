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
            for (key, value) in FormManager.sharedInstance.defaultAttributes {
                attributes[key.rawValue] = value
            }
            return attributes
        } set {
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
 

    
    
}

//MARK: setup
extension PianoTextView {
    internal func setup(){
        
        let formManager = FormManager.sharedInstance
        formManager.delegate = self
        textColor = formManager.textColor
        font = formManager.paperFont
        attributedText = CoreData.sharedInstance.paperFullContent()
        tintColor = formManager.paperColor
        formManager.updateAllFormAttributes()
        
        control.effectable = self
        textContainer.lineFragmentPadding = 0
        textContainerInset.top = 20
        textContainerInset.bottom = 120
        //코어데이터 세팅
        Reference.sharedInstance.textView = self
        
        //typingAttribute의 문단 세팅
        for (key, value) in formManager.defaultAttributes {
            typingAttributes[key.rawValue] = value
        }
        
        layoutManager.usesFontLeading = false
        textStorage.delegate = self
        
        //TODO: 아이패드의 하단 바를 숨기기위한 방법. 이거 나중에 체크하기
        inputAssistantItem.leadingBarButtonGroups = []
        inputAssistantItem.trailingBarButtonGroups = []
        allowsEditingTextAttributes = true
        
        attributedText.enumerateAttribute(.attachment, in: NSMakeRange(0, attributedText.length), options: []) { [weak self](value, range, stop) in
            self?.layoutManager.invalidateDisplay(forCharacterRange: range)
        }
        
    }
}

extension PianoTextView: Cursorable {
    var cursorRange: NSRange {
        get {
            return selectedRange
        } set {
            selectedRange = newValue
        }
    }
    
    func insertNewLine() {
        insertText("\n")
    }
}


extension PianoTextView: NSTextStorageDelegate {
    
    func textStorage(_ textStorage: NSTextStorage, willProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        let formManager = FormManager.sharedInstance
        if editedMask.rawValue == 3 &&
            self.isEditable &&
            (editedRange.length == 1 || formManager.paperForm(text: textStorage.string, range: editedRange) == nil)  {
            textStorage.addAttributes(formManager.defaultAttributesWithoutParaStyle, range: editedRange)
        }
    }
}
