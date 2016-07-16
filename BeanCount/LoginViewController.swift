//
//  LoginViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/16/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")

        // Do any additional setup after loading the view.
        
        let mainColor = UIColor(red: 150/255, green: 211/255, blue: 41/255, alpha: 1)
        let buttonColor = UIColor(red: 246/255, green: 175/255, blue: 41/255, alpha: 1)
        
        let fontName = "Avenir-Book"
        let boldFont = "Avenir-Black"
        
        self.view.backgroundColor = mainColor
        
        self.usernameField.backgroundColor = UIColor.white()
        self.usernameField.layer.cornerRadius = 3;
        self.usernameField.placeholder = "Email Address";
        self.usernameField.font = UIFont(name: fontName, size: 16)
        
        
        let usernameIcon = UIImageView(frame: CGRect(x: 9, y: 9, width: 24, height: 24))
        usernameIcon.image = UIImage(named: "mail.png")
        let usernameIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: 41))
        usernameIconContainer.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        usernameIconContainer.addSubview(usernameIcon)
        
        self.usernameField.leftViewMode = UITextFieldViewMode.always
        self.usernameField.leftView = usernameIconContainer
        
        self.passwordField.backgroundColor = UIColor.white()
        self.passwordField.layer.cornerRadius = 3
        self.passwordField.placeholder = "Password"
        self.passwordField.font = UIFont(name: fontName, size: 16)
        
        let passwordIcon = UIImageView(frame: CGRect(x: 9, y: 9, width: 24, height: 24))
        passwordIcon.image = UIImage(named: "lock.png")
        let passwordIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: 41))
        passwordIconContainer.backgroundColor = UIColor(white: 0.9, alpha: 1)
        passwordIconContainer.addSubview(passwordIcon)
        
        self.passwordField.leftViewMode = UITextFieldViewMode.always
        self.passwordField.leftView = passwordIconContainer
        
        self.loginButton.backgroundColor = buttonColor
        self.loginButton.layer.cornerRadius = 3
        self.loginButton.titleLabel?.font = UIFont(name: boldFont, size: 20)
        self.loginButton.setTitle("Sign up here", for: [])
        self.loginButton.setTitleColor(UIColor.white(), for: [])
        self.loginButton.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .highlighted)
        
        self.forgotButton.backgroundColor = UIColor.clear()
        self.forgotButton.titleLabel?.font = UIFont(name: fontName, size: 12)
        self.forgotButton.setTitle("Forgot password?", for: [])
        self.forgotButton.setTitleColor(buttonColor, for: [])
        self.forgotButton.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .highlighted)
        
        self.titleLabel.textColor = UIColor.white()
        self.titleLabel.font = UIFont(name: boldFont, size: 24)
        self.titleLabel.text = "Good to see you"
        
        self.subtitleLabel.textColor = UIColor.white()
        self.subtitleLabel.font = UIFont(name: fontName, size: 14)
        self.subtitleLabel.text = "Please login below"
        
        
//        
//        self.titleLabel.textColor =  [UIColor whiteColor];
//        self.titleLabel.font =  [UIFont fontWithName:boldFontName size:24.0f];
//        self.titleLabel.text = @"GOOD TO SEE YOU";
//        
//        self.subTitleLabel.textColor =  [UIColor whiteColor];
//        self.subTitleLabel.font =  [UIFont fontWithName:fontName size:14.0f];
//        self.subTitleLabel.text = @"Welcome back, please login below";
//        [self.forgotButton addTarget:self action:@selector(toggleNav:) forControlEvents:UIControlEventTouchUpInside];
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
