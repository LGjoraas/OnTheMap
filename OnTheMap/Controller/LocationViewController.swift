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
    
    // MARK: Find Location Button Pressed
    
    @IBAction func findLocationPressed(_ sender: Any) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        guard let locationEntered = self.locationTextField.text else { return }
    
        self.urlString = self.linkTextField.text!
        
        self.getLatLong(locationString: locationEntered) { (success, location, coordinates, error) in
            performUIUpdatesOnMain {
                if success{
                    UIViewController.removeSpinner(spinner: sv)
                    self.locationString = locationEntered
                    self.getLocation = location
                    self.getCoordinates = coordinates
                    self.latitude = coordinates.latitude
                    self.longitude = coordinates.longitude
                    self.showLocationConfirmVC()
                } else {
                    UIViewController.removeSpinner(spinner: self.view)
                    AlertController.showAlert(inViewController: self, title: "Error Found", message: "Your location could not be found.")
                    print("Error with location entered = \(error)")
                }
            }
        }
    }

    
    // MARK: Get Lat and Long
    // Geocoder information from the James Dellinger github project note: could not find any good geocoder tutorials online for this complex of an app
    
    func getLatLong(locationString: String, completionHandler: @escaping (Bool, CLLocation?, CLLocationCoordinate2D, NSError?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationString) { (placemarks, error) in
            if let error = error {
                print("Unable to forward geocode address = \(error)")
                completionHandler(false, nil, kCLLocationCoordinate2DInvalid, nil)
            } else {
                if let placemarks = placemarks, placemarks.count > 0  {
                    if let location = placemarks.first?.location {
                        completionHandler(true, location, location.coordinate, nil)
                        return
                    }
                }
            }
        }
    }
    
    
    // MARK: Placemarks
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            
        } else {
            var location: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
            }
        }
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
    
    
    // MARK: Cancel Button Pressed
    
    @IBAction func cancelPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


// MARK: Display spinner for geocode

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
