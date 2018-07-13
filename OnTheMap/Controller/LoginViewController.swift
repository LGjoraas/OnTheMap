//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Lindsey Gjoraas on 6/27/18.
//  Copyright © 2018 Developed by Gjoraas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextViewDelegate {
    
    
    // MARK: Outlets

    @IBOutlet weak var signUpTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributedString = NSMutableAttributedString(string: "Don't have an account? Sign Up")
        attributedString.addAttribute(.link, value: "https://auth.udacity.com/sign-up", range: NSRange(location: 23, length: 7))
        
        signUpTextView.attributedText = attributedString
        signUpTextView.textAlignment = .center
        signUpTextView.font = UIFont(name: "Avenir Next", size: 17)
    }
    
    // MARK: Use Hyperlink in Text Field
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
                    self.completeLogin()
                }
                else {
                    AlertController.showAlert(inViewController: self, title: "Error Found", message: "Invalid login information entered.")
                  
                }
            }
        }
    }
    
    
    // MARK: Complete Login
    
    private func completeLogin() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    
    // MARK: Error Alert for Login
    
//    func displayLoginAlert() {
//        let alert = UIAlertController(title: "Login Error", message: "Invalid login information entered.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true)
//    }
    
    
    // MARK: Unwind back to Map and Table Views
    
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
    
   
    
    // MARK: Show/Hide Keyboard
//    
//    @objc func keyboardWillShow(_ notification: Notification) {
//        if !keyboardOnScreen {
//            view.frame.origin.y -= keyboardHeight(notification)/2
//        }
//    }
//    
//    @objc func keyboardWillHide(_ notification: Notification) {
//        if keyboardOnScreen {
//            view.frame.origin.y += keyboardHeight(notification)/2
//        }
//    }
//    
//    @objc func keyboardDidShow(_ notification: Notification) {
//        keyboardOnScreen = true
//    }
//    
//    @objc func keyboardDidHide(_ notification: Notification) {
//        keyboardOnScreen = false
//    }
//    
//    private func keyboardHeight(_ notification: Notification) -> CGFloat {
//        let userInfo = (notification as NSNotification).userInfo
//        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
//        return keyboardSize.cgRectValue.height
//    }
//    
//    private func resignIfFirstResponder(_ textField: UITextField) {
//        if textField.isFirstResponder {
//            textField.resignFirstResponder()
//        }
//    }
//    
//    @IBAction func userDidTapView(_ sender: AnyObject) {
//        resignIfFirstResponder(emailTextField)
//        resignIfFirstResponder(passwordTextField)
//    }
//}
    
}
    

