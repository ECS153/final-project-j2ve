//
//  AddAccountViewController.swift
//  PasswordManager
//
//  Created by Vivienne Zing on 5/28/20.
//  Copyright © 2020 Vivienne Zing. All rights reserved.
//

import UIKit

class AddAccountViewController : UIViewController {
    weak var delegate: RegisteredAccountsViewController?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var appNameTextField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorMessage.text = ""
        
        addButton.addTarget(self, action: #selector(saveInformation), for: .touchUpInside)
    }
    
    @objc func saveInformation() {
        let id = UUID().uuidString
        
        // validation here: not empty, not nil
        let appName = appNameTextField.text!
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        KeychainWrapper.saveValue(appName, key: "\(appName).\(id)")
        KeychainWrapper.saveValue(username, key: "\(appName).\(id).username")
        KeychainWrapper.saveValue(password, key: "\(appName).\(id).password")
    }
    
    @IBAction func addButtonPress(_ sender: Any) {
        let appName = appNameTextField.text!
        let email = emailTextField.text!
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        
        // save account information into database
        //let acc = AppAccountModel(appName: "Facebook", email: "jen@test.com", username: "jenna", password: "123123")
        let acc = AppAccountModel(appName: appName, email: email, username: username, password: password)
        DatabaseConnector.saveNewAccount(account: acc)
        
        // appname.id.username -> save id into firebase
        // testUser1 - 123123
        // testUser2
        
        // save account information locally in keychain
        //self.delegate?.accounts.append(acc)
        self.delegate?.saveInformation(appname: appName, userName: username, password: password)
        
        
        let alert = UIAlertController(title: "Congrats", message: "Successfully registered your account", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.dismiss(animated: true)
        }))
        
        //self.delegate?.regAccsTableView.reloadData()
        self.delegate?.getData()
        self.present(alert, animated: true)
        
    }
}
