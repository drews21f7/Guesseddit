//
//  Reddit.swift
//  Guesseddit
//
//  Created by Drew Seeholzer on 7/24/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import Foundation

struct TopLevelJSON: Codable {
    let data: [SecondLevelJSON]
}

struct SecondLevelJSON: Codable {
    let children: [ThirdLevelJSON]
}

struct ThirdLevelJSON: Codable {
    let data: [RedditPost]
}

struct RedditPost: Codable {
    
    var title: String
    var upVotes: Int
    var imageURLAsString: String?
    var isNSFW: Bool
    var isSelected: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case title
        case upVotes = "ups"
        case imageURLAsString = "thumbnail"
        case isNSFW = "over_18"
    }
}
