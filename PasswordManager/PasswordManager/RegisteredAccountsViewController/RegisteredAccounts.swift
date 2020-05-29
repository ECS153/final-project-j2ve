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
    // MARK:  TABLEVIEW DELEGATE & DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numRegAccs

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // NOTE: in storyboard, had to add a tableViewCell with the name of "account" so it would populate accordingly from this
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppAccountCell", for: indexPath)

        // retrieve correct document at that row
        let currRegAccDoc = self.masterAccRef.collection("AppAccountModel").document(regAccDocIDs[indexPath.row])

        // get contents of document
        self.masterAccRef.collection("AppAccountModel").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                var appAccCounter = 0
                
                var currRegAppID: String = ""
                var currRegAppName: String = ""
                var currRegAppEmail: String? = nil
                var currRegAppUsername: String? = nil
                var currRegAppPassword: String = ""
                
                for document in snapshot!.documents {
                   appAccCounter += 1
                    if appAccCounter == indexPath.row {
                        currRegAppID = document.documentID
                        currRegAppName = document.get("appName") as! String
                        currRegAppEmail = document.get("email") as? String
                        currRegAppUsername = document.get("username") as? String
                        currRegAppPassword = document.get("password") as! String
                        print(currRegAppID, currRegAppName, currRegAppEmail, currRegAppUsername, currRegAppPassword)
                    }
                }
                cell.textLabel?.text = "App Name: \(currRegAppName)"
                if let email = currRegAppEmail {
                    cell.detailTextLabel?.text = "email: \(email)"
                } else {
                    // value of currRegAppEmail is not set (or nil)
                    if let username = currRegAppUsername {
                        cell.detailTextLabel?.text = "username: \(username)"
                    } else {
                        // ERROR: one or the other should have been filled out.
                    }
                }
            }
        }
        return cell
    }

    
    /*
    // didSelectRowAt --> implement so when tableView cell is clicked, it will do the following: in this case, it goes to the screen AccountDetail
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // performSegue(withIdentifier: "showAccountDetail", sender: indexPath)
         // UNIVERSAL LINK HERE
    }
    
         // SENDING DATA TO AUTOFILL FIELDS?
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
    // END OF TABLEVIEW FUNCTIONS
    
    @IBOutlet weak var addAccountButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    // UITableView instantiation
    @IBOutlet weak var regAccsTableView: UITableView!
    
    let db = Firestore.firestore()
    var userID = ""
    
    // used to populate tableview of registered accounts
    var masterAccRef: DocumentReference
    var numRegAccs: Int
    var regAccDocIDs: [String] = []
    
    
    init() {
        self.numRegAccs = 0
        masterAccRef = db.collection("MasterAccountModel").document(userID)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveRegAccIDs()
        
        regAccsTableView.dataSource = self
        regAccsTableView.delegate = self
    }
    /*
    // https://stackoverflow.com/questions/52111685/how-retrieve-values-from-an-object-on-cloud-firestore-swift
    func retrieveRegAccs() {
        self.masterAccRef.collection("AppAccountModel").getDocuments { (snapshot, error) in
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            var appAccCounter = 0
            for document in snapshot!.documents {
               let regAppID = document.documentID
               let appName = document.get("appName") as! String
               let email = document.get("email") as! String
               let username = document.get("username") as! String
               let password = document.get("password") as! String
               print(regAppID, appName, email, username, password)
                
               appAccCounter += 1
            }
            
            let masterAccData = [
                "numRegAccounts": appAccCounter
            ]
            
            // update numRegAccounts in master account instance
            self.masterAccRef.setData(masterAccData, merge: true) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                print("Successfully updated numRegAccounts")
                self.numRegAccs = appAccCounter
            }
        }
        }
    }
    */
    
    // supplies regAccDocIDs from db
    func retrieveRegAccIDs() {
        self.masterAccRef.collection("AppAccountModel").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.regAccDocIDs.append("\(document.documentID)")
                    self.numRegAccs += 1
                }
            }
        }
    }
    
}
