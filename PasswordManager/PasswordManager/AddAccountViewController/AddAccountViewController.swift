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
        //let id = UUID().uuidString
        let id = "hello"
        
        // validation here: not empty, not nil
        let appName = appNameTextField.text!
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        KeychainWrapper.saveValue(appName, key: "\(appName).\(id)")
        KeychainWrapper.saveValue(username, key: "\(appName).\(id).username")
        KeychainWrapper.saveValue(password, key: "\(appName).\(id).password")
        // KeychainWrapper.saveValue(appName, key: "appName")
        // KeychainWrapper.saveValue(username, key: appName + ".username")
        // KeychainWrapper.saveValue(passwordTextField.text!, key: appName + ".password")
    }
    
    @IBAction func addButtonPress(_ sender: Any) {
        // appname.id.username -> save id into firebase
        // testUser1 - 123123
        // testUser2
        
        
        //saveInformation(appname: "demo", userName: "viv", password: "123123")
        //saveInformation(appname: "demo", userName: "zing", password: "321")
        //let id = "hello"
        let appName = appNameTextField.text!
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        self.delegate?.saveInformation(appname: appName, userName: username, password: password)
        //KeychainWrapper.saveValue(appName, key: "\(appName).\(id)")
        //KeychainWrapper.saveValue(username, key: "\(appName).\(id).username")
        //KeychainWrapper.saveValue(password, key: "\(appName).\(id).password")
        
        
        
        
        // casting view controller as registered accounts view controller
        // let registeredAccountController = UIStoryboard(name: "RegisteredAccountsView", bundle: nil).instantiateViewController(withIdentifier: "RegisteredAccountsViewController") as! RegisteredAccountsViewController
        
        //self.navigationController?.popViewController(animated: true)
        let alert = UIAlertController(title: "Congrats", message: "Successfully registered your account", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.dismiss(animated: true)
        }))
        
        self.delegate?.tableView.reloadData()
        //self.delegate?.viewDidLoad()
        self.present(alert, animated: true)
        
        
        // get navigation controller so can create a new flow of the app (login flow has finished)
        //let navigationController = UINavigationController(rootViewController: registeredAccountController)
        //navigationController.modalPresentationStyle = .fullScreen
    }
}
