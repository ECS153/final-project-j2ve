//
//  AddRegisteredAccountViewController.swift
//  PasswordManager
//
//  Created by Evelyn Sjafii on 5/28/20.
//  Copyright © 2020 Vivienne Zing. All rights reserved.
//

import UIKit

class AddRegisteredAccountViewController: UIViewController {

    @IBOutlet weak var emailErrorMessage: UILabel!
    @IBOutlet weak var passwordErrorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Hide the error labels
        hideErrorMessages()
    }
    
    func hideErrorMessages() {
        emailErrorMessage.alpha = 0
        passwordErrorMessage.alpha = 0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addButtonTapped(_ sender: Any) {
        // TODO: Sanitize and validate input (no empty fields)
        
        // TODO: Send data to Firebase
                
        // TODO: Navigate back to the Registered Accounts List Page
    }
    
}
