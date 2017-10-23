//
//  ActivityIndicator.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 23..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class ActivityIndicator {
    static private var sharedIndicator: UIActivityIndicatorView = {
        let mainScreen = UIScreen.main.bounds
        let activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        activityIndicatorView.center = CGPoint(x: mainScreen.midX, y: mainScreen.midY)
        activityIndicatorView.activityIndicatorViewStyle = .gray
        activityIndicatorView.hidesWhenStopped = true
        
        UIApplication.shared.keyWindow?.addSubview(activityIndicatorView)
        
        return activityIndicatorView
    }()
    
    static public var isAnimating: Bool {
        return ActivityIndicator.sharedIndicator.isAnimating
    }
    
    public class func startAnimating() {
        if isAnimating {
            return
        }
        
        UIApplication.shared.keyWindow?.bringSubview(toFront: sharedIndicator)
        
        let mainScreen = UIScreen.main.bounds
        sharedIndicator.center = CGPoint(x: mainScreen.midX, y: mainScreen.midY)
        sharedIndicator.activityIndicatorViewStyle = .gray
        
        sharedIndicator.startAnimating()
    }
    
    public class func stopAnimating() {
        sharedIndicator.stopAnimating()
    }
}
