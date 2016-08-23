//
//  CreateAccountViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/16/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet weak var themeSelect: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: RoundedTextField!
    @IBOutlet weak var usernameTextField: RoundedTextField!
    @IBOutlet weak var passwordTextField: RoundedTextField!
    @IBOutlet weak var confirmPasswordTextField: RoundedTextField!
    @IBOutlet weak var createButton: RoundedButton!
    
    var usernameCheckTask: URLSessionDataTask? = nil
    let AD = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(dismissKeyboard)))
        
        themeSelect.addTarget(self, action: #selector(themeChanged), for: .valueChanged)
        usernameTextField.addTarget(self, action: #selector(checkUsernameUnique), for: .allEditingEvents)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func themeChanged() {
        AD.selectedTheme = Theme(rawValue: themeSelect.selectedSegmentIndex + 1)
        updateTheme()
    }
    
    func updateTheme() {
        let themeColor = AD.myThemeColor()
        
        self.view.backgroundColor = themeColor
        
        emailTextField.tintColor = themeColor
        usernameTextField.tintColor = themeColor
        passwordTextField.tintColor = themeColor
        confirmPasswordTextField.tintColor = themeColor
    }
    
    func dismissKeyboard() {
        self.view.endEditing(false)
    }

    @IBAction func createButtonPressed(_ sender: AnyObject) {
        dismissKeyboard()
        
        usernameCheckTask?.suspend()
        usernameCheckTask?.cancel()
        usernameCheckTask = nil
        
        // TODO: Implement checks
        // Create account
        // Check email is correct email
        // Check it doesnt exist in DB
        // Check username is unique
        // Check passwords are same, and follow proper rules
        
        // Deactivate button and set image to activity indicator
        
        self.view.isUserInteractionEnabled = false
        
        let load = LoadingView(frame: self.view.frame)
        self.view.addSubview(load)
        
        Database().createAccount(username: self.usernameTextField.text!,
                                 email: self.emailTextField.text!,
                                 password: self.passwordTextField.text!)
        { (data, response, error) in
            // Check user creation was successful
            
            var reply: String? = nil
            
            if data != nil {
                reply = String(data: data!, encoding: .utf8)
            }
            
            if reply == "0" {
                // Successfully created the user account
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "UnwindToLoginView", sender: self)
                }
            }
            
            var alertMain = ""
            var alertDetail = ""
            
            if reply == nil {
                // No reply, network error
                alertMain = "Network error"
                alertDetail = "There was a network error. Please try again later."
            }
            
            if reply == "-1" {
                // Username not unique
                alertMain = "Username taken"
                alertDetail = "That username is already in use. Please choose a different username.\n\nForgot your password? Follow forgot password from the login screen."
            }
            
            if reply == "-2" {
                // Email not unique
                alertMain = "Email already registered"
                alertDetail = "That email is already registered. Please choose a email address, or sign in with your account.\n\nForgot your password? Follow forgot password from the login screen."
            }
            
            if reply == "-3" || reply == "-4" {
                // UID not unique
                // Or Unknown
                alertMain = "Unknown error"
                alertDetail = "There was an unknown error. Please try again."
            }
            
//            if reply == "-4" {
//                // Unknown Error
//            }
            
            DispatchQueue.main.async {
                load.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
                
                let alert = UIAlertView(title: alertMain, message: alertDetail, delegate: self, cancelButtonTitle: nil, otherButtonTitles: "Ok")
                alert.show()
            }
        }
    }
    
    func checkUsernameUnique() {
        let text = self.usernameTextField.text!
        usernameCheckTask?.suspend()
        usernameCheckTask?.cancel()
        usernameCheckTask = nil
        
        if text == "" {
            self.usernameTextField.rightImage = UIImage(named: "red x.png")
            
            return
        }
        
        // Set right image in text field to be a loading icon
        let loading = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 41, height: 41))
        self.usernameTextField.rightViewMode = .always
        self.usernameTextField.rightView = loading
        loading.startAnimating()
        loading.activityIndicatorViewStyle = .gray
        
        usernameCheckTask = Database().check(username: self.usernameTextField.text!) { (data, response, error) in
            if data != nil {
                if String(data: data!, encoding: .utf8) == "0" {
                    // User name does not exist
                    DispatchQueue.main.async {
                        self.usernameTextField.rightImage = UIImage(named: "green check.png")
                    }
                } else {
                    // User name does exist
                    // Tell user username is unavaiable
                    DispatchQueue.main.async {
                        self.usernameTextField.rightImage = UIImage(named: "red x.png")
                    }
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
