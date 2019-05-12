//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sabrina on 3/23/19.
//  Copyright © 2019 Sabrina Svedin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties and Outlets
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let signUpUrl = URL(string: Constants.Udacity.udacitySignUpURL)!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.text = ""
        passwordField.text = ""
        emailField.delegate = self
        passwordField.delegate = self
        loginButtonEnabled(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailField.text = ""
        passwordField.text = ""
        setLoggingIn(false)
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
            print("Login error.")
        }
    }
    
    // MARK: Log In button state
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (emailField.text?.isEmpty)! && (passwordField.text?.isEmpty)! {
            loginButtonEnabled(false)
        } else {
            loginButtonEnabled(true)
        }
    }
    
    func loginButtonEnabled(_ enabled: Bool) {
        if enabled {
            loginButton.isEnabled = true
            loginButton.alpha = 1.0
        } else {
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
        }
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
            self.loginButtonEnabled(false)
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


