//
//  AnimatorFactory.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 3..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

struct AnimatorFactory {
    
//    @discardableResult
//    static func animateConstraint(view: UIView, constraint: NSLayoutConstraint, by: CGFloat) -> UIViewPropertyAnimator {
//        
//    }
    
    @discardableResult
    static func jiggle(view: UIView) -> UIViewPropertyAnimator {
        //UIViewPropertyAnimator의 duration동안 애니메이션이 발생함
        return UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.66, delay: 0, animations: {
                UIView.animateKeyframes(withDuration: 1, delay: 0, animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.125, animations: {
                        view.transform = CGAffineTransform(rotationAngle: -.pi/8)
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0.125, relativeDuration: 0.375, animations: {
                        view.transform = CGAffineTransform(rotationAngle: +.pi/8)
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0.375, relativeDuration: 0.5, animations: {
                        view.transform = CGAffineTransform.identity
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.625, animations: {
                        view.transform = CGAffineTransform(rotationAngle: -.pi/8)
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0.625, relativeDuration: 0.875, animations: {
                        view.transform = CGAffineTransform(rotationAngle: +.pi/8)
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0.875, relativeDuration: 1.0, animations: {
                        view.transform = CGAffineTransform.identity
                    })
                    
                    
                }, completion: nil)
        },
            completion: {_ in
                view.transform = CGAffineTransform.identity
        }
        ) }
}
