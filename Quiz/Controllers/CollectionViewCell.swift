//
//  CollectionViewCell.swift
//  Quiz
//
//  Created by Quynh on 2/10/20.
//  Copyright © 2020 Quynh. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var subjectLabel: UILabel!
    
    let colors1: [UIColor] = [UIColor.purple, UIColor.green]
    let colors2: [UIColor] = [UIColor.white, UIColor.cyan]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subjectLabel.textColor = UIColor(red:0.29, green:0.75, blue:0.65, alpha:1.0)
        containerView.layer.cornerRadius = 10
        self.bringSubviewToFront(subjectLabel)
        
    }
    

}
