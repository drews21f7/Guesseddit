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
    
//    func fetchUserFromLogin(user: String, pass: String, completion: @escaping (User?) -> Void) {
//        // Unwrap the optional CKReference or complete nil
//        CloudKitController.sharedInstance.fetchAppleUserReference { (reference) in
//            guard let appleUserReference = reference else { completion(nil) ; return }
//
//            let predicate = NSPredicate(format: "appleUserReference == %@", appleUserReference)
//            let database = CloudKitController.sharedInstance.publicDB
//            CloudKitController.sharedInstance.fetchSingleRecord(ofType: UserConstants.typeKey, withPredicate: predicate, database: database, completion: { (records) in
//
//                guard let records = records,
//                    let record = records.first
//                    else { completion(nil) ; return }
//
//                let userRecord = User(record: record)
//                if user == userRecord?.username && pass == userRecord?.password {
//                    print("User and pass match")
//                    completion(userRecord)
//
//                }
//                print("User and pass did not match")
//                completion(nil)
//            })
//        }
//    }
    
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
            self.sortUserScores(userArray: users)
            self.userList = users
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
    
    func sortUserScores(userArray: [User]) {
        userList.sort(by: { $0.topScore > $1.topScore })
    }
        
}
