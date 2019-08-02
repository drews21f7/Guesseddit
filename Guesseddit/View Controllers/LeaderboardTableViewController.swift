//
//  LeaderboardTableViewController.swift
//  Guesseddit
//
//  Created by Drew Seeholzer on 8/2/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import UIKit

class LeaderboardTableViewController: UITableViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        UserController.sharedInstance.fetchUserList { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UserController.sharedInstance.userList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath) as? LeaderboardTableViewCell
        
        let user = UserController.sharedInstance.userList[indexPath.row]
        
        cell?.positionNumberLabel.text = "1"//"\(UserController.sharedInstance.userList[indexPath.item])"
        
        cell?.usernameLabel.text = user.username
        cell?.upvotesLabel.text = "\(user.topScore)"

        // Configure the cell...

        return cell ?? UITableViewCell()
    }

}
