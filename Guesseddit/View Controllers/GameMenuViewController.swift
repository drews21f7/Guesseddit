//
//  GameMenuViewController.swift
//  Guesseddit
//
//  Created by Drew Seeholzer on 7/29/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import UIKit

class GameMenuViewController: UIViewController {
    
    @IBOutlet weak var subRedditChoiceLabel: UILabel!
    
    var subRedditChosen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Subreddit Buttons
    @IBAction func askRedditButtonTapped(_ sender: Any) {
    }
    @IBAction func todayILearnedButtonTapped(_ sender: Any) {
    }
    @IBAction func worldNewsButtonTapped(_ sender: Any) {
    }
    @IBAction func scienceButtonTapped(_ sender: Any) {
    }
    @IBAction func picsButtonTapped(_ sender: Any) {
    }
    @IBAction func gamingButtonTapped(_ sender: Any) {
        if RedditPostController.sharedInstance.redditPosts.count == 0 {
            RedditPostController.sharedInstance.fetchSubRedditPosts(subReddit: "gaming") { (gaming) in
                if let gaming = gaming {
                    RedditPostController.sharedInstance.redditPosts = gaming
                    self.subRedditChosen = true
                }
            }
        } else {
            RedditPostController.sharedInstance.redditPosts = []
            RedditPostController.sharedInstance.fetchSubRedditPosts(subReddit: "gaming") { (gaming) in
                if let gaming = gaming {
                    RedditPostController.sharedInstance.redditPosts = gaming
                    self.subRedditChosen = true
                }
            }
        }
    }
    
    
    // MARK: - Navigation
    
    //View Changing Buttons
    @IBAction func playGameButtonTapped(_ sender: Any) {
        if subRedditChosen == true {
            
            performSegue(withIdentifier: "segueToGame", sender: self)
        }// TODO: - Make notification when false
    }
    @IBAction func viewLeaderboardButtonTapped(_ sender: Any) {
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
   // }

}
