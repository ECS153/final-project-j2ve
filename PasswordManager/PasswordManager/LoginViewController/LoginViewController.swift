//
//  loginPage.swift
//  PasswordManager
//
//  Created by Evelyn Sjafii on 5/24/20.
//  Copyright © 2020 Vivienne Zing. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func LoginButtonPress(_ sender: Any) {
        // get entered password info + check if password is correct / valid
        
        
        // if password entered is correct, use the following code:
        
        // navigate (segue over) to the registered accounts screen
        let storyboard = UIStoryboard(name: "SecurityQuestionsViewController", bundle: nil)
        
        // casting view controller as a registered accounts view controller
        // forced unwrapping (!):
        // using it here b/c we potentially want to set some variables on that object (navigation has to use downcast)
        // if it's not a registered accounts view controller, then what do you do?  Should just crash the app
        let viewController = storyboard.instantiateViewController(withIdentifier: "SecurityQuestionsViewController") as! SecurityQuestionsViewController
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func CreateAccountButtonPress(_ sender: Any) {
        // navigate to create new account screen
        let storyboard = UIStoryboard(name: "CreateNewAccount", bundle: nil)
        
        // cast view controller as a create new account view controller
        let viewController = storyboard.instantiateViewController(withIdentifier: "CreateNewAccID") as! CreateNewAccount
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
