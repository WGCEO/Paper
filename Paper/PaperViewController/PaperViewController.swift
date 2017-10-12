//
//  PaperViewController.swift
//  Paper
//
//  Created by changi kim on 2017. 9. 26..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class PaperViewController: DefaultViewController {
    private var panned = false
    internal var shouldAppearKeyboard = false
    
    @IBOutlet weak var textViewTop: NSLayoutConstraint!
    @IBOutlet weak var textView: PianoTextView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet var toolbarButtons: [UIButton]!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var auxToolbarView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    
    internal var kbHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldAppearKeyboard {
            textView.becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unRegisterKeyboardNotification()

    }
    
    @IBAction func screenEdgePan(_ sender: Any) {
        guard !panned else { return }
        navigationController?.popViewController(animated: true)
        panned = true
    }
    
    private func setup(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .bottom, barMetrics: .default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .bottom)
        toolbar.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        
    }
    
    //자신을 제외한 모든 버튼은 선택 풀기
    @IBAction func tapTagButton(_ sender: UIButton) {
        for button in toolbarButtons {
            if sender != button {
                button.isSelected = false
            }
        }
        sender.isSelected = !sender.isSelected
        
        //TODO: if sender.isSelected 일 경우, auxToolBarView 애니메이션해서 튀어오르게 하고, 태그 피커 뷰만 보이게 하기
        //TODO: 선택되지 않을 경우 auxToolBarView 애니메이션으로 내리게 하고, removeFromSuperView하기
    }
    
    @IBAction func tapPianoButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        for button in toolbarButtons {
            if button != sender {
                button.isSelected = false
            }
        }
        
        if sender.isSelected {
            //1. 애니메이션 시켜서 auxToolbar 튀어오르게 하기
            //2. auxToolbar에 피아노피커 뷰 생성해 붙이기
            //3. 피아노
        } else {
            
        }
    }
    
    @IBAction func tapColorButton(_ sender: UIButton) {
        
    }
    
    @IBAction func tapFontButton(_ sender: UIButton) {
        
    }
    
    @IBAction func tapShareButton(_ sender: UIButton) {
        
    }
    
    @IBAction func tapImageButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            addPhotoView()
        } else {
            removePhotoView()
        }
        textView.mirrorScrollView.isHidden = sender.isSelected ? true : false
    }
    
    @IBAction func tapMirroringButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        textView.mirrorScrollView.isHidden = sender.isSelected && !imageButton.isSelected ? false : true
        CoreData.sharedInstance.preference.showMirroring = sender.isSelected
        if sender.isSelected {
            textView.mirrorScrollView.showMirroring(from: textView)
        }
    }
    
    @IBAction func tapHideKeyboardButton(_ sender: UIButton) {
        textView.resignFirstResponder()
    }
    

    

    
    private func removePickerViews(){
        for subView in auxToolbarView.subviews {
            subView.removeFromSuperview()
            
            if let pianoView = view.viewWithTag(1004) {
                pianoView.removeFromSuperview()
            }
        }
    }
    
    private func addPickerView(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        let pickerView = nib.instantiate(withOwner: nil, options: nil).first as! UIView
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.topAnchor.constraint(equalTo: auxToolbarView.topAnchor).isActive = true
        pickerView.leadingAnchor.constraint(equalTo: auxToolbarView.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: auxToolbarView.trailingAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: auxToolbarView.bottomAnchor).isActive = true
        auxToolbarView.addSubview(pickerView)
        
        if let pianoPickerView = pickerView as? PianoPickerView {
            let pianoView = addPianoView()
            pianoPickerView.delegate = pianoView
        }
    }
    
   
    
    private func addPhotoView(){
        let nib = UINib(nibName: "PhotoView", bundle: nil)
        let photoView: PhotoView = nib.instantiate(withOwner: nil, options: nil).first as! PhotoView
        photoView.delegate = textView
        photoView.frame.size.height = self.kbHeight ?? 0
        photoView.fetchImages()
        textView.inputView = photoView
        textView.reloadInputViews()
    }
    
    private func removePhotoView(){
        textView.inputView = nil
        textView.reloadInputViews()
    }
    
    //TODO: 피아노피커뷰와 피아노 뷰도 동적으로 생성하고, 피커뷰 먼저 만들고, 그다음 피아노 뷰 만들어서 피아노 뷰에 어트리뷰트 세팅하기
    private func addPianoView() -> PianoView {
        let view = PianoView()
        view.tag = 1004
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        view.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        view.addSubview(view)
        textView.control.pianoable = view
        return view
    }
    
//    private func animateToPiano(isReversed: Bool) {
//        UIView.animate(withDuration: Global.duration, animations: { [weak self] in
//            if !isReversed {
//                self?.textViewTop.constant = 64
//                self?.view.layoutIfNeeded()
//
//            }
//
//        }, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
//    }
    
    
    //TODO
    //피아노 모드를 실행할 때 false하고, 종료할 때 true시키기
//    navigationController?.hidesBarsOnSwipe = false
}
