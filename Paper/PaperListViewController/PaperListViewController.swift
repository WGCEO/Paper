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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func tapTrash(_ sender: UIButton) {
        //TODO: 휴지통 화면 띄우기
    }
    @IBAction func tapSearch(_ sender: UIBarButtonItem) {
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
        collectionView.table = tableView
        tableView.paperListViewController = self
    }
    
    fileprivate func changeTitle(to: String) {
        self.title = to
    }
}

