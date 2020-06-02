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
    var accountId: String
    
    var appName: String
    var email: String?
    var username: String?
    var password: String
    
    init(appName: String, email: String?, username: String?, password: String) {
        self.accountId = UUID().uuidString
        self.appName = appName
        self.email = email
        self.username = username
        self.password = password
    }
    
    init?(raw: [String: Any]) {
        // set a default value for accountid -> nil -> set ""
        //let accountId = raw["accountId"] as? String ?? ""
        
        // if it's nil -> it's invalid ->return a nil object -> thats data from db is not valid to use
        guard let accountId = raw["accountId"] as? String else { return nil }
        self.accountId = accountId
        
        guard let appName = raw["appName"] as? String  else { return nil }
        guard let password = raw["password"] as? String  else { return nil }
        self.appName = appName
        self.password = password
        
        self.email = raw["email"] as? String
        self.username = raw["username"] as? String
    }
}
