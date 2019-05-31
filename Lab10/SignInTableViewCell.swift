//
//  SignInTableViewCell.swift
//  Lab10
//
//  Created by Anton Sipaylo on 5/31/19.
//  Copyright © 2019 Anton Sipaylo. All rights reserved.
//

import UIKit

class SignInTableViewCell: UITableViewCell {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var notificationLabel: UILabel!
    
    let hotelsInfoSegueName = "HotelsInfoSegue"
    let invalidUserErrorText = "Invalid user data!"
    
    var navigationController: UINavigationController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        guard let userInfo = getUserInfo(),
            let password = Defaults.getUserInfoByEmail(email: userInfo.email),
            password.compare(userInfo.password) == .orderedSame else {
                setNotificationError(text: invalidUserErrorText)
                return
        }
        performSignIn()
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard let navigationController = navigationController, let viewController = navigationController.viewControllers.last as? ViewController else {
            return
        }
        viewController.changeUserMode()
    }
    
    
    func performSignIn() {
        guard let viewController = navigationController?.viewControllers.last as? ViewController else {
            return
        }
        viewController.performSegue(withIdentifier: hotelsInfoSegueName, sender: self)
    }
    
    func getUserInfo() -> (email: String, password: String)? {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return nil }
        return (email, password)
    }
    
    func setNotificationError(text: String) {
        notificationLabel.text = text
        showNotificationLabel()
    }
    
    func showNotificationLabel() {
        notificationLabel.isHidden = false
    }
    
    func hideNotificationLabel() {
        notificationLabel.isHidden = true
    }
}
