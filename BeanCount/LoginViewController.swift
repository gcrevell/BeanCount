//
//  LoginViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/16/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var rememberLoginSwitch: UISwitch!
    
    let AD = UIApplication.shared.delegate as! AppDelegate
    
    var waitView: LoadingView? = nil
    
    let introArray = ["Good to see you", "Hello, world!", "You look beautiful today", "Howdy", "Good day", "Bonjour"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        rememberLoginSwitch.onTintColor = UIColor.green
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        self.titleLabel.text = introArray[Int(arc4random_uniform(UInt32(introArray.count)))]
        
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults()
        
        if defaults.bool(forKey: "AUTO_LOGIN") {
            self.rememberLoginSwitch.isOn = true
            
            self.usernameField.text = defaults.string(forKey: "USER_EMAIL")
            self.passwordField.text = defaults.string(forKey: "USER_PASSWORD")
            
            self.usernameField.isHidden = true
            self.passwordField.isHidden = true
            
            login()
        } else {
            self.rememberLoginSwitch.isOn = false
            
            self.usernameField.isHidden = false
            self.passwordField.isHidden = false
            
            self.usernameField.placeholder = "Username"
            self.passwordField.placeholder = "Password"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    func updateTheme() {
        let themeColor = AD.myThemeColor()
        view.backgroundColor = themeColor
        
        passwordField.tintColor = themeColor
        usernameField.tintColor = themeColor
    }
    
    func login() {
        dismissKeyboard()
        
        self.view.isUserInteractionEnabled = false
        
        waitView = LoadingView(frame: self.view.frame)
        self.view.addSubview(waitView!)
        
        let defaults = UserDefaults()
        defaults.set(self.rememberLoginSwitch.isOn, forKey: "AUTO_LOGIN")
        
        // Login to the database
        // Get a token for login
        
        Database().login(username: usernameField.text!, password: passwordField.text!) { (data, response, error) in
            var title = ""
            var subtitle = ""
            
            if data == nil {
                // Network error
                title = "Network error"
                subtitle = "There was a network error. Please try again later."
                
                return
            }
            
            let reply = String(data: data!, encoding: .utf8)
            
            if reply == "-1" {
                // User has not confirmed their email
                title = "Confirm email"
                subtitle = "Please confirm your email with the link sent to you."
            } else if reply == "-2" {
                // User does not exist
                title = "User not found"
                subtitle = "No user was found with those credentials. Please check your username and password or create an account."
            } else {
                // User exists. Return is: token\nlocationUID\ntheme
                // Save token
                // Segue to next view
                
                let values = reply!.components(separatedBy: "\n")
                
                self.AD.loginToken = values[0]
                // Load location data
                // Set local location data to remote location data
                if let themeNum = Int(values[2]) {
                    self.AD.selectedTheme = Theme(rawValue: themeNum)
                }
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "SegueToCurrentLocation", sender: self)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                let alert = UIAlertView(title: title, message: subtitle, delegate: self, cancelButtonTitle: nil, otherButtonTitles: "Okay")
                alert.show()
            }
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        waitView?.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }

    // MARK: - Navigation
    
    @IBAction func unwindToLogin(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func logout(segue:UIStoryboardSegue) {
        let defaults = UserDefaults()
        
        defaults.set(false, forKey: "AUTO_LOGIN")
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
