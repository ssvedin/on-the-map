//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sabrina on 3/23/19.
//  Copyright © 2019 Sabrina Svedin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let signUpUrl = URL(string: "https://auth.udacity.com/sign-up")!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.text = ""
        passwordField.text = ""
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
            //TODO: error handling
            print("Login error.")
        }
    }
}


