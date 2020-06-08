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
                        debugPrint("Other error", error!._code)
                }
                return
            }
            // User successfully signed in, segue to the security questions screen
            else {
                debugPrint("User successfully signed in!")
                // set global variable userUID
                userUID = result!.user.uid
                
                let db = Firestore.firestore()
                let docRef = db.collection("MasterAccountModel").document(userUID)
                
                docRef.getDocument { (document, error) in
                           // If there is an error, print error
                           if (error != nil) {
                               debugPrint(error?.localizedDescription)
                           }
                           
                           else if let document = document, document.exists {
                                debugPrint("Document exists for user")
                                // get user's recorded timestamp
                                let timestamp = document.data()!["Timestamp"] as? Timestamp
                                let timestampDate = timestamp!.dateValue()
                            
                                // get time difference between now and recorded timestamp in minutes
                                let timeDifference = (Int(Date().timeIntervalSince(timestampDate))) / 60
                                debugPrint("Time difference is", timeDifference)
                            
                            if (timeDifference >= 30) { // prompt security questions
                                debugPrint("prompt security")
                                let storyboard = UIStoryboard(name: "SecurityQuestions", bundle: nil)
                                let viewController = storyboard.instantiateViewController(withIdentifier: "SecurityQuestionsViewController") as! SecurityQuestionsViewController
                                
                                self.navigationController?.pushViewController(viewController, animated: true)
                            } else { // prompt accounts
                                debugPrint("prompt accounts")
                                let registeredAccountController = UIStoryboard(name: "RegisteredAccountsView", bundle: nil).instantiateViewController(withIdentifier: "RegisteredAccountsViewController") as! RegisteredAccountsViewController
                                
                                let navigationController = UINavigationController(rootViewController: registeredAccountController)
                                navigationController.modalPresentationStyle = .fullScreen
                                
                                self.present(navigationController, animated: true)
                            }
                           }
                           // If document does not exist, print
                           else {
                               debugPrint("Document does not exist for this user")
                           }
                       }
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
