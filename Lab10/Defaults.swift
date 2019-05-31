//
//  UserDefaults.swift
//  Lab10
//
//  Created by Anton Sipaylo on 5/31/19.
//  Copyright © 2019 Anton Sipaylo. All rights reserved.
//

import Foundation

class Defaults {
    static let usersInfoIdentifier = "UsersInfo"
    private init() { }
    
    static func saveUserInfo(email: String, password: String) -> Bool {
        guard var usersInfo = getUsersInfo() else {
            var info = [String: String]()
            info[email] = password
            UserDefaults.standard.set(info,
                                      forKey: usersInfoIdentifier)
            return true
        }
        if usersInfo[email] != nil {
            return false
        }
        usersInfo[email] = password
        UserDefaults.standard.set(usersInfo,
                                  forKey: usersInfoIdentifier)
        return true
    }
    
    static func getUsersInfo() -> [String: String]? {
        return UserDefaults.standard.value(forKey: usersInfoIdentifier) as? [String: String]
    }
    
    static func getUserInfoByEmail(email: String) -> String? {
        return getUsersInfo()?[email]
    }
}
