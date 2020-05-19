import UIKit

class CreateNewAccount: UIViewController, UITableViewDelegate {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var answerOneTextField: UITextField!
  @IBOutlet weak var addQuestionButton: UIButton!
  @IBOutlet weak var createAccountButton: UIButton!
  @IBOutlet weak var passwordErrorLabel: UILabel!
  @IBOutlet weak var securityQuestionsErrorLabel: UILabel!

  // Additional security questions start at Question 2
  var questionCounter = 2
  var prevQuestionLabelPosX = 0
  var prevQuestionLabelPosY = 0
  var newQuestionLabelPosX = 0
  var newQuestionLabelPosY = 0

  var screenWidth = CGFloat(0)
  var screenHeight = CGFloat(0)

  override func viewDidLoad() {
    super.viewDidLoad()
    prevQuestionLabelPosX = Int(answerOneTextField.frame.minX) + 100
    prevQuestionLabelPosY = Int(answerOneTextField.center.y) + 50

    let screensize: CGRect = UIScreen.main.bounds
    screenWidth = screensize.width
    screenHeight = screensize.height
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
    questionTextField.layer.borderWidth = 1.0
    questionTextField.layer.borderColor = UIColor.lightGray.cgColor
    scrollView.addSubview(questionTextField)

    // Set up form for a new Answer
    let answerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    answerLabel.center = CGPoint(x: prevQuestionLabelPosX, y: prevQuestionLabelPosY + 80)
    answerLabel.textAlignment = .left
    answerLabel.text = "Answer " + String(questionCounter)
    scrollView.addSubview(answerLabel)

    let answerTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 375, height: 34))
    answerTextField.center = CGPoint(x: prevQuestionLabelPosX + 90, y: prevQuestionLabelPosY + 115)
    answerTextField.layer.borderWidth = 1.0
    answerTextField.layer.borderColor = UIColor.lightGray.cgColor
    scrollView.addSubview(answerTextField)

    // Move everything below the Security Questions down the screen
    addQuestionButton.center = CGPoint(x: Int(addQuestionButton.center.x), y: prevQuestionLabelPosY + 155)
    createAccountButton.center = CGPoint(x: Int(createAccountButton.center.x), y: prevQuestionLabelPosY + 220)
    securityQuestionsErrorLabel.center = CGPoint(x: Int(securityQuestionsErrorLabel.center.x), y: prevQuestionLabelPosY + 180)

    // Update variables and screen size
    questionCounter += 1
    prevQuestionLabelPosY += 160
    screenHeight += 170
    scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
  }
}
