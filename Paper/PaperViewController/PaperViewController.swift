//
//  PaperViewController.swift
//  Paper
//
//  Created by changi kim on 2017. 9. 26..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class PaperViewController: DefaultViewController {
    internal var shouldAppearKeyboard = false
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var screenEdgePanGesture: UIScreenEdgePanGestureRecognizer!
    @IBOutlet weak var textViewTop: NSLayoutConstraint!
    @IBOutlet weak var descriptionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textView: PianoTextView!
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet var toolbarButtons: [UIButton]!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var auxToolbarView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var auxToolbarViewBottom: NSLayoutConstraint!
    @IBOutlet weak var mirroringHelperView: UIView!
    
    internal var kbHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        //TODO: 화면 방향 바뀌면 다시 세팅해줘야 하는 것들:
        descriptionViewHeight.constant = topMargin()
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) {[unowned self] (_) in
            if !self.textView.isEditable {
                self.textView.attachControl()
            }
        }
    }

    
    @IBAction func screenEdgePan(_ sender: Any) {
        guard textView.isSelectable == true else { return }
        navigationController?.popViewController(animated: true)
        screenEdgePanGesture.isEnabled = !screenEdgePanGesture.isEnabled
    }
    
    private func setup(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        auxToolbarViewBottom.constant = -auxToolbarView.bounds.height
        textView.delegate = self
    }
    
    enum PickerViewType: Int {
        case TagPickerView = 0
        case PianoPickerView
        case FontPickerView
        case ColorPickerView
        case ConvertPickerView
        
        func nibName() -> String {
            return String(describing: self)
        }
        
        func descriptionString() -> String {
            switch self {
            case .TagPickerView:
                return "태그를 선택해 해당 메모를 분류하세요."
            case .PianoPickerView:
                return "형광펜처럼 손가락으로 글자를 칠해보세요."
            case .FontPickerView:
                return "글자의 크기를 조절해보세요."
            case .ColorPickerView:
                return "피아노 효과, 서식의 색상을 바꿔보세요."
            case .ConvertPickerView:
                return "이메일 혹은 PDF로 변환해보세요."
            }
        }
    }
    
    private func setButtonsDeselected(exceptFor button: UIButton){
        for toolbarButton in toolbarButtons {
            if toolbarButton != button {
                toolbarButton.isSelected = false
            }
        }
    }
    
    private func animateTextViewTop(isSelected: Bool) {
        textViewTop.constant = isSelected ? topMargin() : 0
        view.layoutIfNeeded()
    }
    
    private func animateAuxToolbar(isSelected: Bool) {
        auxToolbarViewBottom.constant = isSelected ?
            (view.bounds.height - toolbarView.frame.origin.y) :
            -auxToolbarView.bounds.height
        view.layoutIfNeeded()
    }
    
    private func setPickerViewIfNeeded(sender: UIButton) {
        removePickerViews()
        if let nibName = PickerViewType(rawValue: sender.tag)?.nibName(), sender.isSelected {
            addPickerView(nibName: nibName)
        }
    }
    
    private func setDescriptionViewIfNeeded(sender: UIButton) {
        if let desString = PickerViewType(rawValue: sender.tag)?.descriptionString() {
            descriptionLabel.text = desString
        }
    }
    
    private func setTextViewState(isSelected: Bool) {
        textView.isEditable = !isSelected
        textView.isSelectable = !isSelected
    }
    
    private func animateNavigationBar(isSelected: Bool) {
        navigationController?.hidesBarsOnSwipe = !isSelected
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func tapToolbarButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        setButtonsDeselected(exceptFor: sender)
        setPickerViewIfNeeded(sender: sender)
        
        
        CATransaction.setCompletionBlock { [weak self] in
            let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
                self?.animateTextViewTop(isSelected: sender.isSelected)
            }
            
            animator.addAnimations {
                self?.animateAuxToolbar(isSelected: sender.isSelected)
            }
            
            animator.addCompletion({ [weak self](_) in
                self?.setDescriptionViewIfNeeded(sender: sender)
                self?.setTextViewState(isSelected: sender.isSelected)
                self?.animateNavigationBar(isSelected: sender.isSelected)
                self?.addPianoViewIfNeeded(sender: sender)
                self?.setPanGestureEnabled(isSelected: sender.isSelected)
            })
            
            animator.startAnimation()
        }
    }
    
    private func setPanGestureEnabled(isSelected: Bool) {
        screenEdgePanGesture.isEnabled = !isSelected
    }
    
    private func addPianoViewIfNeeded(sender: UIButton) {
        
        if let nibName = PickerViewType(rawValue: sender.tag)?.nibName(),
            nibName == "PianoPickerView",
            sender.isSelected,
            let pianoPickerView =
            auxToolbarView.subviews.first as? PianoPickerView {
            let pianoView = addPianoView()
            pianoPickerView.delegate = pianoView
            pianoPickerView.delegate?.pianoPickerView(pianoPickerView, didSelectPickerAt: 0)
            textView.attachControl()
        }
    }
    
    
    @IBAction func tapImageButton(_ sender: UIButton) {
        Global.userFeedback()
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            textView.mirrorScrollView.isHidden = true
            addPhotoView()
        } else {
            removePhotoView()
            if CoreData.sharedInstance.preference.showMirroring {
                textView.mirrorScrollView.isHidden = false
                textView.mirrorScrollView.showMirroring(from: textView)
            }
        }
    }
    
    @IBAction func tapMirroringButton(_ sender: UIButton) {
        Global.userFeedback()
        sender.isSelected = !sender.isSelected
        textView.mirrorScrollView.isHidden = sender.isSelected && !imageButton.isSelected ? false : true
        CoreData.sharedInstance.preference.showMirroring = sender.isSelected
        if sender.isSelected {
            mirroringHelperView.isHidden = false
            mirroringHelperView.alpha = 1
            
            UIView.animate(withDuration: 0.5, delay: 1.5, options: [], animations: { [weak self] in
                self?.mirroringHelperView.alpha = 0.0
                }, completion: { (_) in
                    self.mirroringHelperView.isHidden = true
            })
            
            textView.mirrorScrollView.showMirroring(from: textView)
        }
    }
    
    private func removePickerViews(){
        for subView in auxToolbarView.subviews {
            subView.removeFromSuperview()
            
            if let pianoView = view.viewWithTag(1004) {
                pianoView.removeFromSuperview()
                textView.detachControl()
            }
        }
    }
    
    private func addPickerView(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        let pickerView = nib.instantiate(withOwner: nil, options: nil).first as! UIView
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        auxToolbarView.addSubview(pickerView)
        pickerView.topAnchor.constraint(equalTo: auxToolbarView.topAnchor).isActive = true
        pickerView.leadingAnchor.constraint(equalTo: auxToolbarView.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: auxToolbarView.trailingAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: auxToolbarView.bottomAnchor).isActive = true
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
        let pianoView = PianoView()
        pianoView.tag = 1004
        pianoView.isUserInteractionEnabled = false
        pianoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pianoView)
        pianoView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topMargin()).isActive = true
//        pianoView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        pianoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pianoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        pianoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        textView.control.pianoable = pianoView
        
        return pianoView
    }
}
