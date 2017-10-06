//
//  PaperViewController.swift
//  Paper
//
//  Created by changi kim on 2017. 9. 26..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class PaperViewController: DefaultViewController {

    @IBOutlet weak var textView: PianoTextView!
    @IBOutlet weak var toolbar: UIToolbar!
    var thumbnailAttrText: NSAttributedString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.attributedText = thumbnailAttrText
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .bottom, barMetrics: .default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .bottom)
        toolbar.backgroundColor = UIColor.white.withAlphaComponent(0.95)
    }

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
