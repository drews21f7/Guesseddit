//
//  GameViewController.swift
//  Guesseddit
//
//  Created by Drew Seeholzer on 8/8/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var redditPostsShuffled = RedditPostController.sharedInstance.redditPosts.shuffled()
    
    // Tracks number of guesses player has done
    var rounds = 0
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameTableView: UITableView!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.rowHeight = UITableView.automaticDimension
        print ("Shuffled posts = \(redditPostsShuffled.count)")
        scoreLabel.text = "\(score)"
        self.gameTableView.reloadData()
    }
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? GameTableViewCell
        
        let redditPost = self.redditPostsShuffled[indexPath.row]
        cell?.postImageView.image = nil
        //let redditPost = RedditPostController.sharedInstance.redditPosts[indexPath.row]
        
        cell?.postLabel.text = redditPost.post.title
        
        if redditPost.post.isNSFW == false && redditPost.post.postType == "image" {
            
            RedditPostController.sharedInstance.fetchPostImage(image: redditPost) { (image) in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    cell?.postImageView.image = image
                }
            }
        } else {
            cell?.postImageView.image = UIImage(named: "noimage")
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = UserController.sharedInstance.currentUser else { return }
        let newHighScore: Bool
        var scoreDifference = 0
        // Sets post with most upvotes to be the correct post
        let highestPost = correctPost(posts: redditPostsShuffled)
        // Checks the post user tapped
        let selectedPost = redditPostsShuffled[indexPath.row]
        
        // Checks if user selected the post with the most upvotes, then adds those upvotes to their score
        if highestPost == redditPostsShuffled.firstIndex(of: selectedPost) {
            score += selectedPost.post.upVotes
            print (score)
            print ("Great")
            
            // Checks to see if game is over yet, if not it removes the current posts and refills with new posts
            if rounds != 7 {
                rounds += 1
                print ("There are \(redditPostsShuffled.count) posts left")
                redditPostsShuffled.removeSubrange(0...2)
                tableView.reloadData()
                
                // Checks if user got a new high score at game end
            } else if user.topScore < score {
                scoreDifference = score - user.topScore
                UserController.sharedInstance.updateUserScore(user: user, score: score)
                newHighScore = true
                gameEndNotification(score: score, scoreDifference: scoreDifference, newHighScore: newHighScore)
            } else {
                scoreDifference = 0
                newHighScore = false
                gameEndNotification(score: score, scoreDifference: scoreDifference, newHighScore: newHighScore)
            }
        } else {
            // Divides current score by 4 on incorrect guess
            let scorePenalty = score / 4
            score -= scorePenalty
            // Checks to see if game is over yet, if not it removes the current posts and refills with new posts
            print (score)
            print ("Not great")
            if rounds != 7 {
                rounds += 1
                print ("There are \(redditPostsShuffled.count) posts left")
                redditPostsShuffled.removeSubrange(0...2)
                tableView.reloadData()
                
            } else if user.topScore < score {
                scoreDifference = score - user.topScore
                UserController.sharedInstance.updateUserScore(user: user, score: score)
                newHighScore = true
                gameEndNotification(score: score, scoreDifference: scoreDifference, newHighScore: newHighScore)
            } else {
                scoreDifference = 0
                newHighScore = false
                gameEndNotification(score: score, scoreDifference: scoreDifference, newHighScore: newHighScore)
            }
        }
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

//MARK: - Game functions
extension GameViewController {
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
    
    func gameEndNotification(score: Int, scoreDifference: Int, newHighScore: Bool) {
        if newHighScore == true {
            let alertController = UIAlertController(title: "New high score! You got \(score) upvotes!", message: "You got \(scoreDifference) more upvotes than your last score!", preferredStyle: .alert)
            //let playAgain = UIAlertAction(title: "Play again", style: .default)
            let mainMenu = UIAlertAction(title: "Main Menu", style: .cancel) { (_) in
                self.popView()
            }
            //alertController.addAction(playAgain)
            alertController.addAction(mainMenu)
            
            present(alertController, animated: true)
        } else {
            
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
}


