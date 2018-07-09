//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Ryan Gjoraas on 7/9/18.
//  Copyright © 2018 Developed by Gjoraas. All rights reserved.
//


struct StudentLocation {
    
    // MARK: Properties
    
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mediaURL: String?
    
    // MARK: Initializers
    
    // construct a StudentLocation from a dictionary
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary[Constants.ParseParameterKeys.FirstName] as? String
        lastName = dictionary[Constants.ParseParameterKeys.LastName] as? String
        latitude = dictionary[Constants.ParseParameterKeys.Latitude] as? Double
        longitude = dictionary[Constants.ParseParameterKeys.Longitude] as? Double
        mediaURL = dictionary[Constants.ParseParameterKeys.MediaURL] as? String
    }
    
    static func locationsFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        
        var locations = [StudentLocation]()
        
        // iterate through array of dictionaries, each StudentLocation is a dictionary
        for result in results {
            locations.append(StudentLocation(dictionary: result))
        }
        
        return locations
    }
}
