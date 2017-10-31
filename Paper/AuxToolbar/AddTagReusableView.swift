//
//  AddTagReusableView.swift
//  Paper
//
//  Created by changi kim on 2017. 10. 10..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class AddTagReusableView: UICollectionReusableView, Reusable {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Global.userFeedback()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        AppNavigator.currentViewController?.performSegue(withIdentifier: "AddTagViewController", sender: nil)
    }
    
}
