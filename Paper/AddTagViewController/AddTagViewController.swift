//
//  AddTagViewController.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 13..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit
import CoreData

class AddTagViewController: DefaultViewController {
    @IBOutlet weak var collectionView: AddTagCollectionView!
    @IBOutlet weak var tagViewBottom: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unRegisterKeyboardNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Global.userFeedback()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        CATransaction.setCompletionBlock { [weak self] in
            self?.dismiss(animated: true, completion: nil)
            }
        textField.resignFirstResponder()
    }
}

extension AddTagViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //TODO: 태그들 중 현재 입력된 텍스트와 일치하는 태그이름이 있다면 해당 태그로 스크롤해주고, 추가하지 말기
        
        
        //TODO 코어데이터에 저장하고, textfield는 초기화하기
        if let name = textField.text {
            let tag = CoreData.sharedInstance.createTag(name: name)
            CoreData.sharedInstance.paper.tags = tag
            textField.text = ""
        }
        
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string != " " ? true : false
    }
    
    

    
}
