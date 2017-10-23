//
//  ConvertPickerView.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 10..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class ConvertPickerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func tapConvertPDFButton(_ sender: Any) {
        guard let textView = CoreData.sharedInstance.textView else { return }
        
        ActivityIndicator.startAnimating()
        
        DocumentRenderer.render(type: .pdf, with: textView) { (pdfURL: URL?) in
            ActivityIndicator.stopAnimating()
            
            guard let url = pdfURL else { return }
            
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            AppNavigator.present(activityViewController)
        }
    }
    
}
