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
        
        Client.sharedInstance().loginToUdacity(username: email, password: password) { (success, error) in
            performUIUpdatesOnMain {
                if success {
                    self.completeLogin()  //this does not work here?? - segue issue??
                }
                else {
                    print("Account is not registered with Udacity!")
                }
            }
        }
    }
    
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
                else {
                    print("Could not be logged out")
                }
            }
        }
    }
}
    

