//
//  DefaultViewController.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 3..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class DefaultViewController: UIViewController {
    
    lazy var statusView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground.withAlphaComponent(0.95)
        view.frame = UIApplication.shared.statusBarFrame
        view.tag = 10
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(statusView)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) {[unowned self] (_) in
            self.statusView.frame = UIApplication.shared.statusBarFrame
        }
    }

}
