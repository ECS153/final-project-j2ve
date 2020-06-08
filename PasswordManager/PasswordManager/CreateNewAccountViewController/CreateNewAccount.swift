//
//  CreateNewAccount.swift
//  PasswordManager
//
//  Created by Joanne Chang.
//

import UIKit
import Firebase

class CreateNewAccount: UIViewController, UITableViewDelegate, UITextFieldDelegate {

  @IBOutlet weak var scrollView: UIScrollView!

  // Outlets for Sign Up section
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var newPasswordTextField: UITextField!
  @IBOutlet weak var repeatPasswordTextField: UITextField!
  @IBOutlet weak var passwordErrorLabel: UILabel!

  // Outlets for Security Questions section
  @IBOutlet weak var questionOneLabel: UILabel!
  @IBOutlet weak var answerOneLabel: UILabel!
  @IBOutlet weak var questionOneTextField: UITextField!
  @IBOutlet weak var answerOneTextField: UITextField!
  @IBOutlet weak var addQuestionButton: UIButton!

  // Outlets for everything else
  @IBOutlet weak var createAccountButton: UIButton!
  @IBOutlet weak var securityQuestionsErrorLabel: UILabel!
    
  // for passing data to next screen
  var userID = ""

  // Additional security questions start at Question 2
  var questionCounter = 2
  var prevQuestionLabelPosX = 0
  var prevQuestionLabelPosY = 0

  var screenWidth = CGFloat(0)
  var screenHeight = CGFloat(0)

  // Form data
  var questionTextFields = [UITextField]()
  var answerTextFields = [UITextField]()
  var emptyTextFieldFound = false

  // Top anchor constraint for addQuestionButton
  var prevConstraint: NSLayoutConstraint? = nil

  // Limit of characters allowed for text fields
  // The max email length is 254 characters
  // And security questions over 254 characters are probably too long to be good questions
  let maxCharacters = 254

  override func viewDidLoad() {
    super.viewDidLoad()
    prevQuestionLabelPosX = Int(answerOneTextField.frame.minX) + 95
    prevQuestionLabelPosY = Int(answerOneTextField.center.y) + 35

    let screensize: CGRect = UIScreen.main.bounds
    screenWidth = screensize.width
    screenHeight = screensize.height
    prevConstraint = addQuestionButton.topAnchor.constraint(equalTo: answerOneTextField.bottomAnchor, constant: 20)
    prevConstraint!.isActive = true

    // Clear error messages when screen loads
    passwordErrorLabel.text = ""
    securityQuestionsErrorLabel.text = ""
    passwordErrorLabel.textAlignment = .center
    securityQuestionsErrorLabel.textAlignment = .center
    questionOneLabel.font = UIFont.italicSystemFont(ofSize: 16.0)
    answerOneLabel.font = .systemFont(ofSize: 16.0)

    emailTextField.delegate = self
    newPasswordTextField.delegate = self
    repeatPasswordTextField.delegate = self
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
      if(newLength <= maxCharacters){
        return true
      }
      else {
        return false
      }
  }

  @IBAction func validateEmail(_ sender: UITextField) {
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    if !emailPredicate.evaluate(with: emailTextField.text) {
      passwordErrorLabel.text = "Please enter a valid email address."
    }
    else {
      passwordErrorLabel.text = ""
    }
  }

  @IBAction func createPassword(_ sender: UITextField) {
    if newPasswordTextField.text!.count < 6 {
      passwordErrorLabel.text = "Password needs to be at least 6 characters."
    }
    else {
      passwordErrorLabel.text = ""
    }
  }

  @IBAction func repeatPassword(_ sender: UITextField) {
    if !newPasswordTextField.text!.isEmpty {
      if newPasswordTextField!.text != repeatPasswordTextField.text {
        passwordErrorLabel.text = "Passwords do not match. Please try again."
      }
      else {
        passwordErrorLabel.text = ""
      }
    }
  }

