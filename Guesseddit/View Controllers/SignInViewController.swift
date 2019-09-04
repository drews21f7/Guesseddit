//
//  SignInViewController.swift
//  Guesseddit
//
//  Created by Drew Seeholzer on 8/1/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import UIKit
import CloudKit

class SignInViewController: UIViewController, UITextFieldDelegate {

    

    @IBOutlet weak var signUpUserTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        checkForiCloudUser()
        signUpUserTextField.delegate = self
        let tapgesture = UITapGestureRecognizer()
        tapgesture.addTarget(self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapgesture)
        UserController.sharedInstance.fetchUserBool { (success) in
            if success {
                self.presentGameMenuView()
            }
        }


    }
    
    func checkForiCloudUser() {
        CKContainer.default().accountStatus { (status, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                switch status {
                case .available : print("available")
                case .restricted : print("restricted")
                case .noAccount :
                    DispatchQueue.main.async {
                        let alertController = UIAlertController (title: "Uh Oh!", message: "No iCloud Account Found! Please go to Settings and log in to your account.\n\n After logging in, please close the App before running again.", preferredStyle: .alert)
                        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                            guard let settingsUrl = URL(string: "App-Prefs:root=GENERAL") else {
                                return
                            }
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)")
                                })
                            }
                        }
                        alertController.addAction(settingsAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                case .couldNotDetermine : print("Account could not be determined")
                @unknown default:
                    fatalError()
                }
            }
        }
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        signUpUserTextField.resignFirstResponder()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let username = signUpUserTextField.text, !username.isEmpty
            else { return }
        
            UserController.sharedInstance.createUserWith(username: username, topScore: 0) { (user) in
                if user != nil {
                    UserController.sharedInstance.currentUser = user
                    self.presentGameMenuView()
                } else {
                    //self.resignFirstResponder()
                    self.invalidUserNameAlert()
                }
            }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SignInViewController {
    // Presents main menu
    func presentGameMenuView() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gameMenuViewController = storyboard.instantiateViewController(withIdentifier: "GameMenuNavVC")
            self.present(gameMenuViewController, animated: true)
        }
    }
    
    func invalidUserNameAlert() {
        let alertController = UIAlertController(title: "Invalid User name", message: "Make sure you're signed into your apple account on your phone and have a name entered", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok", style: .cancel)
        
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
        
    }
}
