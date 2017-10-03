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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}


extension PaperListViewController {
    
    fileprivate func setup() {
        setupNavagationBar()
        collectionView.table = tableView
    }
    
    private func setupNavagationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        
        navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .bottom, barMetrics: .default)
        navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .bottom)
        navigationController?.toolbar.backgroundColor = UIColor.white.withAlphaComponent(0.95)
    }
    
    fileprivate func changeTitle(to: String) {
        self.title = to
    }
}
