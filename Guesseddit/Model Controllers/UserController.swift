//
//  UserController.swift
//  Guesseddit
//
//  Created by Drew Seeholzer on 8/1/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    static let sharedInstance = UserController()
    
    var currentUser: User?
    
    var userList: [User] = []
    
    // MARK: - CRUD
    
    // Create
    func createUserWith(username: String, topScore: Int, completion: @escaping (User?) -> Void) {
        
        // Unwrap the optional CKReference or complete nil
        CloudKitController.sharedInstance.fetchAppleUserReference { (reference) in
            
            guard let appleUserReference = reference else { completion(nil) ; return }
            let newUser = User(username: username, topScore: topScore, appleUserReference: appleUserReference)
            let userRecord = CKRecord(user: newUser)
            let database = CloudKitController.sharedInstance.publicDB
            
            CloudKitController.sharedInstance.save(record: userRecord, database: database, completion: { (record) in
                guard let record = record,
                let user = User(record: record)
                    else { completion(nil) ; return }
                
                self.currentUser = user
                completion(user)
            })
        }
    }
    
    func blockUser(user: User, userToBlock: User, completion: @escaping (BlockedUser) -> Void) {
        
        let newUserBlocked = BlockedUser(blockedUserRecordID: userToBlock.recordID, user: user)
        let userRecord = CKRecord(blockedUser: newUserBlocked)
        let database = CloudKitController.sharedInstance.publicDB
        
        CloudKitController.sharedInstance.save(record: userRecord, database: database) { (record) in
            guard let record = record,
            let blockedUser = BlockedUser(record: record)
                else { return }
            
            completion(blockedUser)
        }
    }
    
    func blockUserReference(user: User, userToBlock: User, completion: @escaping (Bool) -> Void) {
        
        guard let currentUser = UserController.sharedInstance.currentUser else { completion(false); return }
        let userReferenceToBlock = CKRecord.Reference(recordID: userToBlock.recordID, action: .none)
        
        
        currentUser.blockedUserReferences.append(userReferenceToBlock)
        
        let record = CKRecord(user: currentUser)
        let database = CloudKitController.sharedInstance.publicDB
        CloudKitController.sharedInstance.update(record: record, database: database) { (success) in
            if success {
                print("yayayayayayayayayayaya")
            }
            completion(success)
        }
        
    }
    
    // Read
    func fetchUserBool(completion: @escaping (Bool) -> Void) {
        
        // Unwrap the optional CKReference or complete nil
        CloudKitController.sharedInstance.fetchAppleUserReference { (reference) in
            guard let appleUserReference = reference else { completion(false) ; return }
            
            let predicate = NSPredicate(format: "appleUserReference == %@", appleUserReference)
            let database = CloudKitController.sharedInstance.publicDB
            CloudKitController.sharedInstance.fetchSingleRecord(ofType: UserConstants.typeKey, withPredicate: predicate, database: database, completion: { (records) in
                
                guard let records = records,
                let record = records.first
                    else { completion(false) ; return }
                
                self.currentUser = User(record: record)
                completion(true)
            })
        }
    }
    
    func fetchBlockedUsers(user: User, completion: @escaping ([BlockedUser]?) -> Void) {
        
        let userPredicate = NSPredicate(format: "%K == %@", BlockedUserConstants.userReferenceKey)
 //       let blockedUserIDs = user.blockedUsers.compactMap( { $0.blockedUserRecordID } )
//        let avoidDuplicatePredicates = NSPredicate(format: "NOT(recordID IN %@)", blockedUserIDs)
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, avoidDuplicatePredicates])
        
        let type = BlockedUserConstants.recordType
        let database = CloudKitController.sharedInstance.publicDB
        CloudKitController.sharedInstance.fetchRecordsOf(type: type, predicate: userPredicate, database: database) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
            }
            
            guard let records = records else { return }
            let blockedUsers = records.compactMap({BlockedUser(record: $0)} )
            
            completion(blockedUsers)
        }
    }
    
    
    func fetchUserList(completion: @escaping (Bool) -> Void) {
        
        let type = UserConstants.typeKey
        let database = CloudKitController.sharedInstance.publicDB
        let predicate = NSPredicate(value: true)
        CloudKitController.sharedInstance.fetchRecordsOf(type: type, predicate: predicate, database: database) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(false)
            }
            
            guard let records = records else { return }
            let users = records.compactMap( {User(record: $0)} )
            //self.sortUserScores(userArray: users)
            self.userList = users
            self.userList.sort(by: { $0.topScore > $1.topScore })
            completion(true)
        }
    }
    
    // Update
    func updateUserScore(user: User, score: Int) {
        user.topScore = score
        
        let recordToSave = CKRecord(user: user)
        let database = CloudKitController.sharedInstance.publicDB
        
        CloudKitController.sharedInstance.update(record: recordToSave, database: database) { (success) in
            if success {
                print("New high score updated successfully")
            } else {
                print("High score failed to update")
            }
        }
    }
    
//    func sortUserScores(userArray: [User]) {
//        userList.sort(by: { $0.topScore > $1.topScore })
//    }
    
}
