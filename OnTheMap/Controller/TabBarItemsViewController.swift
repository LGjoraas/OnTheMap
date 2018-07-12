//
//  TabBarItems.swift
//  OnTheMap
//
//  Created by Ryan Gjoraas on 7/11/18.
//  Copyright © 2018 Developed by Gjoraas. All rights reserved.
//

import UIKit

class TabBarItemsViewController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadMapTableVC()
    }
    
    // MARK: Refresh Map and Table View Controllers
    
    // If re-download and storage of latest top 100 student location entries is successful,
    // it's necessary to reload both view controllers that are accessible from this tab bar
    // view controller.
    func reloadMapTableVC() {
        // The map view and table view controllers
        let controllers = self.viewControllers
        
        // Refresh the views of each controller simultaneously.
        for controller in controllers! {
            controller.loadView()
            controller.viewDidLoad()
        }
    }
    

}
