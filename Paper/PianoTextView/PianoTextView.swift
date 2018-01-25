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
    var isTyping = false
    
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
        
        let container = FastTextContainer()
        container.widthTracksTextView = true
        
        let textStorage = NSTextStorage(string: "")
        
        let layoutManger = FastLayoutManager()
        
        
        textStorage.addLayoutManager(layoutManger)
        layoutManger.addTextContainer(container)
        
        
        super.init(frame: frame, textContainer: container)
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        container.textView = self
        
    }
    
    //MARK: Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        let newTextView = PianoTextView(frame: self.frame)
        var constraints: Array<NSLayoutConstraint> = []
        self.constraints.forEach {
            let firstItem: AnyObject!, secondItem: AnyObject!
            
            if let unwrappedFirst = $0.firstItem as? FastLayoutTextView, unwrappedFirst == self {
                firstItem = self
            } else {
                firstItem = $0.firstItem
            }
            
            if let unwrappedSecond = $0.secondItem as? FastLayoutTextView, unwrappedSecond == self {
                secondItem = self
            } else {
                secondItem = $0.secondItem
            }
            
            constraints.append(
                NSLayoutConstraint(item: firstItem,
                                   attribute: $0.firstAttribute,
                                   relatedBy: $0.relation,
                                   toItem: secondItem,
                                   attribute: $0.secondAttribute,
                                   multiplier: $0.multiplier,
                                   constant: $0.constant))
        }
        
        
        /*Note 여기서 스토리보드에서 세팅한 값이 전부 투영되어야한다. 현재는 constraints와 text만*/
        
        newTextView.addConstraints(constraints)
        newTextView.autoresizingMask = self.autoresizingMask
        newTextView.translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints
        newTextView.attributedText = self.attributedText
        newTextView.setup()
        return newTextView
    }
    
    //MARK: Piano
    public var control = PianoControl()
    internal var coverView: UIView?
    
    
//    public var visibleRange: NSRange? {
//        if let start = closestPosition(to: contentOffset) {
//            
//            if let end = characterRange(at: CGPoint(x: contentOffset.x + bounds.maxX, y: contentOffset.y + bounds.maxY))?.end {
//                return NSMakeRange(offset(from: beginningOfDocument, to: start), offset(from: start, to: end))
//            }
//        }
//        return nil
//    }
    
    
}

//MARK: setup
extension PianoTextView {
    internal func setup(){
        
//        let layoutManager = PianoLayoutManger()
//        layoutManager.addTextContainer(self.textContainer)
//        self.textStorage.addLayoutManager(layoutManager)
        
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
//        layoutManager.delegate = self
        //TODO: 아이패드의 하단 바를 숨기기위한 방법. 이거 나중에 체크하기
        inputAssistantItem.leadingBarButtonGroups = []
        inputAssistantItem.trailingBarButtonGroups = []
        allowsEditingTextAttributes = true
        
        /*attributedText.enumerateAttribute(.attachment, in: NSMakeRange(0, attributedText.length), options: []) { [weak self](value, range, stop) in
            self?.layoutManager.invalidateDisplay(forCharacterRange: range)
        }*/
        
    }
}

//extension PianoTextView: NSLayoutManagerDelegate {
//    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
//
//    }
//}

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
