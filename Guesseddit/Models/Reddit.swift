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
    var imageURLAsString: String?
    var isNSFW: Bool
    var isSelected: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case title
        case upVotes = "ups"
        case imageURLAsString = "url"
        case isNSFW = "over_18"
    }
    
//    struct Images: Codable {
//        let images: [Resolutions]
//    }
//
//    struct Resolutions: Codable {
//        let resolutions: [PostImage]
//
//        struct PostImage: Codable {
//            let imageURLAsString: String
//
//            enum CodingKeys: String, CodingKey {
//                case imageURLAsString = "url"
//            }
//        }
//    }
}



