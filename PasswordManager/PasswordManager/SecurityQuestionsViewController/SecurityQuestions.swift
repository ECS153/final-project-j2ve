//
//  SecurityPrompt.swift
//  PasswordManager
//
//  Created by Evelyn Sjafii on 5/18/20.
//  Copyright © 2020 Vivienne Zing. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class SecurityQuestionsViewController: UIViewController {
        
    @IBOutlet weak var firstSecurityQuestion: UILabel!
    @IBOutlet weak var firstSecurityQuestionAnswer: UITextField!
    @IBOutlet weak var secondSecurityQuestion: UILabel!
    @IBOutlet weak var secondSecurityQuestionAnswer: UITextField!
    @IBOutlet weak var thirdSecurityQuestion: UILabel!
    @IBOutlet weak var thirdSecurityQuestionAnswer: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // fetch questions from firestore
        fetchSecurityQuestions()
    }
    
    func chooseRandomQuestion(_ questionsList: [String: String],_ chosenQuestions: [String]) -> String? {
        while true {
            let random = questionsList.randomElement()
            let question = random?.key
            // If the question has not been chosen yet, use the question
            if (!chosenQuestions.contains(question!)) {
                return question
            }
        }
        return nil
    }
    
    func fetchSecurityQuestions() {
        let uid = Auth.auth().currentUser?.uid // uid of current user
        let db = Firestore.firestore()
        let docRef = db.collection("MasterAccountModel").document(uid!)

        docRef.getDocument { (document, error) in
            // If there is an error, print error
            if (error != nil) {
                debugPrint(error?.localizedDescription)
            }
            
            // If document exists, get the security questions
            else if let document = document, document.exists {
                let securityQuestionsData = document.data()!["QandAs"] as? [String: Any] ?? nil
                
                // put questions in an array
                var securityQuestions = [String:String]()
                var chosenQuestions = [String]()
                for i in securityQuestionsData! {
                    let pair = i.value as? [String: String] ?? nil
                    securityQuestions[(pair?["Question"])!] = pair?["Answer"]
                }
                
                // Set first question
                let firstQuestion = self.chooseRandomQuestion(securityQuestions, chosenQuestions)
                chosenQuestions.append(firstQuestion!)
                self.firstSecurityQuestion.text = firstQuestion

                // Set second question
                let secondQuestion = self.chooseRandomQuestion(securityQuestions, chosenQuestions)
                chosenQuestions.append(secondQuestion!)
                self.secondSecurityQuestion.text = secondQuestion
                                
                // Set third question
                let thirdQuestion = self.chooseRandomQuestion(securityQuestions, chosenQuestions)
                chosenQuestions.append(thirdQuestion!)
                self.thirdSecurityQuestion.text = thirdQuestion
                                
            }
            // If document does not exist, print
            else {
                debugPrint("Document does not exist for this user")
            }
        }
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
