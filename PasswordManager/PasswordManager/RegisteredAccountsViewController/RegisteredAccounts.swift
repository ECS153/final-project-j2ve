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

class RegisteredAccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addAccountButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var regAccsTableview: UITableView!
    
    let db = Firestore.firestore()
    
    var masterAccRef: CollectionReference!
    var regAccsRef: CollectionReference!
    var docRef: DocumentReference!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        masterAccRef = db.collection("MasterAccountModel")
        regAccsRef = db.collection("MasterAccountModel/")
        docRef = db.document("MasterAccountModel/69tCAKxPE9hcn0qz46YZKksKFin2")
        
        regAccsTableview.dataSource = self
        regAccsTableview.delegate = self
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
    
    // MARK:  TABLEVIEW DELEGATE & DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numAccounts;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // NOTE: in storyboard, had to add a tableViewCell with the name of "account" so it would populate accordingly from this
        let cell = tableView.dequeueReusableCell(withIdentifier: "account", for: indexPath)
        
        if let wallet = userWallet {
            let balanceString = String(format:"balance: $%.2f", wallet.accounts[indexPath.row].amount)
            // let cellString = String(" \(wallet.accounts[indexPath.row].name) \(balanceString)")
            let cellString = String(" \(wallet.accounts[indexPath.row].name)")
            cell.textLabel?.text = cellString
            cell.detailTextLabel?.text = balanceString
        }
        return cell
    }
    /*
    // didSelectRowAt --> implement so when tableView cell is clicked, it will do the following: in this case, it goes to the screen AccountDetail
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showAccountDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAccountDetail" {
            if let index = (sender as? IndexPath)?.row {
                let controller = segue.destination as! AccountDetailController
                controller.wallet = userWallet
                controller.accountIndex = index
            }
        }

        if segue.identifier == "showAddAccountController" {
            let controller = segue.destination as! AddAccountController
            controller.wallet = userWallet
        }
    }
 */
    
}
