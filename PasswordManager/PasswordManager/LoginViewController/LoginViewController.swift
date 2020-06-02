//
//  loginPage.swift
//  PasswordManager
//
//  Created by Evelyn Sjafii on 5/24/20.
//  Copyright © 2020 Vivienne Zing. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var masterEmailTextField: UITextField!
    @IBOutlet weak var masterPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // hide error message label upon loading
        errorMessage.alpha = 0
    }
    
    func showErrorMessage(_ message: String!) {
        errorMessage.text = message
        errorMessage.alpha = 1
    }
    
    func validateInput(_ masterEmail: String?,_ masterPassword: String?) -> String? {
        // Return error message if email or password is empty
        if masterEmail == "" {
            return "Please enter master email"
        }
        if masterPassword == "" {
            return "Please enter master password"
        }

        // Else return nil
        return nil
        
    }

    @IBAction func loginButtonPress(_ sender: Any) {
        // sanitize email and master password
        let masterEmail = masterEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let masterPassword = masterPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // validate inputs
        let error = validateInput(masterEmail, masterPassword)
        if error != nil {
            showErrorMessage(error)
            return
        }

        // sign user in
        Auth.auth().signIn(withEmail: masterEmail!, password: masterPassword!) { (result, error) in
            // If there is an error with signing user in, show error message
            if (error != nil) {
                let errCode = AuthErrorCode(rawValue: error!._code)
                switch errCode {
                    case .invalidEmail:
                        self.showErrorMessage("Please enter a valid email")
                    case .wrongPassword, .userNotFound:
                        self.showErrorMessage("Your account does not exist or password is invalid")
                    default:
                        debugPrint("Other error")
                }
                return
            }
            // User successfully signed in, segue to the security questions screen
            else {
                // set global variable userUID
                userUID = result!.user.uid
                
                DatabaseConnector.saveMasterPassword(password: masterPassword!)
                
                
                let storyboard = UIStoryboard(name: "SecurityQuestions", bundle: nil)
                
                // casting view controller as a registered accounts view controller
                // forced unwrapping (!):
                // using it here b/c we potentially want to set some variables on that object (navigation has to use downcast)
                // if it's not a registered accounts view controller, then what do you do?  Should just crash the app
                let viewController = storyboard.instantiateViewController(withIdentifier: "SecurityQuestionsViewController") as! SecurityQuestionsViewController
                
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func createAccountButtonPress(_ sender: Any) {
        // navigate to create new account screen
        let storyboard = UIStoryboard(name: "CreateNewAccount", bundle: nil)
        
        // cast view controller as a create new account view controller
        let viewController = storyboard.instantiateViewController(withIdentifier: "CreateNewAccID") as! CreateNewAccount
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
