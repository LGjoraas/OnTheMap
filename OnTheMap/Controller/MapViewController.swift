//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Lindsey Gjoraas on 6/27/18.
//  Copyright © 2018 Developed by Gjoraas. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
        
        // The map. See the setup in the Storyboard file. Note particularly that the view controller
        // is set up as the map view's delegate.
        @IBOutlet weak var mapView: MKMapView!
    
        var studentLocations = [StudentLocation]()
    
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // We will create an MKPointAnnotation for each dictionary in "locations". The
            // point annotations will be stored in this array, and then provided to the map view.
            var annotations = [MKPointAnnotation]()
            
            
            //let locations = Client.sharedInstance().getStudentLocations()
            //print(locations)
            // The "locations" array is an array of dictionary objects that are similar to the JSON
            // data that you can download from parse.
            Client.sharedInstance().getStudentLocations { (locations, error) in
                if let error = error {
                    print("ERROR = \(error)")
                }
                else if let locations = locations {
                    print("STUDENT LOCATIONS = \(locations)")

                    
                    // The "locations" array is loaded with the sample data below. We are using the dictionaries
                    // to create map annotations. This would be more stylish if the dictionaries were being
                    // used to create custom structs. Perhaps StudentLocation structs.

                    for location in locations {
                        
                        // Notice that the float values are being used to create CLLocationDegree values.
                        // Check if student location properties exist, and if so, put StudentLocation on map
                        if let latitude = location.latitude, let longitude = location.longitude, let first = location.firstName, let last = location.lastName, let mediaURL = location.mediaURL {
                            let lat = CLLocationDegrees(latitude)
                            print("LATITUDE = \(lat)")
                            let long = CLLocationDegrees(longitude)
                            print("LONGITUDE = \(long)")
                            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = coordinate
                            print("COORDINATE = \(annotation.coordinate)")
                            annotation.title = "\(first) \(last)"
                            annotation.subtitle = mediaURL
                            
                            // Finally we place the annotation in an array of annotations.
                            annotations.append(annotation)
                        }
                        else {
                            print("All values of a Student Location do not exist!")
                        }
                    }
                }
                // When the array is complete, we add the annotations to the map.
                self.mapView.addAnnotations(annotations)
            }
        }
            
        
        // MARK: - MKMapViewDelegate
        
        // Here we create a view with a "right callout accessory view". You might choose to look into other
        // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
        // method in TableViewDataSource.
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.pinColor = .red
                pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }
        
        
        // This delegate method is implemented to respond to taps. It opens the system browser
        // to the URL specified in the annotationViews subtitle property.
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if control == view.rightCalloutAccessoryView {
                let app = UIApplication.shared
                if let toOpen = view.annotation?.subtitle! {
                    app.openURL(URL(string: toOpen)!)
                }
            }
        }
    
    
    
  
    
}
