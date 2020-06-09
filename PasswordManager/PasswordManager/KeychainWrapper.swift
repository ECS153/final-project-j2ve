//
//  KeychainWrapper.swift
//  PasswordManager
//
//  Created by Vivienne Zing on 5/28/20.
//  Copyright © 2020 Vivienne Zing. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainWrapper {
    // When Keychainwrapper => all other screens interact with KW
    // if you change KeychainAccess gto other lib, you dont have change in other screens, just change here.
    static let keychain = Keychain(service: "edu.ucdavis.cs.PasswordManager")
    static func saveValue(_ text: String, key: String) {
        try? keychain.set(text, key: key)
    }
    
    static func getValue(key: String) -> String? {
        try? keychain.get(key)
    }
}
