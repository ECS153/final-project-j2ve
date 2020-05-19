import UIKit

class CreateNewAccount: UIViewController, UITableViewDelegate {

  @IBOutlet weak var answerOneTextField: UITextField!

  // Additional security questions start at Question 2
  var questionCounter = 2
  var prevQuestionLabelPosX = 0
  var prevQuestionLabelPosY = 0
  var newQuestionLabelPosX = 0
  var newQuestionLabelPosY = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    prevQuestionLabelPosX = Int(answerOneTextField.frame.minX) + 100
    prevQuestionLabelPosY = Int(answerOneTextField.center.y) + 50
  }

  @IBAction func addQuestion(_ sender: Any) {
    // Set up form for a new Question
    let questionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    questionLabel.center = CGPoint(x: prevQuestionLabelPosX, y: prevQuestionLabelPosY)
    questionLabel.textAlignment = .left
    questionLabel.text = "Question " + String(questionCounter)
    self.view.addSubview(questionLabel)

    let questionTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 375, height: 34))
    questionTextField.center = CGPoint(x: prevQuestionLabelPosX + 90, y: prevQuestionLabelPosY + 35)
    questionTextField.layer.borderWidth = 1.0
    questionTextField.layer.borderColor = UIColor.lightGray.cgColor
    self.view.addSubview(questionTextField)

    // Set up form for a new Answer
    let answerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    answerLabel.center = CGPoint(x: prevQuestionLabelPosX, y: prevQuestionLabelPosY + 80)
    answerLabel.textAlignment = .left
    answerLabel.text = "Answer " + String(questionCounter)
    self.view.addSubview(answerLabel)

    let answerTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 375, height: 34))
    answerTextField.center = CGPoint(x: prevQuestionLabelPosX + 90, y: prevQuestionLabelPosY + 115)
    answerTextField.layer.borderWidth = 1.0
    answerTextField.layer.borderColor = UIColor.lightGray.cgColor
    self.view.addSubview(answerTextField)

    questionCounter += 1
    prevQuestionLabelPosY += 160
  }

}
