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
    var email: String?
    var password: String
    // iCloud Class Properties
    let recordID: CKRecord.ID
    let appleUserReference: CKRecord.Reference
    
    /// Initializes a new User object
    init(username: String, email: String, password: String, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserReference: CKRecord.Reference) {
        self.username = username
        self.email = email
        self.password = password
        self.recordID = recordID
        self.appleUserReference = appleUserReference
    }
}

extension User {
    /// Initializes an existing User object from a CKRecord
    convenience init?(record: CKRecord) {
        // check against values
        guard let username = record[UserConstants.usernameKey] as? String,
        let email = record[UserConstants.emailKey] as? String,
        let password = record[UserConstants.passwordKey] as? String,
        let appleUserReference = record[UserConstants.appleUserReferenceKey] as? CKRecord.Reference
            else { return nil }
        
        self.init(username: username, email: email, password: password, recordID: record.recordID, appleUserReference: appleUserReference)
    }
}

extension CKRecord {
    /// Initializes a CKRecord from an existing User object
    convenience init(user: User) {
        self.init(recordType: UserConstants.typeKey, recordID: user.recordID)
        
        self.setValue(user.username, forKey: UserConstants.usernameKey)
        self.setValue(user.email, forKey: UserConstants.emailKey)
        self.setValue(user.password, forKey: UserConstants.passwordKey)
        self.setValue(user.appleUserReference, forKey: UserConstants.appleUserReferenceKey)
    }
}

struct UserConstants {
    static let typeKey = "User"
    fileprivate static let usernameKey = "username"
    fileprivate static let emailKey = "email"
    fileprivate static let passwordKey = "password"
    fileprivate static let appleUserReferenceKey = "appleUserReference"
}
