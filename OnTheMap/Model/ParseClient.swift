//
//  Client.swift
//  OnTheMap
//
//  Created by Lindsey Gjoraas on 6/28/18.
//  Copyright © 2018 Developed by Gjoraas. All rights reserved.
//

import UIKit
import Foundation


class Client: NSObject {
    
   
    // MARK: Properties
    
    // session variables
    
    var session = URLSession.shared
    var sessionID: String? = nil
    
    // student info variables
    
    var userAccountKey: String? = nil
    var studentFirstName: String? = nil
    var studentLastName: String? = nil
    
    // location variables
    
    var objectid: String? = nil
    
    
    // MARK: Singleton
    class func sharedInstance() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }
    
    
    // MARK : Parse API
    
    // MARK: Function to GET student locations
    
    func getStudentLocations(completionHandlerForStudentLocations: @escaping (_ result: [StudentLocation]?, _ error: NSError?) -> Void) {
        
        let _ = taskForGETMethod { (data, error) in
            if let error = error {
                completionHandlerForStudentLocations(nil, error)
            } else {
                if let results = data?["results"] as? [[String:AnyObject]] {
                    let studentLocations = StudentLocation.locationsFromResults(results)
                    completionHandlerForStudentLocations(studentLocations, nil)
                } else {
                    completionHandlerForStudentLocations(nil, NSError(domain: "get Student Locations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }
    
    // MARK: Task for GET
    
    func taskForGETMethod(completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let url = URL(string: Constants.Parse.GetPostURL)
        
        /* 2/3. Build the URL, Configure the request */
        var request = URLRequest(url: url!)
        request.addValue(Constants.Parse.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Parse.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        /* 4. Make the request */
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        return task
    }
    
    
    // MARK: Return information from parsed result
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    
    // MARK: Function to POST a new student location
    
    func postNewStudentLocation(locationName: String, url: String, latitude: Double, longitude: Double, completionHandlerForNewLocation: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        
        /* 2/3. Build the URL, Configure the request */
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(userAccountKey!)\", \"firstName\": \"\(studentFirstName!)\", \"lastName\": \"\(studentLastName!)\",\"mapString\": \"\(locationName)\", \"mediaURL\": \"\(url)\", \"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
       
        
        /* 4. Make the request */
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendErrorMessage(_ errorString: String, _ errorMessage: String) {
                print(errorString)
                completionHandlerForNewLocation(false, errorMessage)
            }
        
            /* GUARD: Was there an error? */
            var errorString: String = ""
            let errorMessage = "Could not successfully upload your location to the Parse server."
            guard (error == nil) else {
                errorString = "Post student location to Parse API: There was an error with your request: \(String(describing: error))"
                sendErrorMessage(errorString, errorMessage)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                errorString = "Post student location to Parse API: Your request returned a status code other than 2xx."
                sendErrorMessage(errorString, errorMessage)
                return
            }
            
            // Check to see if data was returned
            guard let data = data else {
                errorString = "Post student location to Parse API: No data was returned by the request."
                sendErrorMessage(errorString, errorMessage)
                return
            }
            
            // Parse the JSON data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                errorString = "Post student location to Parse API: Could not parse the data as JSON: '\(data)'"
                sendErrorMessage(errorString, errorMessage)
                return
            }
            completionHandlerForNewLocation(true, nil)
        }
        task.resume()
    }
}
