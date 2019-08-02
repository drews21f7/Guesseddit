//
//  SignInViewController.swift
//  Guesseddit
//
//  Created by Drew Seeholzer on 8/1/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    

    @IBOutlet weak var signUpUserTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserController.sharedInstance.fetchUserBool { (success) in
            if success {
                self.presentGameMenuView()
            }
        }


    }
    

    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let username = signUpUserTextField.text, !username.isEmpty
            else { return }
        
            UserController.sharedInstance.createUserWith(username: username, topScore: 0) { (user) in
                if user != nil {
                    UserController.sharedInstance.currentUser = user
                    self.presentGameMenuView()
                }
            }

    }
    @IBAction func skipLoginButtonTapped(_ sender: Any) {
        presentGameMenuView()
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
}
