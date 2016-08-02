//
//  LoginViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/16/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var rememberLoginSwitch: UISwitch!
    
    let emailIcon = UIImageView(frame: CGRect(x: 9, y: 9, width: 24, height: 24))
    let passwordIcon = UIImageView(frame: CGRect(x: 9, y: 9, width: 24, height: 24))
    
    let AD = UIApplication.shared.delegate as! AppDelegate
    
    let introArray = ["Good to see you", "Hello, world!", "You look beautiful today", "Howdy", "Good day", "Bonjour"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        rememberLoginSwitch.onTintColor = UIColor.green
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        let mainColor = AD.myThemeColor()
        let buttonColor = UIColor(red: 246/255, green: 175/255, blue: 41/255, alpha: 1)
        
        self.emailField.text = ""
        self.emailField.backgroundColor = UIColor.white
        self.emailField.layer.cornerRadius = 3
        self.emailField.placeholder = "Email"
        self.emailField.font = UIFont(name: themeFont, size: 16)
        
        emailIcon.image = UIImage(named: "mail.png")?.withRenderingMode(.alwaysTemplate)
        emailIcon.tintColor = mainColor
        emailIcon.contentMode = .scaleAspectFit
        let emailIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: 41))
        emailIconContainer.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        emailIconContainer.addSubview(emailIcon)
        
        self.emailField.leftViewMode = UITextFieldViewMode.always
        self.emailField.leftView = emailIconContainer
        
        self.passwordField.text = ""
        self.passwordField.backgroundColor = UIColor.white
        self.passwordField.layer.cornerRadius = 3
        self.passwordField.placeholder = "Password"
        self.passwordField.font = UIFont(name: themeFont, size: 16)
        
        passwordIcon.image = UIImage(named: "lock.png")?.withRenderingMode(.alwaysTemplate)
        passwordIcon.tintColor = mainColor
        passwordIcon.contentMode = .scaleAspectFit
        let passwordIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: 41))
        passwordIconContainer.backgroundColor = UIColor(white: 0.9, alpha: 1)
        passwordIconContainer.addSubview(passwordIcon)
        
        self.passwordField.leftViewMode = UITextFieldViewMode.always
        self.passwordField.leftView = passwordIconContainer
        
        self.loginButton.backgroundColor = buttonColor
        self.loginButton.layer.cornerRadius = 3
        self.loginButton.titleLabel?.font = UIFont(name: themeFontBold, size: 20)
        self.loginButton.setTitle("Login", for: [])
        self.loginButton.setTitleColor(UIColor.white, for: [])
        self.loginButton.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .highlighted)
        
        self.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        self.forgotButton.backgroundColor = UIColor.clear
        self.forgotButton.titleLabel?.font = UIFont(name: themeFont, size: 12)
        self.forgotButton.setTitle("Forgot password?", for: [])
        self.forgotButton.setTitleColor(UIColor.white, for: [])
        self.forgotButton.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .highlighted)
        
        self.createButton.backgroundColor = UIColor.clear
        self.createButton.titleLabel?.font = UIFont(name: themeFont, size: 12)
        self.createButton.setTitle("Create an account", for: [])
        self.createButton.setTitleColor(UIColor.white, for: [])
        self.createButton.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .highlighted)
        
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.font = UIFont(name: themeFontBold, size: 24)
        self.titleLabel.text = introArray[Int(arc4random_uniform(UInt32(introArray.count)))]
        
        self.subtitleLabel.textColor = UIColor.white
        self.subtitleLabel.font = UIFont(name: themeFont, size: 14)
        self.subtitleLabel.text = "Please login below"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults()
        
        if defaults.bool(forKey: "AUTO_LOGIN") {
            self.rememberLoginSwitch.isOn = true
            
            self.emailField.text = defaults.string(forKey: "USER_EMAIL")
            self.passwordField.text = defaults.string(forKey: "USER_PASSWORD")
            
            self.emailField.isHidden = true
            self.passwordField.isHidden = true
            
            login()
        } else {
            self.rememberLoginSwitch.isOn = false
            
            self.emailField.isHidden = false
            self.passwordField.isHidden = false
            
            self.emailField.placeholder = "Email"
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
        
        passwordIcon.tintColor = themeColor
        emailIcon.tintColor = themeColor
        
        self.titleLabel.text = introArray[Int(arc4random_uniform(UInt32(introArray.count)))]
    }
    
    func login() {
        dismissKeyboard()
        
        let overlay = waitScene(ofSize: self.view.frame.size)
        self.view.addSubview(overlay)
        
        self.loginButton.isEnabled = false
        
        let defaults = UserDefaults()
        defaults.set(self.rememberLoginSwitch.isOn, forKey: "AUTO_LOGIN")
        
        FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: {(user, error) in
            
            overlay.removeFromSuperview()
            self.loginButton.isEnabled = true
            self.passwordField.text = ""
            
            if user != nil {
                print("Logged in")
                
                self.performSegue(withIdentifier: "SegueToCurrentLocation", sender: self)
                
                self.emailField.text = ""
            } else {}
        })
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
