//
//  GameTableViewController.swift
//  Guesseddit
//
//  Created by Drew Seeholzer on 7/27/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import UIKit

class GameTableViewController: UITableViewController {
    
    var redditPostsShuffled = RedditPostController.sharedInstance.redditPosts.shuffled()
    
    @IBOutlet weak var scoreLabel: UILabel!
    
   var score = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "\(score)"
        self.tableView.reloadData()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false


    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? GameTableViewCell
        
        let redditPost = self.redditPostsShuffled[indexPath.row]
        cell?.postImageView.image = nil
        //let redditPost = RedditPostController.sharedInstance.redditPosts[indexPath.row]

        cell?.postTitleLabel.text = redditPost.post.title
        
        RedditPostController.sharedInstance.fetchPostImage(image: redditPost) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                cell?.postImageView.image = image
            }
        }

        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let highestPost = correctPost(posts: redditPostsShuffled)
            let selectedPost = redditPostsShuffled[indexPath.row]
            if highestPost == redditPostsShuffled.firstIndex(of: selectedPost) {
                score += selectedPost.post.upVotes
                print (score)
                print ("Great")
                if redditPostsShuffled.count > 3 {
                    print ("There are \(redditPostsShuffled.count) posts left")
                    redditPostsShuffled.removeSubrange(0...2)
                    tableView.reloadData()
                    
                } else {
                    gameEndNotification(score: score)
                }
            } else {
                print ("Not great")
                if redditPostsShuffled.count > 3 {
                   print ("There are \(redditPostsShuffled.count) posts left")
                    redditPostsShuffled.removeSubrange(0...2)
                    tableView.reloadData()
                    
                } else {
                    gameEndNotification(score: score)
                }
            }
          //  redditPostsShuffled.removeSubrange(0...3)
           // tableView.reloadData()
            
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}

extension GameTableViewController {
    //Checks first 4 posts in array and return post with highest number of upvotes
    func correctPost(posts: [RedditPost]) -> Int {
        var postLimiter = 0
        var mostUpvotes = posts[1]
        for post in posts {
            //Makes sure for loop only checks first 4 posts in array
            if postLimiter < 4 {
                postLimiter += 1
                if post.post.upVotes > mostUpvotes.post.upVotes {
                    mostUpvotes = post
                }
            } else {
                break
            }
        }
        return redditPostsShuffled.firstIndex(of: mostUpvotes)!
    }
    
    func popView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func gameEndNotification(score: Int) {
        let alertController = UIAlertController(title: "You got \(score) upvotes!", message: "", preferredStyle: .alert)
        //let playAgain = UIAlertAction(title: "Play again", style: .default)
        let mainMenu = UIAlertAction(title: "Main Menu", style: .cancel) { (_) in
            self.popView()
        }
        //alertController.addAction(playAgain)
        alertController.addAction(mainMenu)
        
        present(alertController, animated: true)
    }
}


