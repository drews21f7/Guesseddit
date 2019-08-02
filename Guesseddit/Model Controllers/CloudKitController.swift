//
//  CloudKitController.swift
//  Guesseddit
//
//  Created by Drew Seeholzer on 8/1/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitController {
    
    static let sharedInstance = CloudKitController()
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: - CRUD
    
    //Create
    func save(record: CKRecord, database: CKDatabase, completion: @escaping (CKRecord?) -> Void) {
        // Save the record passed in, complete with an optional error
        database.save(record) { (record, error) in
            if let error = error {
                print ("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
            }
            print(#function)
            completion(record)
        }
    }
    
    // Read
    func fetchSingleRecord(ofType type: String, withPredicate predicate: NSPredicate, database: CKDatabase, completion: @escaping ([CKRecord]?) -> Void) {
        let query = CKQuery(recordType: type, predicate: predicate)
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print ("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let records = records else { completion(nil); return }
            completion(records)
        }
    }
    
    func fetchRecordsOf(type: String, predicate: NSPredicate, database: CKDatabase, completion: @escaping ([CKRecord]?, Error?) -> Void) {
        
        // Defines the record type you want to find, applies your predicate conditions
        let query = CKQuery(recordType: type, predicate: predicate)
        // Perform query, complete with your optional records and optional error
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print ("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil, error)
            }
            if let records = records {
                completion(records, nil)
            }
        }
    }
    
    func fetchAppleUserReference(completion: @escaping (CKRecord.Reference?) -> Void) {
        // Fetch the appleID user recordID
        CKContainer.default().fetchUserRecordID { (appleUserReferenceID, error) in
            if let error = error {
                print ("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            
            // Unwrap the retrieved recordID
            guard let recordID = appleUserReferenceID else { completion(nil) ; return }
            // Initialize a new CKReference using the recordID
            let appleUserReference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
            completion(appleUserReference)
        }
    }
    
    // Update
    func update(record: CKRecord, database: CKDatabase, completion: @escaping (Bool) -> Void) {
        // Declare your operation
        let operation = CKModifyRecordsOperation()
        // Override the operation attributes
        operation.recordsToSave = [record]
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .default
        operation.queuePriority = .normal
        operation.completionBlock = {
            completion(true)
        }
        // Need operation to edit a record
        database.add(operation)
    }
}
