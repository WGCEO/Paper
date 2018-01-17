//
//  PDFViewController.swift
//  Paper
//
//  Created by changi kim on 2017. 11. 1..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit
import WebKit

class PDFViewController: UIViewController {
    
    var webView: WKWebView!
    var pdfGenerator: PDFGenerator!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = pdfGenerator.generatePDFfile("paper")
        webView.load(URLRequest(url: url))

    }

    @IBAction func tapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
