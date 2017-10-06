//
//  PianoTextView.swift
//  Paper
//
//  Created by changi kim on 2017. 9. 26..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit
import CoreData

class PianoTextView: UITextView {
    
    weak var editor: PianoEditor?
    var userEdited: Bool = false
    var paper: Paper!
    
     /*
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
    */
    //MARK: Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        registerKeyboardNotification()
    }
    
    deinit {
        unRegisterKeyboardNotification()
    }
    /*
    //MARK: CoreData
    //휴지통을 눌러서 계속 지워나갈 때 마다, 지운 메모를 제외한 최신 메모를 가져옴. 만약 메모가 없을 경우, 직접 노트 생성
    internal var note: Note! = CoreData.sharedInstance.fetchNote() {
        didSet {
            if userEdited {
                CoreData.sharedInstance.asyncSave(attrString: attributedText, to: oldValue)
                userEdited = false
            }
     
            updateTextView()
            //폰트에 의해 바뀌어야 하는 값들 업데이트
            updateAllCalculateAttr()
            editor?.updatePianoViews()
 
            changeCreateNoteButtonState()
        }
    }
    */
    //MARK: ReactCursor
    internal var kbHeight: CGFloat?
    
    //MARK: Piano
    /*
    public var control = PianoControl()
 
     */
    internal var coverView: UIView?
    
    /*
    //MARK: InputView
    internal lazy var imagePickerView: ImagePickerView = {
        let nib = UINib(nibName: "ImagePickerView", bundle: nil)
        let imagePickerView: ImagePickerView = nib.instantiate(withOwner: self, options: nil).first as! ImagePickerView
        imagePickerView.delegate = self
        imagePickerView.frame.size.height = self.kbHeight ?? 0
        imagePickerView.setup()
        return imagePickerView
    }()
    
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
 
 
     */
}

//MARK: setup
extension PianoTextView {
    
    private func setup(){
        //임시코드
        let mutableParagraph = NSMutableParagraphStyle()
        mutableParagraph.lineSpacing = 8
        mutableParagraph.firstLineHeadIndent = 30
        mutableParagraph.headIndent = 30
        mutableParagraph.tailIndent = -30
        
        let mutableStr = NSMutableAttributedString(attributedString: attributedText!)
        mutableStr.addAttributes([.paragraphStyle: mutableParagraph], range: NSMakeRange(0, mutableStr.length))
        attributedText = mutableStr
        //임시코드 여기까지
        
        /*
        tintColor = Global.transFormToColor(name: note.color)
         */
        delegate = self
        textContainer.lineFragmentPadding = 0
        textContainerInset.top = 16
        textContainerInset.bottom = 80
        //코어데이터 세팅
        /*xb
        CoreData.sharedInstance.textView = self
        updateTextView()
        //typingAttribute의 문단 세팅
        for (key, value) in defaultAttributes {
            typingAttributes[key.rawValue] = value
        }
        
        layoutManager.usesFontLeading = false
        
        textStorage.delegate = self
         */
        
        //TODO: 아이패드의 하단 바를 숨기기위한 방법. 이거 나중에 체크하기
        inputAssistantItem.leadingBarButtonGroups = []
        inputAssistantItem.trailingBarButtonGroups = []
    }
    /*
    internal func changeCreateNoteButtonState() {
        editor?.createNoteButton.isEnabled = attributedText.length != 0 ? true : false
    }
     */
}

/*
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
        //        print("\(editedMask) \(editedRange), \(delta)")
    }
    
}

extension PianoTextView {
    @IBAction func tapImageButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        inputView = sender.isSelected ? imagePickerView : nil
        editor?.mirrorScrollView.isHidden = sender.isSelected ? true : false
        reloadInputViews()
        if !sender.isSelected {
            imagePickerView.reset()
            keyboardType = .default
            reloadInputViews()
        } else {
            imagePickerView.fetchImages()
        }
    }
}
 */
