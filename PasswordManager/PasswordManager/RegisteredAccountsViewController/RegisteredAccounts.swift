//
//  RegisteredAccounts.swift
//  PasswordManager
//
//  Created by Jenna Zing on 5/17/20.
//  Copyright © 2020 Vivienne Zing. All rights reserved.
//

import UIKit
import Foundation

class RegisteredAccountsViewController: UIViewController {
    
    @IBOutlet weak var addAccountButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addAccountButtonPress(_ sender: Any) {
        // segue over to add account screen
    }
    
    
    @IBAction func logoutButtonPress(_ sender: Any) {
        // go back to login screen
        
        // casting view controller as login view controller
        let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        // get navigation controller so can create a new flow of the app
        let navigationController = UINavigationController(rootViewController: loginController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
}
