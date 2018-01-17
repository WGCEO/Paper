//
//  AppNavigator.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 13..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class AppNavigator {
    static var currentViewController: UIViewController? {
        let window = UIApplication.shared.keyWindow
        
        if let navigationController = window?.rootViewController as? UINavigationController {
            return navigationController.visibleViewController
        } else {
            return window?.rootViewController
        }
    }
    
    static var currentNavigationController: UINavigationController? {
        let window = UIApplication.shared.keyWindow
        
        return window?.rootViewController as? UINavigationController
    }
    
    class func present(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        currentViewController?.present(viewController, animated: animated, completion: completion)
    }
}
