//
//  TabBarItems.swift
//  OnTheMap
//
//  Created by Lindsey Gjoraas on 7/11/18.
//  Copyright © 2018 Developed by Gjoraas. All rights reserved.
//

import UIKit

class TabBarItemsViewController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadMapTableVC()
    }
    
    
    // MARK: Refresh Map and Table View Controllers
    
    func reloadMapTableVC() {
        // The map view and table view controllers
        let controllers = self.viewControllers
        
        // Refresh the views of each controller simultaneously.
        for controller in controllers! {
            //controller.loadView()
            //controller.viewDidLoad()
            controller.viewWillAppear(true) // this should refresh and retrieve all student locations again from the MapViewController viewWillAppear function 
        }
    }
    
    
    // MARK: Refresh button functionality
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        reloadMapTableVC()
    }
}
