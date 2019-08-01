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
    
    // MARK: - CRUD
    
    // Create
    func createUserWith(username: String, email: String, password: String, completion: @escaping (User?) -> Void) {
        
        // Unwrap the optional cKReference or complete nil
        
    }
}
