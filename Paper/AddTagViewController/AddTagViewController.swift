//
//  AddTagViewController.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 13..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

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
        return false
    }
}
