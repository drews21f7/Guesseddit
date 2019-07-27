//
//  RedditController.swift
//  Guesseddit
//
//  Created by Drew Seeholzer on 7/25/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import UIKit

class RedditPostController {
    
    //https://www.reddit.com/r/funny.json
    
    static let sharedInstance = RedditPostController()
    
    var redditPosts: [RedditPost] = []
    
    static let baseURL = URL(string: "https://www.reddit.com")
    
    func fetchSubRedditPosts(subReddit: String, completion: @escaping (TopLevelJSON?) -> Void) {
        
        guard var url = RedditPostController.baseURL else { completion (nil); return }
        
        url.appendPathComponent("r")
        url.appendPathComponent(subReddit)
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        guard let finalURL = components?.url else { completion(nil); return }
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error getting subreddit url: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else { completion(nil); return }
            
            do {
                let decoder = JSONDecoder()
                let topLevelJSON = try decoder.decode(TopLevelJSON.self, from: data)
//                let secondLevelJSON = try decoder.decode(SecondLevelJSON.self, from: data)
//                let thirdLevelJSON = try decoder.decode(ThirdLevelJSON.self, from: data)
                completion(topLevelJSON)
            } catch {
                print ("Error decoding data: \(error.localizedDescription)")
                completion(nil)
                return
            }
        }
    }
    
}
