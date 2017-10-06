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
//    weak var storedContext: UIViewControllerContextTransitioning?
    weak var paperCell: PaperCell?
    
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
    
    private func popAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        //1. duration을 얻어 타겟 뷰 컨트롤러의 뷰를 fetch 해 트랜지션 컨테이너에 추가한다.
        let duration = transitionDuration(using: transitionContext)
        let container = transitionContext.containerView
        let from = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let to = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        container.addSubview(to)
        container.addSubview(from)

        if let navHeight = transitionContext.viewController(forKey: .from)?
            .navigationController?.navigationBar.bounds.height {
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            from.viewWithTag(10)?.alpha = 0
            from.viewWithTag(30)?.alpha = 0
            let textView = from.viewWithTag(20) as! PianoTextView
            textView.contentOffset.y += (statusBarHeight + navHeight)
        }
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut)
        
        if let cell = paperCell {
            animator.addAnimations {
                from.frame = cell.convert(cell.bounds, to: from)
            }
        }
        
        //4. UIKit에게 트랜지션이 끝났다는 걸 알려야 함
        animator.addCompletion {_ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
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
            to.frame = cell.convert(cell.bounds, to: to)
            to.frame.origin.y -= 4
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
