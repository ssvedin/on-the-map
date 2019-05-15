//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sabrina on 3/23/19.
//  Copyright © 2019 Sabrina Svedin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: Outlets and Properties
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let signUpUrl = URL(string: Constants.Udacity.udacitySignUpURL)!
    
    var emailFieldIsEmpty = true
    var passwordFieldIsEmpty = true
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.text = ""
        passwordField.text = ""
        emailField.delegate = self
        passwordField.delegate = self
        buttonEnabled(false, button: loginButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailField.text = ""
        passwordField.text = ""
    }
    
    // MARK: Log In
    
    @IBAction func login(_ sender: UIButton) {
        setLoggingIn(true)
        UdacityClient.login(email: self.emailField.text ?? "", password: self.passwordField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    // MARK: Sign Up
    
    @IBAction func signUp(_ sender: Any) {
        setLoggingIn(true)
        UIApplication.shared.open(signUpUrl, options: [:], completionHandler: nil)
    }
    
    // MARK: Handle login response
    
    func handleLoginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "login", sender: nil)
            }
        } else {
            showLoginError(message: error?.localizedDescription ?? "")
        }
    }
    
    // MARK: Button and text field behavior
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailField {
            let currenText = emailField.text ?? ""
            guard let stringRange = Range(range, in: currenText) else { return false }
            let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.isEmpty && updatedText == "" {
                emailFieldIsEmpty = true
            } else {
                emailFieldIsEmpty = false
            }
        }
        
        if textField == passwordField {
            let currenText = passwordField.text ?? ""
            guard let stringRange = Range(range, in: currenText) else { return false }
            let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.isEmpty && updatedText == "" {
                passwordFieldIsEmpty = true
            } else {
                passwordFieldIsEmpty = false
            }
        }
        
        if emailFieldIsEmpty == false && passwordFieldIsEmpty == false {
            buttonEnabled(true, button: loginButton)
        } else {
            buttonEnabled(false, button: loginButton)
        }
        
        return true
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        buttonEnabled(false, button: loginButton)
        if textField == emailField {
            emailFieldIsEmpty = true
        }
        if textField == passwordField {
            passwordFieldIsEmpty = true
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            login(loginButton)
        }
        return true
    }
    
    // MARK: Loading state
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
        DispatchQueue.main.async {
            self.emailField.isEnabled = !loggingIn
            self.passwordField.isEnabled = !loggingIn
            self.loginButton.isEnabled = !loggingIn
            self.buttonEnabled(false, button: self.loginButton)
            self.signUpButton.isEnabled = !loggingIn
        }
    }
    
    // MARK: Login Error alert
    
    func showLoginError(message: String) {
        let alertVC = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
}


