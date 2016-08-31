//
//  CreateAccountViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/16/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController, UIAlertViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var themeSelect: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: RoundedTextField!
    @IBOutlet weak var usernameTextField: RoundedTextField!
    @IBOutlet weak var passwordTextField: RoundedTextField!
    @IBOutlet weak var confirmPasswordTextField: RoundedTextField!
    @IBOutlet weak var createButton: RoundedButton!
    
    var usernameCheckTask: URLSessionDataTask? = nil
    let AD = UIApplication.shared.delegate as! AppDelegate
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(dismissKeyboard)))
        
        themeSelect.addTarget(self, action: #selector(themeChanged), for: .valueChanged)
        emailTextField.addTarget(self, action: #selector(checkEmail), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(checkUsernameUnique), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(checkPassword), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(passwordEqual), for: .editingChanged)
        
        updateTheme()
        
        passwordTextField.leftView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(displayPasswordRequirements)))
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
        
        // Suspend checking username if we are
        usernameCheckTask?.suspend()
        usernameCheckTask?.cancel()
        usernameCheckTask = nil
        
        // Check email is correct email
        if !verify(email: emailTextField.text!) {
            createButton.layer.shake()
            checkEmail()
            return
        }
        
        // Check passwords are same, and follow proper rules
        if !verify(password: passwordTextField.text!) || passwordTextField.text != confirmPasswordTextField.text {
            createButton.layer.shake()
            passwordEqual()
            return
        }
        
        // Deactivate button and display load view
        
        self.view.isUserInteractionEnabled = false
        
        let load = LoadingView(frame: self.view.frame)
        self.view.addSubview(load)
        
        Database().createAccount(username: self.usernameTextField.text!,
                                 email: self.emailTextField.text!,
                                 password: self.passwordTextField.text!,
                                 theme: AD.selectedTheme != nil ? AD.selectedTheme! : .None)
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
                    return
                }
                return
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
                
                let alert = UIAlertView(title: alertMain, message: alertDetail, delegate: self, cancelButtonTitle: nil, otherButtonTitles: "Okay")
                alert.show()
            }
        }
    }
    
    func checkEmail() {
        if self.verify(email: self.emailTextField.text!) {
            emailTextField.rightImage = UIImage(.greenCheck)
        } else {
            emailTextField.rightImage = UIImage(.redX)
        }
    }
    
    func checkUsernameUnique() {
        let text = self.usernameTextField.text!
        usernameCheckTask?.suspend()
        usernameCheckTask?.cancel()
        usernameCheckTask = nil
        
        if text == "" {
            self.usernameTextField.rightImage = UIImage(.redX)
            
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
                        self.usernameTextField.rightImage = UIImage(.greenCheck)
                    }
                } else {
                    // User name does exist
                    // Tell user username is unavaiable
                    DispatchQueue.main.async {
                        self.usernameTextField.rightImage = UIImage(.redX)
                    }
                }
            }
        }
    }
    
    func checkPassword() {
        if verify(password: passwordTextField.text!) {
            passwordTextField.rightImage = UIImage(.greenCheck)
        } else {
            passwordTextField.rightImage = UIImage(.redX)
        }
    }
    
    func passwordEqual() {
        if passwordTextField.text == confirmPasswordTextField.text && verify(password: passwordTextField.text!) {
            confirmPasswordTextField.rightImage = UIImage(.greenCheck)
        } else {
            confirmPasswordTextField.rightImage = UIImage(.redX)
            checkPassword()
        }
    }
    
    /**
     Verify an email address stored as a string.
     
     This function uses a simple RegEx to verify if an entered email address
     is a valid email address.
     
     The RegEx pattern for this function was used from http://emailregex.com
     
     - parameter email: String, the email address to check for validity.
     
     - returns: Bool, true if the string contains exactly one email address,
     false otherwise.
     */
    func verify(email: String) -> Bool {
        // This line used from http://emailregex.com
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$"
        let regEx = try! NSRegularExpression(pattern: emailRegex, options: [])
        
        return regEx.numberOfMatches(in: email, options: [], range: NSRange(location: 0, length: email.characters.count)) == 1
    }
    
    func verify(password: String) -> Bool {
        if password.characters.count < 12 {
            return false
        }
        
        if password.rangeOfCharacter(from: .decimalDigits) == nil {
            return false
        }
        
        if password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()-_=+[]{};':,./<>?")) == nil {
            return false
        }
        
        return true
    }
    
    func displayPasswordRequirements() {
        let requirements = UIViewController()
        requirements.modalPresentationStyle = .popover
        requirements.preferredContentSize = CGSize(width: 150, height: 155)
        
        let text = UITextView(frame: CGRect(x: 0, y: 0, width: 150, height: 155))
        text.text = "Password requitements:\n\n" +
                    "Each password must contain:" +
                    "\n\n" +
                    "   • 12+ characters.\n" +
                    "   • A number.\n" +
                    "   • A special character."
        
        text.allowsEditingTextAttributes = false
        text.isSelectable = false
        text.isScrollEnabled = false
        
        text.font = UIFont(name: themeFont, size: 12)
        
        requirements.view.addSubview(text)
        
        let popover = requirements.popoverPresentationController
        popover?.delegate = self
        popover?.permittedArrowDirections = .any
        popover?.sourceView = passwordTextField.leftView
        popover?.sourceRect = passwordTextField.leftView!.bounds
        
        present(requirements, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
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
