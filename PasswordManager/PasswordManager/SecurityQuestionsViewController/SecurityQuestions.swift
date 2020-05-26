//
//  SecurityPrompt.swift
//  PasswordManager
//
//  Created by Evelyn Sjafii on 5/18/20.
//  Copyright © 2020 Vivienne Zing. All rights reserved.
//

import UIKit
import Foundation

class SecurityQuestionsViewController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitButtonPress(_ sender: Any) {
        // get entered answers  + check if answers are correct / valid
        
        // if answers entered are correct, use the following code:
        
        // casting view controller as registered accounts view controller
        let registeredAccountController = UIStoryboard(name: "RegisteredAccountsView", bundle: nil).instantiateViewController(withIdentifier: "RegisteredAccountsViewController") as! RegisteredAccountsViewController
        
        // get navigation controller so can create a new flow of the app (login flow has finished)
        let navigationController = UINavigationController(rootViewController: registeredAccountController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
}
