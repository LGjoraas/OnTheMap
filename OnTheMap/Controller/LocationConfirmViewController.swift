//
//  LocationConfirmViewController.swift
//  OnTheMap
//
//  Created by Lindsey Gjoraas on 6/27/18.
//  Copyright © 2018 Developed by Gjoraas. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationConfirmViewController: UIViewController, MKMapViewDelegate {

    // MARK: Properties
    
    var locationAdded: String?
    var urlAdded: String?
    var latitudeAdded: Double?
    var longitudeAdded: Double?
    
    var locationCL: CLLocation?
    var coordinatesCL: CLLocationCoordinate2D?
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let annotation = MKPointAnnotation()
        annotation.coordinate = self.coordinatesCL!
        
        reverseGeoCode(locationCL!) { (locationAddress) in
        
        annotation.title = locationAddress
        
        self.mapView.addAnnotation(annotation)
        self.mapView.centerCoordinate = annotation.coordinate
        self.mapView.camera.altitude = 2500.00
        }
    }
    
    // MARK: Reverse GeoCode to list name of location (Geocoder information from the James Dellinger github project note: could not find any good geocoder tutorials online for this complex of an app)
        
    func reverseGeoCode(_ location: CLLocation, completionHandlerForReverseGeoCode: @escaping (String) -> Void ) {
        
        // String that will contain the reverse geocoded address.
        var locationAddress: String = ""
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil {
                if let placemarks = placemarks, let placemark = placemarks.first, let locationAddress = placemark.compactAddress {
                    completionHandlerForReverseGeoCode(locationAddress)
                } else {
                    locationAddress = "No Matching Addresses Found"
                    completionHandlerForReverseGeoCode(locationAddress)
                }
            } else {
                locationAddress = "No Matching Addresses Found"
                completionHandlerForReverseGeoCode(locationAddress)
            }
        }
    }
    
    
    // MARK: Finish Button Pressed and back to Tab View

    @IBAction func finishPressed(_ sender: Any) {
        Client.sharedInstance().postNewStudentLocation(locationName: locationAdded!, url:
        urlAdded!, latitude: latitudeAdded!, longitude: longitudeAdded!) { (success, error) in
            if success {
                print("added new location")
                self.backToTabView()
            } else if let error = error {
                print(error)
            }
        }
    }
    
    func backToTabView() {
        navigationController?.popToRootViewController(animated: true)
    }


}

// MARK: Placemark extension for reverse geocoder (Geocoder information from the James Dellinger github project note: could not find any good geocoder tutorials online for this complex of an app)
extension CLPlacemark {
    
    var compactAddress: String? {
        if let city = locality {
            var result = city
            
            if let administrativeArea = administrativeArea {
                result += ", \(administrativeArea)"
            }
            
            if let postalCode = postalCode {
                result += " \(postalCode)"
            }
            
            if let country = country {
                result += ", \(country)"
            }
            
            return result
        }
        return nil
    }
}
