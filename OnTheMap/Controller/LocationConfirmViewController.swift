//
//  LocationConfirmViewController.swift
//  OnTheMap
//
//  Created by Lindsey Gjoraas on 6/27/18.
//  Copyright © 2018 Developed by Gjoraas. All rights reserved.
//

import UIKit
import CoreLocation

class LocationConfirmViewController: UIViewController {

    // MARK: Properties
    
    var locationAdded: String?
    var urlAdded: String?
    var latitudeAdded: Double?
    var longitudeAdded: Double?
    
    var locationCL: CLLocation?
    var coordinatesCL: CLLocationCoordinate2D?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func finishPressed(_ sender: Any) {
        Client.sharedInstance().postNewStudentLocation(locationName: locationAdded!, url:
        urlAdded!, latitude: latitudeAdded!, longitude: longitudeAdded!) { (success, error) in
            if success {
                print("added new location")
                self.backToTabView()
            } else {
                print(error)
            }
        }
    }
    
    func backToTabView() {
        navigationController?.popToRootViewController(animated: true)
    }


}
