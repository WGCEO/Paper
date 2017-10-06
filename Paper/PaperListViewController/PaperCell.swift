//
//  PaperCell.swift
//  Paper
//
//  Created by changi kim on 2017. 9. 26..
//  Copyright © 2017년 Piano. All rights reserved.
//

import UIKit

class PaperCell: UITableViewCell, Reusable {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //TODO: 여기서 더보기 히든 시킬 지 말지를 결정
        
        
        //여기서 width 컨스트레인트를 결정
        let margin = Global.textMargin(by: bounds.width)
        leftConstraint.constant = margin
        rightConstraint.constant = margin
    }


}
