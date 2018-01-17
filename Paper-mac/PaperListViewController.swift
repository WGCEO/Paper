//
//  ViewController.swift
//  Paper-mac
//
//  Created by changi kim on 2017. 10. 24..
//  Copyright © 2017년 Piano. All rights reserved.
//

import Cocoa

class PaperListViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func tap(_ sender: Any) {
        let nextViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Hello")) as! NSViewController
        
        if let window = view.window {
            // adjust view size to current window
            nextViewController.view.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
        }
        
        view.window?.contentViewController = nextViewController
    }
}

