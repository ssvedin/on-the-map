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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: UIButton) {
        performSegue(withIdentifier: "login", sender: sender)
    }
    
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(signUpUrl, options: [:], completionHandler: nil)
    }
    
}

