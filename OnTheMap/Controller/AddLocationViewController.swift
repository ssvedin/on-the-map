//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Sabrina on 4/7/19.
//  Copyright © 2019 Sabrina Svedin. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var objectId: String?
    
    var locationTextFieldIsEmpty = true
    var websiteTextFieldIsEmpty = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        websiteTextField.delegate = self
        buttonEnabled(false, button: findLocationButton)
    }
    
    @IBAction func cancelAddLocation(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(sender: UIButton) {
        self.setLoading(true)
        let newLocation = locationTextField.text
        let newWebsite = websiteTextField.text
        
        geocodePosition(newLocation: newLocation ?? "")
    }
    
    private func geocodePosition(newLocation: String) {
        //self.activityIndicator.startAnimating()
        CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
            if let error = error {
                print("Location not found.")
            } else {
                var location: CLLocation?
                
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.setLoading(false)
                    self.loadNewLocation(location.coordinate)
                } else {
                    print("Location not found.")
                }
            }
        }
    }
    
    private func loadNewLocation(_ coordinate: CLLocationCoordinate2D) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "FinishAddLocationViewController") as! FinishAddLocationViewController
        controller.studentInformation = buildStudentInfo(coordinate)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func buildStudentInfo(_ coordinate: CLLocationCoordinate2D) -> StudentInformation {
        
        var studentInfo = [
            "uniqueKey": UdacityClient.Auth.key,
            "firstName": UdacityClient.Auth.firstName,
            "lastName": UdacityClient.Auth.lastName,
            "mapString": locationTextField.text!,
            "mediaURL": websiteTextField.text!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
            //"objectId": UdacityClient.Auth.objectId
            ] as [String: AnyObject]
        
        if let objectId = objectId {
            studentInfo["objectId"] = objectId as AnyObject
            print(objectId)
        }

        return StudentInformation(studentInfo)
    
    }
    
    // MARK: Loading state
    
    func setLoading(_ loading: Bool) {
        if loading {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
        DispatchQueue.main.async {
            self.locationTextField.isEnabled = !loading
            self.websiteTextField.isEnabled = !loading
            self.findLocationButton.isEnabled = !loading
            self.buttonEnabled(false, button: self.findLocationButton)
        }
    }
    
     // MARK: Button and text field behavior
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == locationTextField {
            let currenText = locationTextField.text ?? ""
            guard let stringRange = Range(range, in: currenText) else { return false }
            let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.isEmpty && updatedText == "" {
                locationTextFieldIsEmpty = true
            } else {
                locationTextFieldIsEmpty = false
            }
        }
        
        if textField == websiteTextField {
            let currenText = websiteTextField.text ?? ""
            guard let stringRange = Range(range, in: currenText) else { return false }
            let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.isEmpty && updatedText == "" {
                websiteTextFieldIsEmpty = true
            } else {
                websiteTextFieldIsEmpty = false
            }
        }
        
        if locationTextFieldIsEmpty == false && websiteTextFieldIsEmpty == false {
            buttonEnabled(true, button: findLocationButton)
        } else {
            buttonEnabled(false, button: findLocationButton)
        }
        
        return true
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        buttonEnabled(false, button: findLocationButton)
        if textField == locationTextField {
            locationTextFieldIsEmpty = true
        }
        if textField == websiteTextField {
            websiteTextFieldIsEmpty = true
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            findLocation(sender: findLocationButton)
            
        }
        return true
    }
   
}
