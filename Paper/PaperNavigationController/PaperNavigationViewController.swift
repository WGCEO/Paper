//
//  PaperNavigationViewController.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 9..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class PaperNavigationViewController: UINavigationController {
    let transition = PaperTransition()

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        setupNavagationBar()
    }
    
    private func setupNavagationBar(){
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = UIColor.groupTableViewBackground.withAlphaComponent(0.95)
        
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .bottom, barMetrics: .default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .bottom)
        toolbar.backgroundColor = UIColor.white.withAlphaComponent(0.95)
    }

}

extension PaperNavigationViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return transition.interactive ? transition : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        //애니메이션 전에 키보드 먼저 내리기
        if let paperVC = fromVC as? PaperViewController {
            paperVC.textView.resignFirstResponder()
        }
        
        //페이퍼뷰에서 페이퍼리스트로 pop되는 경우에, 유저가 텍스트뷰를 편집했을 경우, paper의 thumnailText에 썸네일 텍스트 저장
        if let paperVC = fromVC as? PaperViewController
            , let attributedText = paperVC.textView.attributedText
            , operation == .pop
            , paperVC.textView.userEdited {
            let thumbnailAttrString = attributedText.thumbnailAttrString()
            
            CoreData.sharedInstance.paper.thumbnailContent
                = thumbnailAttrString != nil
                ? NSKeyedArchiver.archivedData(withRootObject: thumbnailAttrString!)
                : nil
            
            
            //유저가 텍스트뷰를 편집했다면, 비동기 저장(여기가 비동기 저장 가능한 유일한 장소: NSAttributedString 존재하는, 화면 진행 순서에 대한 버그가 없는 마지막 위치)
            if let paper = CoreData.sharedInstance.paper {
                CoreData.sharedInstance.asyncSave(attrString: attributedText, to: paper)
            }
            
        }
        
        transition.operation = operation
        return transition
    }
}
