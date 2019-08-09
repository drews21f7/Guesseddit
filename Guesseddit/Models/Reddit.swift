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

extension RedditPost: Equatable {
    static func == (lhs: RedditPost, rhs: RedditPost) -> Bool {
        return lhs.post.id == rhs.post.id
    }
    
    
}

struct PostContent: Codable {
    
    var title: String
    var upVotes: Int
    var imageURLAsString: String?
    var postType: String?
    var isNSFW: Bool
    var isSelected: Bool = false
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case upVotes = "ups"
        case imageURLAsString = "url"
        case postType = "post_hint"
        case isNSFW = "over_18"
        case id
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



