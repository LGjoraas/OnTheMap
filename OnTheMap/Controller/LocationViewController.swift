//
//  LocationViewController.swift
//  OnTheMap
//
//  Created by Lindsey Gjoraas on 6/27/18.
//  Copyright © 2018 Developed by Gjoraas. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit



class LocationViewController: UIViewController {

    
    // MARK: Properties
    
    var locationString: String?
    var urlString: String?
    var latitude: Double?
    var longitude: Double?
    
    var getLocation: CLLocation?
    var getCoordinates: CLLocationCoordinate2D?
    
    
    // MARK: Outlets
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    
    // MARK: Find Location Button Pressed
    
    @IBAction func findLocationPressed(_ sender: Any) {
        
        guard let locationEntered = self.locationTextField.text else { return }
    
        self.urlString = self.linkTextField.text!
        print("LOCATION ENTERED = \(locationEntered)")
        self.getLatLong(locationString: locationEntered) { (success, location, coordinates, error) in
            performUIUpdatesOnMain {
                if success{
                    
                    print("SUCCESS getLATLONG")
                    
                    self.locationString = locationEntered
                    self.getLocation = location
                    self.getCoordinates = coordinates
                    self.latitude = coordinates.latitude
                    self.longitude = coordinates.longitude
                    print("SUCCESS GET COORDINATES")
                    
                    print(success)
                    self.showLocationConfirmVC()
                    
                } else {
                    print("Error with location entered = \(error)")
                }
            }
        }
    }
    
    // MARK: Get Lat and Long ((Geocoder information from the James Dellinger github project note: could not find any good geocoder tutorials online for this complex of an app)
    
    func getLatLong(locationString: String, completionHandler: @escaping (Bool, CLLocation?, CLLocationCoordinate2D, NSError?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationString, completionHandler: { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    print("LOCATION: \(location)")
                    completionHandler(true, location, location.coordinate, nil)
                    return
                }
            } else {
                    completionHandler(false, nil, kCLLocationCoordinate2DInvalid, error as NSError?)
                }
            })
    
        }
    
    
    // MARK: Show Location Confirm View Controller
    func showLocationConfirmVC() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "locationConfirmVC") as! LocationConfirmViewController

            controller.urlAdded = urlString!
            controller.locationAdded = locationString!
            controller.latitudeAdded = latitude!
            controller.longitudeAdded = longitude!
            controller.locationCL = getLocation!
            controller.coordinatesCL = getCoordinates!
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
        
    @IBAction func cancelPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
