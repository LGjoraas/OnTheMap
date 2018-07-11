//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Lindsey Gjoraas on 7/10/18.
//  Copyright © 2018 Developed by Gjoraas. All rights reserved.
//

import UIKit

extension Client {
    
    // MARK: Udacity API
    
    // MARK: Function to login
    func loginToUdacity (username: String, password: String, completionHandlerForLogin: @escaping(_ success: Bool, _ error: String?) -> Void ) {
        postSessionIDToRetrieveKey(username, password) { (success, sessionID, userAccountKey, errorMessage) in
            if success {
                self.sessionID = sessionID
                self.userAccountKey = userAccountKey
                
                self.retrieveStudentFirstAndLastName(accountKey: self.userAccountKey!, { (success, studentFirstName, studentLastName, errorMessage) in
                    if success {
                        self.studentFirstName = studentFirstName
                        self.studentLastName = studentLastName
                    }
                    else {
                        completionHandlerForLogin(success, errorMessage)
                    }
                })
            } else {
                completionHandlerForLogin(success, errorMessage)
            }
        }
        
    }
    
    // MARK: Function to post session ID to login
    private func postSessionIDToRetrieveKey (_ email: String, _ password: String, completionHandlerForSessionID: @escaping (_ success: Bool, _ sessionID: String?, _ userAccountKey: String?, _ errorMessage: String?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            /* GUARD: was there an error? */
            guard (error == nil) else { return }
            
            /* GUARD: Did we get correct status? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 403 else {
                print("Status code wrong!")
                return }
            
            
            /* GUARD: Was there any data returned? */
            guard let data = data else { return }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            //let accountDetails = String(data: newData, encoding: .utf8)
            
            var result: [String:AnyObject]!
            do {
                result = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Udacity Login API could not parse the data as JSON")
                return
            }
            
            guard let sessionDict = result["session"] as? [String:AnyObject] else {
                print("Udacity login API could not find session")
                return
            }
            
            guard let sessionID = sessionDict["id"] as? String else {
                print("Udacity login API could not find id")
                return
            }
            
            guard let accountDict = result["account"] as? [String:AnyObject] else {
                print("Udacity login API could not found account")
                return
            }
            
            guard let userAccontKey = accountDict["key"]  as? String else {
                print("Udacity login API could not find key")
                return
            }
            
            completionHandlerForSessionID(true, sessionID, userAccontKey, nil)
            
        }
        
        task.resume()
    }
    
    
    private func retrieveStudentFirstAndLastName(accountKey: String, _ completionHanderForName: @escaping (_ success: Bool, _ firstName: String?, _ lastName: String?, _ error: String?) -> Void) {
        
        // Configure the request
        let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/\(accountKey)")!)
        
        // Make the request
        let task = session.dataTask(with: request) { data, response, error in
            
            // Sends the error message to the completion handler if an error has occured and an
            // error alert pop-up will need to be displayed. Also prints out the error String
            // debug message to the console.
            func sendErrorMessage(_ errorString: String, _ errorMessage: String) {
                print(errorString)
                completionHanderForName(false, nil, nil, errorMessage)
            }
            
            // The string that will contain a detailed error description, should an error arise. For debugging purposes.
            var errorString: String = ""
            
            // The message that will be sent to the alert pop-up through the completion handler,
            // should the first and last name retrieval process be unsuccessful.
            let errorMessage = "Could not retrieve student details from the Udacity server."
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                errorString = "Udacity Public User Data API: There was an error with your request: \(String(describing: error))"
                sendErrorMessage(errorString, errorMessage)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                errorString = "Udacity Public User Data API: Your request returned a status code other than 2xx."
                sendErrorMessage(errorString, errorMessage)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                errorString = "Udacity Public User Data API: No data was returned by the request."
                sendErrorMessage(errorString, errorMessage)
                return
            }
            
            // Parse the data
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            // Parse the subset
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            } catch {
                errorString = "Udacity Public User Data API: Could not parse the data as JSON: '\(newData)'"
                sendErrorMessage(errorString, errorMessage)
                return
            }
            
            // Getting the student's first and last names from their Udacity public user data
            /* GUARD: Is the "user" key in the parsed result? */
            guard let userInfoDictionary = parsedResult["user"] as? [String:AnyObject] else {
                errorString = "Udacity Public User Data API: Cannot find key \"user\" in \(parsedResult)."
                sendErrorMessage(errorString, errorMessage)
                return
            }
            
            /* GUARD: Is the "first_name" key in the dictionary returned under the "user" key? */
            guard let studentFirstName = userInfoDictionary["first_name"] as? String else {
                errorString = "Udacity Public User Data API: Cannot find key \"first_name\" in \(userInfoDictionary)."
                sendErrorMessage(errorString, errorMessage)
                return
            }
            
            /* GUARD: Is the "last_name" key in the dictionary returned under the "user" key? */
            guard let studentLastName = userInfoDictionary["last_name"] as? String else {
                errorString = "Udacity Public User Data API: Cannot find key \"last_name\" in \(userInfoDictionary)."
                sendErrorMessage(errorString, errorMessage)
                return
            }
            
            /*
             If no guard statements were triggered, we've successfully completed the call and
             can send the desired value(s) to completion handler.
             */
            completionHanderForName(true, studentFirstName, studentLastName, nil)
        }
        
        // Initiate the request
        task.resume()
    }
    
    //MARK: Function to delete session to ID to logout
    func deleteSessionIDToLogout(completionHanderForLogout: @escaping (_ success: Bool) -> Void) -> URLSessionTask {
        
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            
            guard let data = data else { return }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            let accountDetails = String(data: newData, encoding: .utf8)
            print("logged out account = \(accountDetails)")
            if (accountDetails?.contains("error"))! {
                completionHanderForLogout(false)
            }
            else {
                completionHanderForLogout(true)
            }
        }
        task.resume()
        
        return task
    }
}

