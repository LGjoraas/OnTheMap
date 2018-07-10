//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Lindsey Gjoraas on 6/27/18.
//  Copyright © 2018 Developed by Gjoraas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var signUpTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributedString = NSMutableAttributedString(string: "Don't have an account? Sign Up")
        attributedString.addAttribute(.link, value: "https://auth.udacity.com/sign-up", range: NSRange(location: 23, length: 7))
        
        signUpTextView.attributedText = attributedString
        signUpTextView.textAlignment = .center
        signUpTextView.font = UIFont(name: "Avenir Next", size: 17)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
    
    
    // MARK: POST a Session
    
    @IBAction func loginPressed(_ sender: Any) {
       
        guard let email = emailTextField.text, email != "" else { return }
        guard let password = passwordTextField.text, password != "" else { return }
        
        Client.sharedInstance().postSessionIDToLogin(email, password) { (success) in
            performUIUpdatesOnMain {
                if success {
                    self.completeLogin()  //this does not work here?? - segue issue??
                }
                else {
                    print("Account is not registered with Udacity!")
                }
            }

            //self.completeLogin()
        }
    }
        /*var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        guard let email = emailTextField.text, email != "" else { return }
        guard let password = passwordTextField.text, password != "" else { return }
        var accountDetails: String = ""
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        //print(request.httpBody)
            let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error { // Handle error…
                print("ERROR = \(error)")
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            accountDetails = String(data: newData!, encoding: .utf8)!
            print(response)
        
        }
        
        task.resume()
        print("ACCOUNT! = \(accountDetails)")
        if accountDetails.contains("\"Account not found or invalid credentials\"") {
            print("Account not registered!")*/
        /*else {
            self.completeLogin()
        }*/
    
    private func completeLogin() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ManagerTabBarController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func unwindMapTableViews(segue: UIStoryboardSegue) {
        Client.sharedInstance().deleteSessionIDToLogout { (success) in
            performUIUpdatesOnMain {
                if success {
                    self.viewDidLoad()
                }
            }
        }
    }
}
    
    
    
    
    
    
    // MARK: GET Method for multiple student locations at one time
/*
     To get multiple student locations at one time, you'll want to use the following API method:
     
     Method: https://parse.udacity.com/parse/classes/StudentLocation
     Method Type: GET
     Optional Parameters:
     limit - (Number) specifies the maximum number of StudentLocation objects to return in the JSON response
     Example: https://parse.udacity.com/parse/classes/StudentLocation?limit=100
     skip - (Number) use this parameter with limit to paginate through results
     Example: https://parse.udacity.com/parse/classes/StudentLocation?limit=200&skip=400
     order - (String) a comma-separate list of key names that specify the sorted order of the results
     Prefixing a key name with a negative sign reverses the order (default order is ascending)
     Example: https://parse.udacity.com/parse/classes/StudentLocation?order=-updatedAt
     
 GETting a student Location Example Code:
 
     var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
     request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
     request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
     let session = URLSession.shared
     let task = session.dataTask(with: request) { data, response, error in
     if error != nil { // Handle error...
     return
     }
     print(String(data: data!, encoding: .utf8)!)
     }
     task.resume()
*/
    
    // MARK: GET method for one student location
    
/*
     To get a single student location, you'll want to use the following API method:
     
     Method: https://parse.udacity.com/parse/classes/StudentLocation
     Method Type: GET
     Required Parameters:
     where - (Parse Query) a SQL-like query allowing you to check if an object value matches some target value
     Example: https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%221234%22%7D
     the above URL is the escaped form of… https://parse.udacity.com/parse/classes/StudentLocation?where={"uniqueKey":"1234"}
     you can read more about these types of queries in Parse’s REST API documentation
     Example Request:
     let urlString = "https://parse.udacity.com/parse/classes/StudentLocation"
     let url = URL(string: urlString)
     var request = URLRequest(url: url!)
     request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
     request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
     let session = URLSession.shared
     let task = session.dataTask(with: request) { data, response, error in
     if error != nil { // Handle error
     return
     }
     print(String(data: data!, encoding: .utf8)!)
     }
     task.resume()
 */
    
    // MARK: POST Method for a student location
    
    /*
     To create a new student location, you'll want to use the following API method:
     
     Method: https://parse.udacity.com/parse/classes/StudentLocation
     Method Type: POST
     Example Request:
     var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
     request.httpMethod = "POST"
     request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
     request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
     request.addValue("application/json", forHTTPHeaderField: "Content-Type")
     request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
     let session = URLSession.shared
     let task = session.dataTask(with: request) { data, response, error in
     if error != nil { // Handle error…
     return
     }
     print(String(data: data!, encoding: .utf8)!)
     }
     task.resume()
 */
    
    // MARK: POST a student location
    
    /*
     To update an existing student location, you'll want to use the following API method:
     
     Method: https://parse.udacity.com/parse/classes/StudentLocation/<objectId>
     Method Type: PUT
     Required Parameters:
     objectId - (String) the object ID of the StudentLocation to update; specify the object ID right after StudentLocation in URL as seen below
     Example: https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8
     Example Request:
     let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8"
     let url = URL(string: urlString)
     var request = URLRequest(url: url!)
     request.httpMethod = "PUT"
     request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
     request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
     request.addValue("application/json", forHTTPHeaderField: "Content-Type")
     request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
     let session = URLSession.shared
     let task = session.dataTask(with: request) { data, response, error in
     if error != nil { // Handle error…
     return
     }
     print(String(data: data!, encoding: .utf8)!)
     }
     task.resume()
 */
    
    // MARK: POST a session
    
    /*
     To authenticate Udacity API requests, you need to get a session ID. This is accomplished by using Udacity’s session method:
     
     Method: https://www.udacity.com/api/session
     Method Type: POST
     Required Parameters:
     udacity - (Dictionary) a dictionary containing a username/password pair used for authentication
     username - (String) the username (email) for a Udacity student
     password - (String) the password for a Udacity student
     Example Request:
     var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
     request.httpMethod = "POST"
     request.addValue("application/json", forHTTPHeaderField: "Accept")
     request.addValue("application/json", forHTTPHeaderField: "Content-Type")
     request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
     let session = URLSession.shared
     let task = session.dataTask(with: request) { data, response, error in
     if error != nil { // Handle error…
     return
     }
     let range = Range(5..<data!.count)
     let newData = data?.subdata(in: range) /* subset response data! */
     print(String(data: newData!, encoding: .utf8)!)
     }
     task.resume()

 */
    
    // MARK: DELETE a session
    
    /*
     nce you get a session ID using Udacity's API, you should delete the session ID to "logout". This is accomplished by using Udacity’s session method:
     
     Method: https://www.udacity.com/api/session
     Method Type: DELETE
     Example Request:
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
     let range = Range(5..<data!.count)
     let newData = data?.subdata(in: range) /* subset response data! */
     print(String(data: newData!, encoding: .utf8)!)
     }
     task.resume()
 */
    
    // MARK: GET Public User Data
    
    /*
     The whole purpose of using Udacity's API is to retrieve some basic user information before posting data to Parse. This is accomplished by using Udacity’s user method:
     
     Method Name: https://www.udacity.com/api/users/<user_id>
     Method Type: GET
     Example Request:
     let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/3903878747")!)
     let session = URLSession.shared
     let task = session.dataTask(with: request) { data, response, error in
     if error != nil { // Handle error...
     return
     }
     let range = Range(5..<data!.count)
     let newData = data?.subdata(in: range) /* subset response data! */
     print(String(data: newData!, encoding: .utf8)!)
     }
     task.resume()

 */
    


