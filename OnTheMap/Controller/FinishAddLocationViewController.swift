//
//  FinishAddLocationViewController.swift
//  OnTheMap
//
//  Created by Sabrina on 4/7/19.
//  Copyright © 2019 Sabrina Svedin. All rights reserved.
//

import UIKit
import MapKit

class FinishAddLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var studentInformation: StudentInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let studentLocation = studentInformation {
            let studentLocation = Location(
                objectId: "",
                uniqueKey: nil,
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                createdAt: "",
                updatedAt: ""
            )
            showLocations(location: studentLocation)
        }
    }
    
    @IBAction func finishAddLocation(_ sender: UIButton) {
        if let studentLocation = studentInformation {
            if studentLocation.locationId == nil {
                UdacityClient.addStudentLocation(information: studentLocation) { (success, error) in
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                    // TODO: handle error
                    print(error?.localizedDescription as Any)
                }
            } else {
                UdacityClient.updateStudentLocation(information: studentLocation) { (success, error) in
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                    // TODO: handle error
                    print(error?.localizedDescription as Any)
                }
            }
        }
    }
    
    private func showLocations(location: Location) {
        mapView.removeAnnotations(mapView.annotations)
        if let coordinate = extractCoordinate(location: location) {
            let annotation = MKPointAnnotation()
            annotation.title = location.locationLabel
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    private func extractCoordinate(location: Location) -> CLLocationCoordinate2D? {
        if let lat = location.latitude, let lon = location.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }
    

}
