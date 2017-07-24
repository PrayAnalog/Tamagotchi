//
//  ListPopUpTableViewCell.swift
//  Tamagotchi
//
//  Created by user on 2017. 7. 23..
//  Copyright © 2017년 user. All rights reserved.
//

import UIKit

class ListPopUpTableViewCell: UITableViewCell {

    @IBOutlet weak var ellementImageView: UIImageView!
    @IBOutlet weak var ellementNameLabel: UILabel!
    @IBOutlet weak var ellementValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        print(ellementNameLabel.text!)
        // Configure the view for the selected state
    }

}
