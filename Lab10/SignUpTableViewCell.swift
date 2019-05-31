//
//  SignUpTableViewCell.swift
//  Lab10
//
//  Created by Anton Sipaylo on 5/31/19.
//  Copyright © 2019 Anton Sipaylo. All rights reserved.
//

import UIKit

class SignUpTableViewCell: UITableViewCell {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var notificationLabel: UILabel!
    
    let unexpectedErrorText = "Someting went wrong!"
    let invalidDataErrorText = "Invalid user data!"
    let existanceOfSameUserErrorText = "The user with this email was registered!"
    let successfullRegistrationMessage = "You are successfully registered!"
    
    var navigationController: UINavigationController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard let navigationController = navigationController,
            let viewController = navigationController.viewControllers.last as? ViewController,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let repeatedPassword = repeatPasswordTextField.text,
            !email.isEmpty,
            !password.isEmpty,
            !repeatedPassword.isEmpty else {
                setNotificationError(text: unexpectedErrorText)
                return
        }
        guard let userInfo = getUserInfo() else {
            setNotificationError(text: invalidDataErrorText)
            return
            
        }
        if !viewController.isValidUserInfo(email: userInfo.email,
                                           password: userInfo.password) {
            setNotificationError(text: existanceOfSameUserErrorText)
        }
        performSignUp(email: email, password: password)
    }
    
    func performSignUp(email: String, password: String) {
        setNotificationError(text: successfullRegistrationMessage)
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        guard let navigationController = navigationController,
            let viewController = navigationController.viewControllers.last as? ViewController else { return
        }
        viewController.changeUserMode()
    }
    
    
    
    func getUserInfo() -> (email: String, password: String)? {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let repeatPassword = repeatPasswordTextField.text, password.compare(repeatPassword) == .orderedSame else {
            return nil
        }
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
