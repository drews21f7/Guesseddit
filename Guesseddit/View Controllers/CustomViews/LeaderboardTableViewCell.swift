//
//  LeaderboardTableViewCell.swift
//  Guesseddit
//
//  Created by Drew Seeholzer on 8/2/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    
    var tapAction: ((UITableViewCell) -> Void)?
    
   // var isBlocked = false
    
    @IBOutlet weak var positionNumberLabel: UILabel!    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var upvotesLabel: UILabel!
    @IBOutlet weak var blockButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func blockButtonTapped(_ sender: Any) {

        tapAction?(self)
        
        

        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