  @IBAction func addQuestion(_ sender: Any) {
    // Set up form for a new Question
    let questionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    questionLabel.center = CGPoint(x: prevQuestionLabelPosX + 7, y: prevQuestionLabelPosY)
    questionLabel.textAlignment = .left
    questionLabel.text = "Question " + String(questionCounter)
    questionLabel.font = UIFont.italicSystemFont(ofSize: 16.0)
    scrollView.addSubview(questionLabel)

    let questionTextField = UITextField(frame: CGRect(x: 0, y: 0, width: questionOneTextField.frame.size.width, height: questionOneTextField.frame.size.height))
    questionTextField.center = CGPoint(x: prevQuestionLabelPosX + 90, y: prevQuestionLabelPosY + 35)
    questionTextField.layer.cornerRadius = 5.0
    questionTextField.layer.borderWidth = 2.0
    questionTextField.layer.borderWidth = 1.0
    questionTextField.layer.borderColor = UIColor(white: 0.0, alpha: 0.21).cgColor
    questionTextField.placeholder = "Enter your question here"
    let paddingQuestionView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: questionTextField.frame.height))
    questionTextField.leftView = paddingQuestionView
    questionTextField.leftViewMode = UITextField.ViewMode.always
    questionTextField.font = .systemFont(ofSize: 14.0)
    questionTextField.clearButtonMode = .always
    scrollView.addSubview(questionTextField)

    // Set up form for a new Answer
    let answerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    answerLabel.center = CGPoint(x: prevQuestionLabelPosX + 7, y: prevQuestionLabelPosY + 75)
    answerLabel.textAlignment = .left
    answerLabel.text = "Answer"
    answerLabel.font = .systemFont(ofSize: 16.0)
    scrollView.addSubview(answerLabel)

    let answerTextField = UITextField(frame: CGRect(x: 0, y: 0, width: answerOneTextField.frame.size.width, height: answerOneTextField.frame.size.height))
    answerTextField.center = CGPoint(x: prevQuestionLabelPosX + 90, y: prevQuestionLabelPosY + 110)
    answerTextField.layer.cornerRadius = 5.0
    answerTextField.layer.borderWidth = 2.0
    answerTextField.layer.borderWidth = 1.0
    answerTextField.layer.borderColor = UIColor(white: 0.0, alpha: 0.21).cgColor
    answerTextField.placeholder = "Enter your answer here"
    let paddingAnswerView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: questionTextField.frame.height))
    answerTextField.leftView = paddingAnswerView
    answerTextField.leftViewMode = UITextField.ViewMode.always
    answerTextField.font = .systemFont(ofSize: 14.0)
    answerTextField.clearButtonMode = .always
    scrollView.addSubview(answerTextField)

    // Move everything below the Security Questions down the screen
    addQuestionButton.center = CGPoint(x: Int(addQuestionButton.center.x), y: prevQuestionLabelPosY + 155)
    createAccountButton.center = CGPoint(x: Int(createAccountButton.center.x), y: prevQuestionLabelPosY + 220)
    securityQuestionsErrorLabel.center = CGPoint(x: Int(securityQuestionsErrorLabel.center.x), y: prevQuestionLabelPosY + 180)

    // Update variables and screen size
    questionCounter += 1
    prevQuestionLabelPosY += 170
    screenHeight = createAccountButton.center.y + 50
    scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
    questionTextFields.append(questionTextField)
    answerTextFields.append(answerTextField)

    // Update constraint of addQuestionButton
    prevConstraint!.isActive = false
    prevConstraint = addQuestionButton.topAnchor.constraint(equalTo: answerTextField.bottomAnchor, constant: 20)
    prevConstraint!.isActive = true
  }

  @IBAction func createAccount(_ sender: Any) {
    if (questionCounter < 3) {
      securityQuestionsErrorLabel.text = "Please create at least 3 security questions."
    }
    else {
      // Check that all text fields have been filled in.
      for textField in questionTextFields {
        if textField.text!.isEmpty {
          emptyTextFieldFound = true
        }
      }
      for textField in answerTextFields {
        if textField.text!.isEmpty {
          emptyTextFieldFound = true
        }
      }
      if emailTextField.text!.isEmpty || newPasswordTextField.text!.isEmpty || repeatPasswordTextField.text!.isEmpty {
        emptyTextFieldFound = true
      }

      if emptyTextFieldFound {
        securityQuestionsErrorLabel.text = "Please fill in all fields."
        emptyTextFieldFound = false
      }
      else {
        securityQuestionsErrorLabel.text = ""
      }

      // If there are no more error messages, then segue to the Accounts screen
      if passwordErrorLabel.text!.isEmpty && securityQuestionsErrorLabel.text!.isEmpty {
        print("Success! You can create a new account.")

        handleSignUp()
        // Segue to Accounts Screen
        
        // casting view controller as registered accounts view controller
        let registeredAccountController = UIStoryboard(name: "RegisteredAccountsView", bundle: nil).instantiateViewController(withIdentifier: "RegisteredAccountsViewController") as! RegisteredAccountsViewController
        
        // get navigation controller so can create a new flow of the app (login flow has finished)
        let navigationController = UINavigationController(rootViewController: registeredAccountController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
      }
    }
  }

  func handleSignUp() {
    guard let email = emailTextField.text else { return }
    guard let pass = newPasswordTextField.text else { return }

    Auth.auth().createUser(withEmail: email, password: pass) { result, error in
      if error == nil && result != nil {
        print ("User created!")

        let db = Firestore.firestore()
        self.userID = result!.user.uid
        var questionNumber = "Q"

        // Create a new document about this new user and add it to the database.
        db.collection("MasterAccountModel").document(self.userID).setData([
          "Email": email,
          "MasterPassword": pass,
          "QandAs": [
            "Q1": [
              "Question": self.questionOneTextField.text,
              "Answer": self.answerOneTextField.text
            ]
          ]
        ]) { err in
          if let err = err {
            print("Error writing document: \(err)")
          } else {
            print("Document successfully written!")
          }
        }

        // Merge the remaining QandAs to the newly created document
        for i in 0...self.questionTextFields.count-1 {
          questionNumber.append(String(i+2))

            db.collection("MasterAccountModel").document(self.userID).setData([
            "QandAs": [
                questionNumber: [
                  "Question": self.questionTextFields[i].text,
                  "Answer": self.answerTextFields[i].text
                ]
            ]
          ], merge: true) { err in
            if let err = err {
              print("Error writing document: \(err)")
            } else {
              print("Document successfully written!")
            }
          }

          questionNumber = String(questionNumber.dropLast())
        }
      }
      else {
        print("Error creating user")
      }
    }
  }
   
    
  // for sending userID after creating account to next regAccounts screen
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
  }

}
