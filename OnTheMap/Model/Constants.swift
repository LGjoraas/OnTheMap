//
//  Constants.swift
//  OnTheMap
//
//  Created by Lindsey Gjoraas on 6/27/18.
//  Copyright © 2018 Developed by Gjoraas. All rights reserved.
//

import UIKit

// MARK: - Constants

struct Constants {
    
    // MARK:  Parse API
    
    struct Parse {
        
        // MARK: Parse Application ID and REST API Key
        
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: Parse URL
        static let APIScheme = "https://"
        static let APIHost = "parse.udacity.com"
        static let APIPath = "/parse/classes/StudentLocation"
        static let GetPostURL = "https://parse.udacity.com/parse/classes/StudentLocation"
        static let PutURL = "https://parse.udacity.com/parse/classes/StudentLocation/<objectID>"
    }
    
    // MARK: Parse Methods
    struct ParseMethods {
        
        static let ParsePutPath = "/<objectID>"
        static let WhereQuery = "?where={uniqueKey}"
    }

    // MARK: Parse Parameter Keys
    struct ParseParameterKeys {
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let UpdatedAt = "updatedAt"
    }
    
    // MARK: ParseJSONBodyKeys
    
    struct ParseJSONBodyKeys {
    
        // MARK: Results
     static let Results = "results"
    }
    
    // MARK: Udacity API
    
    struct Udacity {
        
        // MARK: Udacity URL
        static let APIScheme = "https"
        static let APIHost = "www.udacity.com"
        static let APIPath = "/api/session"
    }
    
    // MARK: UdacityJSONBodyKeys
    struct UdacityJSONBodyKeys {
        
        // MARK: Session
        static let Session = "session"
    }
    
    
    // MARK: Udacity Parameter Keys
    struct UdacityParameterKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        static let ID = "id"

    }
    
    struct NewStudent {
        static let uniqueKey = ""
        static let firstName = ""
        static let lastName = ""
    }
}

