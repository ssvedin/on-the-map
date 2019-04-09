//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Sabrina on 4/7/19.
//  Copyright © 2019 Sabrina Svedin. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelAddLocation(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(sender: UIButton) {
        self.performSegue(withIdentifier: "finishAddLocation", sender: sender)
    }

}
