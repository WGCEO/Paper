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
    @IBOutlet weak var imageButton: UIButton!
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

    //MARK: ReactCursor
    internal var kbHeight: CGFloat?
    
    //MARK: Piano
    public var control = PianoControl()
    internal var coverView: UIView?
    
    //MARK: InputView
    internal lazy var photoView: PhotoView = {
        let nib = UINib(nibName: "PhotoView", bundle: nil)
        let photoView: PhotoView = nib.instantiate(withOwner: self, options: nil).first as! PhotoView
        photoView.delegate = self
        photoView.frame.size.height = self.kbHeight ?? 0
        return photoView
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
        
        if CoreData.sharedInstance.preference.showMirroring {
            mirrorScrollView.isHidden = false
        }
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

//MARK: IBAction
extension PianoTextView {
    @IBAction func tapImageButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        inputView = sender.isSelected ? photoView : nil
        mirrorScrollView.isHidden = sender.isSelected ? true : false
        reloadInputViews()
        if !sender.isSelected {
            photoView.reset()
            keyboardType = .default
            reloadInputViews()
        } else {
            photoView.fetchImages()
        }
    }
    
    @IBAction func tapMirroringButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        mirrorScrollView.isHidden = sender.isSelected && !imageButton.isSelected ? false : true
    }
    
    @IBAction func tapHideKeyboardButton(_ sender: UIButton) {
        resignFirstResponder()
    }
}

