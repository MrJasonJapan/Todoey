//
//  CustomMessageCell.swift
//  Flash Chat
//
//  Created by Angela Yu on 30/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class CustomCell: SwipeTableViewCell {

    @IBOutlet var background: UIView!
    @IBOutlet var dateCreated: UILabel!
    @IBOutlet var body: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
        
        
        
    }


}
