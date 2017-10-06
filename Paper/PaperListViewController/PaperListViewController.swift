//
//  PaperListViewController.swift
//  Paper
//
//  Created by changi kim on 2017. 9. 26..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit
import CoreData

class PaperListViewController: DefaultViewController {
    
    @IBOutlet weak var tableView: PaperTableView!
    @IBOutlet weak var collectionView: TagCollectionView!
    @IBOutlet weak var trashButton: UIButton!
    let transition = PaperTransition()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func tapTrash(_ sender: UIButton) {
        //TODO: 휴지통 화면 띄우기
    }
    @IBAction func tapSearch(_ sender: Any) {
        //TODO: 아래 코드 여기다가 하지말고 paper.isTrash = true될 때 하기
        trashButton.isHidden = false
        AnimatorFactory.jiggle(view: trashButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PaperViewController" {
            let des = segue.destination as! PaperViewController
            if let attrText = sender as? NSAttributedString {
                des.thumbnailAttrText = attrText
            }
        }
    }
    
}


extension PaperListViewController {
    
    fileprivate func setup() {
        setupNavagationBar()
        collectionView.table = tableView
        tableView.paperListViewController = self
        navigationController?.delegate = self
    }
    
    private func setupNavagationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.groupTableViewBackground.withAlphaComponent(0.95)
        
        navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .bottom, barMetrics: .default)
        navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .bottom)
        navigationController?.toolbar.backgroundColor = UIColor.white.withAlphaComponent(0.95)
    }
    
    fileprivate func changeTitle(to: String) {
        self.title = to
    }
}

extension PaperListViewController: UINavigationControllerDelegate {
//    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return transition
//    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.operation = operation
        return transition
    }
}

