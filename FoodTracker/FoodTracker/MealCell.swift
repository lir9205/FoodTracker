//
//  MealCell.swift
//  FoodTracker
//
//  Created by 李芮 on 17/2/20.
//  Copyright © 2017年 7feel. All rights reserved.
//

import UIKit

class MealCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    
    override func awakeFromNib() {
         super.awakeFromNib()
        
        ratingControl.isUserInteractionEnabled = false
        
    }
    
    
}
