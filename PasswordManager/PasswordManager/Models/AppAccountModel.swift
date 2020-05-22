//
//  AppAccountModel.swift
//  PasswordManager
//
//  Created by Vivienne Zing on 5/22/20.
//  Copyright © 2020 Vivienne Zing. All rights reserved.
//

import Foundation
import UIKit

class AppAccountModel {
    var appName: String
    // appImage?
    var username: String?
    var email: String?
    var password: String
    // var iOSunivLink: String
    
    init (appName: String, username: String?, email: String?, password: String) {
        self.appName = appName
        self.username = username
        self.email = email
        self.password = password
        // self.iOSunivLink = iOSunivLink
    }
    
    // init(id: String, data: NSDictionary)
    // may need this to force-cast data since we saved data
}
