//
//  GameTableViewCell.swift
//  Guesseddit
//
//  Created by Drew Seeholzer on 7/29/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var postLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
