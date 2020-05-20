//
//  CreateNewAccount.swift
//  PasswordManager
//
//  Created by Joanne Chang.
//

import UIKit

class CreateNewAccount: UIViewController, UITableViewDelegate {

  @IBOutlet weak var scrollView: UIScrollView!

  // Outlets for Sign Up section
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var newPasswordTextField: UITextField!
  @IBOutlet weak var repeatPasswordTextField: UITextField!
  @IBOutlet weak var passwordErrorLabel: UILabel!

  // Outlets for Security Questions section
  @IBOutlet weak var questionOneTextField: UITextField!
  @IBOutlet weak var answerOneTextField: UITextField!
  @IBOutlet weak var addQuestionButton: UIButton!

  // Outlets for everything else
  @IBOutlet weak var createAccountButton: UIButton!
  @IBOutlet weak var securityQuestionsErrorLabel: UILabel!

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

  override func viewDidLoad() {
    super.viewDidLoad()
    prevQuestionLabelPosX = Int(answerOneTextField.frame.minX) + 100
    prevQuestionLabelPosY = Int(answerOneTextField.center.y) + 50

    let screensize: CGRect = UIScreen.main.bounds
    screenWidth = screensize.width
    screenHeight = screensize.height

    // Clear error messages when screen loads
    passwordErrorLabel.text = ""
    securityQuestionsErrorLabel.text = ""
    passwordErrorLabel.textAlignment = .center;
    securityQuestionsErrorLabel.textAlignment = .center;
  }

  @IBAction func valiateEmail(_ sender: UITextField) {
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    if !emailPredicate.evaluate(with: emailTextField.text) {
      passwordErrorLabel.text = "Please enter a valid email address."
    }
    else {
      passwordErrorLabel.text = ""
    }
  }

  @IBAction func createPassword(_ sender: Any) {
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
    questionLabel.center = CGPoint(x: prevQuestionLabelPosX, y: prevQuestionLabelPosY)
    questionLabel.textAlignment = .left
    questionLabel.text = "Question " + String(questionCounter)
    scrollView.addSubview(questionLabel)

    let questionTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 375, height: 34))
    questionTextField.center = CGPoint(x: prevQuestionLabelPosX + 90, y: prevQuestionLabelPosY + 35)
    questionTextField.layer.cornerRadius = 5.0
    questionTextField.layer.borderWidth = 2.0
    questionTextField.layer.borderWidth = 1.0
    questionTextField.layer.borderColor = UIColor.lightGray.cgColor
    questionTextField.placeholder = "Enter your question here"
    let paddingQuestionView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: questionTextField.frame.height))
    questionTextField.leftView = paddingQuestionView
    questionTextField.leftViewMode = UITextField.ViewMode.always
    questionTextField.font = .systemFont(ofSize: 14)
    questionTextField.clearButtonMode = .always
    scrollView.addSubview(questionTextField)

    // Set up form for a new Answer
    let answerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    answerLabel.center = CGPoint(x: prevQuestionLabelPosX, y: prevQuestionLabelPosY + 80)
    answerLabel.textAlignment = .left
    answerLabel.text = "Answer"
    scrollView.addSubview(answerLabel)

    let answerTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 375, height: 34))
    answerTextField.center = CGPoint(x: prevQuestionLabelPosX + 90, y: prevQuestionLabelPosY + 115)
    answerTextField.layer.cornerRadius = 5.0
    answerTextField.layer.borderWidth = 2.0
    answerTextField.layer.borderWidth = 1.0
    answerTextField.layer.borderColor = UIColor.lightGray.cgColor
    answerTextField.placeholder = "Enter your answer here"
    let paddingAnswerView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: questionTextField.frame.height))
    answerTextField.leftView = paddingAnswerView
    answerTextField.leftViewMode = UITextField.ViewMode.always
    answerTextField.font = .systemFont(ofSize: 14)
    answerTextField.clearButtonMode = .always
    scrollView.addSubview(answerTextField)

    // Move everything below the Security Questions down the screen
    addQuestionButton.center = CGPoint(x: Int(addQuestionButton.center.x), y: prevQuestionLabelPosY + 155)
    createAccountButton.center = CGPoint(x: Int(createAccountButton.center.x), y: prevQuestionLabelPosY + 220)
    securityQuestionsErrorLabel.center = CGPoint(x: Int(securityQuestionsErrorLabel.center.x), y: prevQuestionLabelPosY + 180)
    // TODO: Programmatically update contraints for these 3 objects
    addQuestionButton.topAnchor.constraint(equalTo: answerTextField.bottomAnchor)

    // Update variables and screen size
    questionCounter += 1
    prevQuestionLabelPosY += 160
    screenHeight = createAccountButton.center.y + 50
    scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
    questionTextFields.append(questionTextField)
    answerTextFields.append(answerTextField)
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

      // TODO: If there are no more error messages, then segue to the Accounts screen.
      if passwordErrorLabel.text!.isEmpty && securityQuestionsErrorLabel.text!.isEmpty {
        print("Success! You can create a new account.")
      }
    }
  }
}
