//
//  User.swift
//  Guesseddit
//
//  Created by Drew Seeholzer on 8/1/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import Foundation
import CloudKit

class User {
    // Class Properties
    var username: String
    var topScore: Int = 0
    var blockedUsers: [BlockedUser]
    var blockedUserReferences: [CKRecord.Reference]
    // iCloud Class Properties
    let recordID: CKRecord.ID
    let appleUserReference: CKRecord.Reference
    
    /// Initializes a new User object
    init(username: String, topScore: Int, blockedUsers: [BlockedUser] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserReference: CKRecord.Reference, blockedUserReferences: [CKRecord.Reference] = []) {
        self.username = username
        self.topScore = topScore
        self.blockedUsers = blockedUsers
        self.recordID = recordID
        self.appleUserReference = appleUserReference
        self.blockedUserReferences = blockedUserReferences
    }
}

extension User {
    /// Initializes an existing User object from a CKRecord
    convenience init?(record: CKRecord) {
        // check against values
        guard let username = record[UserConstants.usernameKey] as? String,
        let topScore = record[UserConstants.topScoreKey] as? Int,
        let appleUserReference = record[UserConstants.appleUserReferenceKey] as? CKRecord.Reference
            else { return nil }
        
        let blockedUsers = record[UserConstants.blockedUsersKey] as? [BlockedUser]
        let blockedUserReferences = record[UserConstants.blockedUserRefKey] as? [CKRecord.Reference] ?? []
        
        self.init(username: username, topScore: topScore, blockedUsers: blockedUsers ?? [], recordID: record.recordID, appleUserReference: appleUserReference, blockedUserReferences: blockedUserReferences)
    }
}

extension CKRecord {
    /// Initializes a CKRecord from an existing User object
    convenience init(user: User) {
        self.init(recordType: UserConstants.typeKey, recordID: user.recordID)
        
        self.setValue(user.username, forKey: UserConstants.usernameKey)
        self.setValue(user.topScore, forKey: UserConstants.topScoreKey)
        //self.setValue(user.blockedUsers, forKey: UserConstants.blockedUsersKey)
        self.setValue(user.appleUserReference, forKey: UserConstants.appleUserReferenceKey)
        if !user.blockedUserReferences.isEmpty  {
            self.setValue(user.blockedUserReferences, forKey: UserConstants.blockedUserRefKey)
        }
    }
}

struct UserConstants {
    static let typeKey = "User"
    fileprivate static let usernameKey = "username"
    fileprivate static let topScoreKey = "topScore"
    fileprivate static let blockedUsersKey = "blockedUsers"
    fileprivate static let appleUserReferenceKey = "appleUserReference"
    fileprivate static let blockedUserRefKey = "blockedUserReferences"
}

