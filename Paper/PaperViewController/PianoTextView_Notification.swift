//
//  PianoTextView_Notification.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 5..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

//MARK: Keyboard
extension PianoTextView {
    
    internal func registerKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(PianoTextView.keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PianoTextView.keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PianoTextView.keyboardDidHide(notification:)), name: Notification.Name.UIKeyboardDidHide, object: nil)
    }
    
    internal func unRegisterKeyboardNotification(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification){
        guard let userInfo = notification.userInfo,
            let kbFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            else { return }
        
        
        self.kbHeight = UIScreen.main.bounds.height - kbFrame.origin.y
        
        let bottom = UIScreen.main.bounds.height - kbFrame.origin.y
        contentInset.bottom = bottom
        scrollIndicatorInsets.bottom = bottom
        
    }
    
    @objc internal func keyboardWillHide(notification: Notification){
        guard let userInfo = notification.userInfo,
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else { return }
        scrollIndicatorInsets.bottom = 0
        UIView.animate(withDuration: duration) { [weak self] in
            self?.contentInset = UIEdgeInsets.zero
        }
    }
    @objc internal func keyboardDidHide(notification: Notification){
        /*
        imagePickerView.reset()
         */
    }

}
