//
//  ViewController.swift
//  Lab10
//
//  Created by Anton Sipaylo on 5/31/19.
//  Copyright © 2019 Anton Sipaylo. All rights reserved.
//

import UIKit

enum UserMode: Int {
    case signIn = 0
    case signUp = 1
    static func maxMode() -> Int {
        return 2
    }
    func getDescription() -> String {
        switch self {
        case .signIn:
            return "Sign in"
        case .signUp:
            return "Sign up"
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var userInfoTableView: UITableView!
    
    let cellAmount = 1
    let cellIdentifiers = [0: "SignInTableViewCell", 1: "SignUpTableViewCell"]
    let rowHeight = CGFloat(300)
    
    var userMode = UserMode(rawValue: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUserInfoTableView()
        if let userMode = userMode { setTitle(text: userMode.getDescription()) }
        print(Defaults.getUsersInfo() ?? "no users")
    }
    
    func setUpUserInfoTableView() {
        userInfoTableView.tableFooterView = UIView()
        userInfoTableView.rowHeight = rowHeight
        userInfoTableView.allowsSelection = false
    }

    func isValidUserInfo(email: String, password: String) -> Bool {
        return Defaults.saveUserInfo(email: email, password: password)
    }
    
    func changeUserMode() {
        self.userMode = UserMode(rawValue: ((self.userMode?.rawValue ?? 0) + 1) % UserMode.maxMode())
        if let userMode = userMode {
            userInfoTableView.reloadData()
            setTitle(text: userMode.getDescription())
        }
    }
    
    func setTitle(text: String) {
        self.title = text
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellAmount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userModeValue = userMode?.rawValue,
            let identifier = cellIdentifiers[userModeValue] else {
                return UITableViewCell()
        }
        if userModeValue == 0,
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? SignInTableViewCell {
            cell.navigationController = navigationController
            return cell
        } else if userModeValue == 1, let cell = tableView.dequeueReusableCell(withIdentifier:
            identifier, for: indexPath) as? SignUpTableViewCell {
            cell.navigationController = navigationController
            return cell
        }
        return UITableViewCell()
    }
}
