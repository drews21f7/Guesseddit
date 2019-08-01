//
//  SignInViewController.swift
//  Guesseddit
//
//  Created by Drew Seeholzer on 8/1/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    
    @IBOutlet weak var logInUserTextField: UITextField!
    @IBOutlet weak var logInPassTextField: UITextField!
    
    @IBOutlet weak var signUpUserTextField: UITextField!
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpPassTextField: UITextField!
    @IBOutlet weak var signUpConfirmPassTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserController.sharedInstance.fetchUserBool { (success) in
            if success {
                self.presentGameMenuView()
            }
        }


    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = logInUserTextField.text, !username.isEmpty,
        let password = logInPassTextField.text, !password.isEmpty
            else { return }
        UserController.sharedInstance.fetchUserFromLogin(user: username, pass: password) { (user) in
            if user != nil {
                UserController.sharedInstance.currentUser = user
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let username = signUpUserTextField.text, !username.isEmpty,
        let email = signUpEmailTextField.text,
        let password = signUpPassTextField.text, !password.isEmpty,
        let confirm = signUpConfirmPassTextField.text, !confirm.isEmpty
            else { return }
        
        if password == confirm {
            
            UserController.sharedInstance.createUserWith(username: username, email: email, password: password, topScore: 0) { (user) in
                if user != nil {
                    UserController.sharedInstance.currentUser = user
                    self.presentGameMenuView()
                }
            }
        } else {
            let alertcontroller = UIAlertController.init(title: "Passwords don't match", message: "Please re-type your password", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "Ok", style: .cancel)
            alertcontroller.addAction(ok)
            present(alertcontroller, animated: true)
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
