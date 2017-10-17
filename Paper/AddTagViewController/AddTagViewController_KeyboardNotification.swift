//
//  AddTagViewController_KeyboardNotification.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 17..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

extension AddTagViewController {
    internal func registerKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(AddTagViewController.keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddTagViewController.keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddTagViewController.keyboardDidHide(notification:)), name: Notification.Name.UIKeyboardDidHide, object: nil)
    }
    
    internal func unRegisterKeyboardNotification(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification){
        guard let userInfo = notification.userInfo,
            let kbFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
            else { return }
        
        let kbHeight = UIScreen.main.bounds.height - kbFrame.origin.y
        UIView.animate(withDuration: duration) { [weak self] in
            self?.tagViewBottom.constant = kbHeight
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc internal func keyboardWillHide(notification: Notification){
        guard let userInfo = notification.userInfo,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
            else { return }
        
        UIView.animate(withDuration: duration) { [weak self] in
            self?.tagViewBottom.constant = 0
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc internal func keyboardDidHide(notification: Notification){
        dismiss(animated: true, completion: nil)
    }
    
}
