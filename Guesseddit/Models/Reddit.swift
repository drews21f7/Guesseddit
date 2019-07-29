//
//  Reddit.swift
//  Guesseddit
//
//  Created by Drew Seeholzer on 7/24/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import Foundation

struct TopLevelJSON: Codable {
    let data: SecondLevelJSON
}

struct SecondLevelJSON: Codable {
    let children: [RedditPost]
}

struct RedditPost: Codable {
    let post: PostContent
    
    enum CodingKeys: String, CodingKey {
        case post = "data"
    }
}

struct PostContent: Codable {
    
    var title: String
    var upVotes: Int
    var imageURL: URL?
    var isNSFW: Bool
    var isSelected: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case title
        case upVotes = "ups"
        case imageURL = "thumbnail"
        case isNSFW = "over_18"
    }
}
