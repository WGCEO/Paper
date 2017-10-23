//
//  TestViewController.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 10..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    @IBAction func changeValue(_ sender: UISlider) {
        sender.setValue(Float(lroundf(sender.value)), animated: true)
    }
    


}
