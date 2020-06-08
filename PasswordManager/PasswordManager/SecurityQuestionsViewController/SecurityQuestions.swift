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
    @IBOutlet weak var firstErrorMessage: UILabel!
    @IBOutlet weak var secondSecurityQuestion: UILabel!
    @IBOutlet weak var secondSecurityQuestionAnswer: UITextField!
    @IBOutlet weak var secondErrorMessage: UILabel!
    @IBOutlet weak var thirdSecurityQuestion: UILabel!
    @IBOutlet weak var thirdSecurityQuestionAnswer: UITextField!
    @IBOutlet weak var thirdErrorMessage: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    // variable for all extracted security questions from firebase
    var securityQuestions = [String:String]()
    var questionChooser = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial view setup
        initialSetup()
        // fetch questions from firestore
        fetchSecurityQuestions()
    }
    
    func initialSetup() {
        // hide error labels
        firstErrorMessage.alpha = 0
        secondErrorMessage.alpha = 0
        thirdErrorMessage.alpha = 0
    }
    
    // infinity loop
//    func chooseRandomQuestion(_ questionsList: [String: String],_ chosenQuestions: [String]) -> String? {
//        while true {
//            let random = questionsList.randomElement()
//            let question = random?.key
//            // If the question has not been chosen yet, use the question
//            if (!chosenQuestions.contains(question!)) {
//                return question
//            }
//        }
//    }
    
    func chooseRandomQuestion() -> String? {
        guard let q = questionChooser.randomElement() else { return nil }
        // return q1
        // remove q1 => [q2, q3]
        // return q3
        // remove q3 => [q2]
        // return q2
        // remove q2 => []
        let question = q.key
        questionChooser[q.key] = nil
        return question
    }
    
    func fetchSecurityQuestions() {
        let db = Firestore.firestore()
        // userUID: global variable in UserInformation.swift that contains the UID
        let docRef = db.collection("MasterAccountModel").document(userUID)

        docRef.getDocument { (document, error) in
            // If there is an error, print error
            if (error != nil) {
                debugPrint(error?.localizedDescription)
            }
            
            // If document exists, get the security questions
            else if let document = document, document.exists {
                let securityQuestionsData = document.data()!["QandAs"] as? [String: Any] ?? nil
                
                // put questions in an array
                var chosenQuestions = [String]()
                for i in securityQuestionsData! {
                    let pair = i.value as? [String: String] ?? nil
                    self.securityQuestions[(pair?["Question"])!] = pair?["Answer"]
                    /*
                     {
                        test: test,
                        Test: A of 3
                     
                     }
                     
                     */
                }
                self.questionChooser = self.securityQuestions
                
                // Set first question
                if let firstQuestion = self.chooseRandomQuestion() {
                    chosenQuestions.append(firstQuestion)
                    self.firstSecurityQuestion.text = firstQuestion
                }
                
                // Set second question
                if let secondQuestion = self.chooseRandomQuestion() {
                    chosenQuestions.append(secondQuestion)
                    self.secondSecurityQuestion.text = secondQuestion
                }
                // Set third question
                if let thirdQuestion = self.chooseRandomQuestion() {
                    chosenQuestions.append(thirdQuestion)
                    self.thirdSecurityQuestion.text = thirdQuestion
                }
                
            }
            // If document does not exist, print
            else {
                debugPrint("Document does not exist for this user")
            }
        }
    }
    
    func validateAnswer(_ question: String!,_ answer: String?) -> String? {
        // check if fields are empty
        if (answer == "") {
            return "Please enter an answer"
        }
        // check if answers are correct
        if (securityQuestions[question] != answer) {
            return "Incorrect answer"
        }
        return nil
    }
    
    func showErrorMessage(_ variable: UILabel!, _ message: String!) {
        variable.text = message
        variable.alpha = 1
    }
    
    @IBAction func submitButtonPress(_ sender: Any) {
        // sanitize and validate answers
        let firstAnswer = (firstSecurityQuestionAnswer.text?.trimmingCharacters(in: .newlines))!
        let firstError = validateAnswer(firstSecurityQuestion.text!, firstAnswer)
        if (firstError != nil) {
            showErrorMessage(firstErrorMessage, firstError)
        }
        else {
            firstErrorMessage.alpha = 0
        }
        
        let secondAnswer = secondSecurityQuestionAnswer.text?.trimmingCharacters(in: .newlines)
        let secondError = validateAnswer(secondSecurityQuestion.text!, secondAnswer)
        if (secondError != nil) {
            showErrorMessage(secondErrorMessage, secondError)
        }
        else {
            secondErrorMessage.alpha = 0
        }
        
        let thirdAnswer = thirdSecurityQuestionAnswer.text?.trimmingCharacters(in: .newlines)
        let thirdError = validateAnswer(thirdSecurityQuestion.text!, thirdAnswer)
        if (thirdError != nil) {
            showErrorMessage(thirdErrorMessage, thirdError)
        }
        else {
            thirdErrorMessage.alpha = 0
        }
                
        // casting view controller as registered accounts view controller
        let registeredAccountController = UIStoryboard(name: "RegisteredAccountsView", bundle: nil).instantiateViewController(withIdentifier: "RegisteredAccountsViewController") as! RegisteredAccountsViewController
        
        // get navigation controller so can create a new flow of the app (login flow has finished)
        let navigationController = UINavigationController(rootViewController: registeredAccountController)
        navigationController.modalPresentationStyle = .fullScreen
        
        // If the answers are correct, navigate to Registered Accounts Screen
        if (firstError == nil && secondError == nil && thirdError == nil) {
            self.present(navigationController, animated: true)
        }
    }
}
