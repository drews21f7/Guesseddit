//
//  LeaderboardTableViewController.swift
//  Guesseddit
//
//  Created by Drew Seeholzer on 8/2/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import UIKit
import CloudKit

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
        
  //      guard let currentUser = UserController.sharedInstance.currentUser else { return }
//        UserController.sharedInstance.fetchBlockedUsers(user: currentUser) { (blockedUsers) in
//            if (blockedUsers != nil) {
//                guard let blockedUsers = blockedUsers else { return }
//                currentUser.blockedUsers.append(contentsOf: blockedUsers)
//            }
//        }
//        UserController.sharedInstance.fetchUserList { (success) in
//            if success {
//                let userList = UserController.sharedInstance.userList
//                for user in userList {
//                    for blockedUser in currentUser.blockedUsers {
//                        if blockedUser.blockedUserRecordID == user.recordID {
//                            user.username = "*****"
//                        }
//                    }
////                    if (currentUser.blockedUsers.contains({$0 == user.recordID}) ?? false) {
////                        user.username = "*****"
////                    }
//                }
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//
//                }
//            }
//        }
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UserController.sharedInstance.userList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath) as? LeaderboardTableViewCell
        
        let user = UserController.sharedInstance.userList[indexPath.row]
        guard let currentUser = UserController.sharedInstance.currentUser else { return LeaderboardTableViewCell() }
        
        cell?.positionNumberLabel.text = "1"//"\(UserController.sharedInstance.userList[indexPath.item])"
        
        let reference = CKRecord.Reference(recordID: user.recordID, action: .none)
        
        if currentUser.blockedUserReferences.contains(reference) {
            cell?.usernameLabel.text = "*****"
        } else {
            cell?.usernameLabel.text = user.username
        }
        
        cell?.upvotesLabel.text = "\(user.topScore)"
        
        //cell?.accessoryType = .detailDisclosureButton
        if cell?.usernameLabel.text != "*****" {
            cell?.tapAction = { (cell) in
                
//                UserController.sharedInstance.blockUser(user: currentUser, userToBlock: user, completion: { (blockedUser) in
//
//                    UserController.sharedInstance.currentUser?.blockedUsers.append(blockedUser)
//                })
                UserController.sharedInstance.blockUserReference(user: currentUser, userToBlock: user, completion: { (success) in
                    if success {
                        // cell?.usernameLabel.text = "*****"
                        
                    }
                })
                tableView.reloadRows(at: [indexPath], with: .fade)
                
                
            }

        } //else {
//            var blockedUserArrayPos = 0
//            guard let currentUser = UserController.sharedInstance.currentUser else { return LeaderboardTableViewCell() }
//            for blockedUser in currentUser.blockedUsers {
//
//                if blockedUser == user.appleUserReference {
//                    cell?.tapAction = { (cell) in
//                        UserController.sharedInstance.currentUser?.blockedUsers.remove(at: blockedUserArrayPos)
//
//                    }
//                    break
//
//                } else {
//                    blockedUserArrayPos += 1
//                }
//            }
//        }

        // Configure the cell...

        return cell ?? UITableViewCell()
    }
    
//    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        if
//    }

}
