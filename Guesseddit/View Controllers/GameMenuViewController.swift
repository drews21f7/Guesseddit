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
        subRedditChoiceLabel.text = ""
        
    }
    
    //MARK: - Subreddit Buttons
    @IBAction func askRedditButtonTapped(_ sender: Any) {
        
        RedditPostController.sharedInstance.fetchSubRedditPosts(subReddit: "askreddit") { (subReddit) in
            if let subReddit = subReddit {
                RedditPostController.sharedInstance.redditPosts = subReddit
                self.subRedditChosen = true
                DispatchQueue.main.async {
                    self.subRedditChoiceLabel.text = "Ask Reddit"
                }
            }
        }
    }
    @IBAction func todayILearnedButtonTapped(_ sender: Any) {
        
        RedditPostController.sharedInstance.fetchSubRedditPosts(subReddit: "todayilearned") { (subReddit) in
            if let subReddit = subReddit {
                RedditPostController.sharedInstance.redditPosts = subReddit
                self.subRedditChosen = true
                DispatchQueue.main.async {
                    self.subRedditChoiceLabel.text = "Today I Learned"
                }
            }
        }
    }
    @IBAction func worldNewsButtonTapped(_ sender: Any) {
        
        RedditPostController.sharedInstance.fetchSubRedditPosts(subReddit: "worldnews") { (subReddit) in
            if let subReddit = subReddit {
                RedditPostController.sharedInstance.redditPosts = subReddit
                self.subRedditChosen = true
                DispatchQueue.main.async {
                    self.subRedditChoiceLabel.text = "World News"
                }
            }
        }
    }
    @IBAction func scienceButtonTapped(_ sender: Any) {
        
        RedditPostController.sharedInstance.fetchSubRedditPosts(subReddit: "science") { (subReddit) in
            if let subReddit = subReddit {
                RedditPostController.sharedInstance.redditPosts = subReddit
                self.subRedditChosen = true
                DispatchQueue.main.async {
                    self.subRedditChoiceLabel.text = "Science"
                }
            }
        }
    }
    @IBAction func picsButtonTapped(_ sender: Any) {

        RedditPostController.sharedInstance.fetchSubRedditPosts(subReddit: "pics") { (subReddit) in
            if let subReddit = subReddit {
                RedditPostController.sharedInstance.redditPosts = subReddit
                self.subRedditChosen = true
                DispatchQueue.main.async {
                    self.subRedditChoiceLabel.text = "Pics"
                }
            }
        }
    }
    @IBAction func gamingButtonTapped(_ sender: Any) {
       // if RedditPostController.sharedInstance.redditPosts.count == 0 {
            RedditPostController.sharedInstance.fetchSubRedditPosts(subReddit: "gaming") { (subReddit) in
                if let subReddit = subReddit {
                    RedditPostController.sharedInstance.redditPosts = subReddit
                    self.subRedditChosen = true
                    DispatchQueue.main.async {
                        self.subRedditChoiceLabel.text = "Gaming"
                    }
                }
            }
      //  } //else {
//            RedditPostController.sharedInstance.redditPosts = []
//            RedditPostController.sharedInstance.fetchSubRedditPosts(subReddit: "gaming") { (gaming) in
//                if let gaming = gaming {
//                    RedditPostController.sharedInstance.redditPosts = gaming
//                    self.subRedditChosen = true
//                    DispatchQueue.main.async {
//                        self.subRedditChoiceLabel.text = "Gaming"
//
//                    }
//                }
//            }
//        }
    }
    
    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toGameSegue" {
            if subRedditChosen == true {
                return true
            }else{
                //present an alert controller
                let alertController = UIAlertController.init(title: "No Subreddit selected", message: "You must first select a subreddit", preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok", style: .cancel)
                alertController.addAction(ok)
                present(alertController, animated: true)
                return false 
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGameSegue" {
            
        }
        if segue.identifier == "toGameLeaderboard" {
            
        }
    }

    @IBAction func viewLeaderboardButtonTapped(_ sender: Any) {
    }
}
