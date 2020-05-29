//
//  MasterAccountModel.swift
//  PasswordManager
//
//  Created by Jenna Zing on 5/28/20.
//  Copyright © 2020 Vivienne Zing. All rights reserved.
//

import Foundation
import UIKit

class MasterAccountModel {
    var email: String
    var masterPassword: String
    var securityQandAs: [String: String]
    var regAccounts: [AppAccountModel]
    var numRegAccounts: Int
    
    init(email: String, masterPassword: String, securityQandAs: [String: String], regAccounts: [AppAccountModel]) {
        self.email = email
        self.masterPassword = masterPassword
        self.securityQandAs = securityQandAs
        self.regAccounts = regAccounts
        self.numRegAccounts = 0
    }
}
