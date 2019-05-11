//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sabrina on 3/23/19.
//  Copyright © 2019 Sabrina Svedin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let signUpUrl = URL(string: "https://auth.udacity.com/sign-up")!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.text = ""
        passwordField.text = ""
        emailField.delegate = self
        passwordField.delegate = self
        loginButtonEnabled(false)
    }
    
    @IBAction func login(_ sender: UIButton) {
        UdacityClient.login(email: self.emailField.text ?? "", password: self.passwordField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(signUpUrl, options: [:], completionHandler: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "login", sender: nil)
            }
        } else {
            showLoginError(message: error?.localizedDescription ?? "")
            print("Login error.")
        }
    }
    
    func showLoginError(message: String) {
        let alertVC = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
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
    
}


