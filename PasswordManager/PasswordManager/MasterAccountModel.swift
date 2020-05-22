//
//  MasterAccountModel.swift
//  PasswordManager
//
//  Created by Vivienne Zing on 5/22/20.
//  Copyright © 2020 Vivienne Zing. All rights reserved.
//

import Foundation
import UIKit

class MasterAccountModel {
    var email: String
    var mastPassword: String
    var questions: [String?]
    var answers: [String?]
    var regAppAccounts: [String?]
    
    init (email: String, mastPassword: String, questions: [String?], answers: [String?], regAppAccounts: [String?]) {
        self.email = email
        self.mastPassword = mastPassword
        self.questions = questions
        self.answers = answers
        self.regAppAccounts = regAppAccounts
    }
}
