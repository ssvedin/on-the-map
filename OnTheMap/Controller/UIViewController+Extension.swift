//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Sabrina on 3/24/19.
//  Copyright © 2019 Sabrina Svedin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addLocation(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addLocation", sender: sender)
    }

}
