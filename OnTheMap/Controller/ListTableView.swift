//
//  ListTableView.swift
//  OnTheMap
//
//  Created by Lindsey Gjoraas on 6/27/18.
//  Copyright © 2018 Developed by Gjoraas. All rights reserved.
//

import UIKit

class ListTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        let studentInfo = StudentLocation.allLocations[indexPath.row]
        
        if let firstName = studentInfo.firstName, let lastName = studentInfo.lastName {
            cell.textLabel?.text = firstName + " " + lastName
        }
        if let subtitle = studentInfo.mediaURL {
            cell.detailTextLabel?.text = subtitle
        }
        return cell
    }
    

}
