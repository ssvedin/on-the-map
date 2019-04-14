//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Sabrina on 4/7/19.
//  Copyright © 2019 Sabrina Svedin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    var locationID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        websiteTextField.delegate = self
    }
    
    @IBAction func cancelAddLocation(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(sender: UIButton) {
        let newLocation = locationTextField.text
        let newWebsite = websiteTextField.text
        
        geocodePosition(newLocation: newLocation ?? "")
        //self.performSegue(withIdentifier: "finishAddLocation", sender: sender)
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "finishAddLocation" {
            let controller = segue.destination as! FinishAddLocationViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    */
    private func geocodePosition(newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
            if let error = error {
                print("Location not found.")
            } else {
                var location: CLLocation?
                
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
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
        let nameComponents = UdacityClient.Auth.userName?.components(separatedBy: " ")
        let firstName = nameComponents?.first ?? ""
        let lastName = nameComponents?.last ?? ""
        
        var studentInfo = [
            "uniqueKey": UdacityClient.Auth.key!,
            "firstName": firstName,
            "lastName": lastName,
            "mapString": locationTextField.text!,
            "mediaURL": websiteTextField.text!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
            ] as [String: AnyObject]
        
        if let locationID = locationID {
            studentInfo["objectId"] = locationID as AnyObject
        }
        return StudentInformation(studentInfo)
    }
    
}
