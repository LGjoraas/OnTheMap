//
//  Client.swift
//  OnTheMap
//
//  Created by Lindsey Gjoraas on 6/28/18.
//  Copyright © 2018 Developed by Gjoraas. All rights reserved.
//

import UIKit


class Client: NSObject {
    
    var session = URLSession.shared
    
    // MARK: Get Multiple Student Locations
    /*func getStudentLocations() -> [[String:Any]] {
        var results = [[String:Any]]()
        let _ = taskForGETMethod { (data, error) in
            //print(data)
            guard (error == nil) else {
                return
            }
            if let data = data {
                results = data["results"] as! [[String:Any]]
                print("RESULTS = \(results)")
            }
        }
        return results 
    }*/
    
    
    // MARK : Functions for Parse API
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
        //let session = URLSession.shared
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
    
    // MARK: Task for GET
    
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let url = URL(string: Constants.Parse.GetPostURL)
        
        /* 2/3. Build the URL, Configure the request */
        var request = URLRequest(url: url!)
        request.addValue(Constants.Parse.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Parse.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        /* 4. Make the request */
        //let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
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
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    // given raw JSON, return a usable Foundation object
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
    
    // MARK: Singleton
    class func sharedInstance() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }
    
    // MARK: Udacity API
    func postSessionIDToLogin (_ email: String, _ password: String, completionHandlerForLogin: @escaping (_ success: Bool) -> Void) -> URLSessionTask {
        
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
            //guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 403 else {
               // print("Status code wrong!")
               // return }
        
            
            /* GUARD: Was there any data returned? */
            guard let data = data else { return }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            let accountDetails = String(data: newData, encoding: .utf8)
            
            if (accountDetails?.contains("error"))! {
                print("ERROR!!")
                completionHandlerForLogin(true)
            }
            else {
                completionHandlerForLogin(true)
            }
            
        }
        
        task.resume()
        
        return task
    }
    
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
