//
//  AppAccountModel.swift
//  PasswordManager
//
//  Created by Jenna Zing on 5/28/20.
//  Copyright © 2020 Vivienne Zing. All rights reserved.
//

import Foundation
import UIKit

class AppAccountModel {
    var regAppID: String
    
    var appName: String
    var email: String?
    var username: String?
    var password: String
    
    init(regAppID: String, appName: String, email: String?, username: String?, password: String) {
        self.regAppID = regAppID
        
        self.appName = appName
        self.email = email ?? ""
        self.username = username ?? ""
        self.password = password
    }
}
