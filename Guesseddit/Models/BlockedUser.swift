//
//  BlockedUser.swift
//  Guesseddit
//
//  Created by Drew Seeholzer on 8/5/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import Foundation
import CloudKit

class BlockedUser {
    
    var blockedUserRecordID: CKRecord.ID
    var recordID: CKRecord.ID
    weak var user: User?
    
    var userReference: CKRecord.Reference? {
        guard let user = user else { return nil}
        return CKRecord.Reference(recordID: user.recordID, action: .deleteSelf)
    }
    
    init(blockedUserRecordID: CKRecord.ID, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), user: User?) {
        self.blockedUserRecordID = blockedUserRecordID
        self.recordID = recordID
        self.user = user
        //self.userReference = userReference
    }
    
    convenience init?(record: CKRecord) {
        guard let blockedUserRecordID = record[BlockedUserConstants.blockedUserRecordIDKey] as? CKRecord.ID,
            let user = record[BlockedUserConstants.userKey] as? User
        
            else { return nil }
        
        self.init(blockedUserRecordID: blockedUserRecordID, user: user)
    }
}

extension CKRecord {
    convenience init (blockedUser: BlockedUser) {
        self.init(recordType: BlockedUserConstants.recordType, recordID: blockedUser.recordID)
        //self.setValue(blockedUser.user, forKey: BlockedUserConstants.userKey)
        self.setValue(blockedUser.userReference, forKey: BlockedUserConstants.userReferenceKey)
    }
}

extension BlockedUser: Equatable {
    static func == (lhs: BlockedUser, rhs: BlockedUser) -> Bool {
        return lhs.recordID == rhs.recordID
    }
    
    
}

struct BlockedUserConstants {
    static let recordType = "BlockedUser"
    fileprivate static let blockedUserRecordIDKey = "blockedUserRecordID"
    fileprivate static let userKey = "user"
    static let userReferenceKey = "userReference"
}
