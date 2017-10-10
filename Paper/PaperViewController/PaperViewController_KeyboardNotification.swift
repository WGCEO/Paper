//
//  PaperViewController_KeyboardNotification.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 9..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

extension PaperViewController {
    internal func registerKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(PaperViewController.keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PaperViewController.keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PaperViewController.keyboardDidHide(notification:)), name: Notification.Name.UIKeyboardDidHide, object: nil)
    }
    
    internal func unRegisterKeyboardNotification(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification){
        guard let userInfo = notification.userInfo,
            let kbFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
            else { return }
        
        
        textView.kbHeight = UIScreen.main.bounds.height - kbFrame.origin.y
        let bottom = UIScreen.main.bounds.height - kbFrame.origin.y
        textView.contentInset.bottom = bottom
        textView.scrollIndicatorInsets.bottom = bottom
        
        UIView.animate(withDuration: duration) { [weak self] in
            self?.textView.mirrorScrollViewBottom.constant = kbFrame.height
            self?.view.layoutIfNeeded()
        }
        
    }
    
    @objc internal func keyboardWillHide(notification: Notification){
        guard let userInfo = notification.userInfo,
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else { return }
        textView.scrollIndicatorInsets.bottom = 0
        UIView.animate(withDuration: duration) { [weak self] in
            self?.textView.contentInset = UIEdgeInsets.zero
            self?.textView.mirrorScrollViewBottom.constant = -37
            self?.view.layoutIfNeeded()
        }
    }
    @objc internal func keyboardDidHide(notification: Notification){
         textView.photoView.reset()
    }
    
}
