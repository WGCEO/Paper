//
//  PaperTransition.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 5..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class PaperTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
    internal var operation: UINavigationControllerOperation = .push
    weak var paperCell: PaperCell?
    weak var createPaperButton: UIButton?
    var interactive = false
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch operation {
        case .push:
            pushAnimator(using: transitionContext).startAnimation()
        case .pop:
            popAnimator(using: transitionContext).startAnimation()
        default:
            ()
        }
    }
    
//    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
//        switch operation {
//        case .push:
//            return pushAnimator(using: transitionContext)
//        case .pop:
//            return popAnimator(using: transitionContext)
//        default:
//            return pushAnimator(using: transitionContext)
//        }
//    }
    
    private func popAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        //1. duration을 얻어 타겟 뷰 컨트롤러의 뷰를 fetch 해 트랜지션 컨테이너에 추가한다.
        let duration = transitionDuration(using: transitionContext)
        let container = transitionContext.containerView
        let from = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let to = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        container.addSubview(to)
        container.addSubview(from)

        from.viewWithTag(10)?.alpha = 0
        from.viewWithTag(30)?.alpha = 0
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut)
        
        guard let navHeight = transitionContext.viewController(forKey: .from)?
            .navigationController?.navigationBar.bounds.height,
            let isNavigationBarHidden = transitionContext.viewController(forKey: .from)?
                .navigationController?.isNavigationBarHidden
            else { return animator }
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        if let cell = paperCell {
            animator.addAnimations {
                let textView = from.viewWithTag(20) as! PianoTextView
                
                let offsetY = !isNavigationBarHidden ?
                    (statusBarHeight + navHeight + textView.textContainerInset.top - 4) :
                    (statusBarHeight + textView.textContainerInset.top - 4)
                
                textView.contentOffset.y += offsetY
                from.frame = cell.label.convert(cell.label.bounds, to: from)
            }
        } else if let button = createPaperButton {
            animator.addAnimations {
                let textView = from.viewWithTag(20) as! PianoTextView
                
                let offsetY = !isNavigationBarHidden ?
                    (statusBarHeight + navHeight + textView.textContainerInset.top - 4) :
                    (statusBarHeight + textView.textContainerInset.top - 4)
                
                textView.contentOffset.y += offsetY
                from.frame = button.convert(button.bounds, to: from)
            }
        }
        
        //4. UIKit에게 트랜지션이 끝났다는 걸 알려야 함
        animator.addCompletion {[weak self]_ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self?.paperCell = nil
            self?.createPaperButton = nil
        }
        return animator
    }
    
    //위의 statusBar만
    private func pushAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        //1. duration을 얻어 타겟 뷰 컨트롤러의 뷰를 fetch 해 트랜지션 컨테이너에 추가한다.
        let duration = transitionDuration(using: transitionContext)
        let container = transitionContext.containerView
        let to = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        to.viewWithTag(10)?.alpha = 0
        container.addSubview(to)
        
        //2. 나타날 뷰에 대한 세팅
        let originalFrame = to.frame
        if let cell = paperCell {
            let textView = to.viewWithTag(20) as! PianoTextView
            to.frame = cell.label.convert(cell.label.bounds, to: to)
            to.frame.origin.y -= textView.textContainerInset.top
        } else if let button = createPaperButton {
            let textView = to.viewWithTag(20) as! PianoTextView
            to.frame = button.convert(button.bounds, to: to)
            to.frame.origin.y -= textView.textContainerInset.top
        }
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut)
        animator.addAnimations {
            to.frame = originalFrame
            to.viewWithTag(10)?.alpha = 1
        }
            
        //4. UIKit에게 트랜지션이 끝났다는 걸 알려야 함
        animator.addCompletion {_ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        return animator
    }

}
