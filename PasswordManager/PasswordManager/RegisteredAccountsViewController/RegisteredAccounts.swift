//
//  RegisteredAccounts.swift
//  PasswordManager
//
//  Created by Jenna Zing on 5/17/20.
//  Copyright © 2020 Vivienne Zing. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class RegisteredAccountsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var accounts = [AppAccountModel]()
    
    // MARK:  TABLEVIEW DELEGATE & DATASOURCE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // NOTE: in storyboard, had to add a tableViewCell with the name of "account" so it would populate accordingly from this
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppAccountCell", for: indexPath)
        let account = accounts[indexPath.row]
        cell.textLabel?.text = account.appName
        cell.detailTextLabel?.text = account.email ?? account.username

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let account = accounts[indexPath.row]
        
    }
    
    @IBOutlet weak var addAccountButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var regAccsTableView: UITableView!
    
    // add new init function -> required init is asked.
    // dont have any init function -> it uses the default ones (3 func)
    //
    // call user profile api
    // -> pass userId
    // 1. call api viewDidLoad -> dont need an init func
    // 2 call right after define screen -> add new init (init(userId: Int))
    
    @IBAction func addAccountButtonPress(_ sender: UIButton) {
        let acc = AppAccountModel(appName: "Facebook", email: "jen@test.com", username: "jenna", password: "123123")
        DatabaseConnector.saveNewAccount(account: acc)
        
        let acc1 = AppAccountModel(appName: "Instagram", email: "jenInstagram@test.com", username: "jennainstagram", password: "321321")
        DatabaseConnector.saveNewAccount(account: acc1)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regAccsTableView.dataSource = self
        regAccsTableView.delegate = self
        getData()
    }
    
    func getData() {
        DatabaseConnector.getAccounts { (accounts, error) in
            if let err = error {
                // show error message here
                return
            }
            
            self.accounts = accounts
            self.regAccsTableView.reloadData()
        }
    }
   
    
}


class DatabaseConnector {
    static func saveMasterPassword(password: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let email = Auth.auth().currentUser?.email else { return }
        let data = [
            "email": email,
            "masterPassword": password
        ]
        Firestore.firestore()
            .collection("MasterAccountModel")
            .document(userId)
            .setData(data, merge: true)
    }
    static func saveNewAccount(account: AppAccountModel) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        
        let data = [
            "accountId": account.accountId,
            "appName": account.appName,
            "email": account.email,
            "username": account.username,
            "password": account.password,
        ]
        Firestore.firestore()
            .collection("MasterAccountModel")
            .document(userId)
            .collection("AppAccountModel")
            .document(account.accountId)
            .setData(data, merge: true)
    }
    static func getAccounts(completion: @escaping([AppAccountModel], Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore()
        .collection("MasterAccountModel")
        .document(userId)
            .collection("AppAccountModel").getDocuments { (snapshot, err) in
                if err != nil {
                    completion([], err)
                    return
                }
                guard let snapshotValue = snapshot?.documents else {
                    completion([], nil)
                    return
                }
                let rawAccounts = snapshotValue.map({ return $0.data() })
                // rawAccounts -> 10 accounts (2 invalid)
                // -> show 8 valid accounts
                var accounts = [AppAccountModel]()
                for item in rawAccounts {
                    let acc = AppAccountModel(raw: item)
                    if acc != nil {
                        accounts.append(acc!)
                    }
                }
                
                //var accounts2 = rawAccounts.compactMap({ return AppAccountModel(raw: $0) })
                
                completion(accounts, nil)
        }
    }
    
    
}




/*
 Save master passwrod in db -> easier to break -> you hav eto encrypt -> complicated
 
 
 Master account ID -> firebase to you -> you login
 AppAccountModel ID -> you to your facebook/instagram//..... -> update passwrod, remove account
 
 
-Suggestions
 - Login once, next login, dont ask questions again (10 mins)
 - Remember email (after first successful login / logout)
 -  randomize the questions
 
 */
