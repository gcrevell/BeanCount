//
//  CreateAccountViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/16/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var themeSelect: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    let emailIcon = UIImageView(frame: CGRect(x: 9, y: 9, width: 24, height: 24))
    let usernameIcon = UIImageView(frame: CGRect(x: 9, y: 9, width: 24, height: 24))
    let passwordIcon = UIImageView(frame: CGRect(x: 9, y: 9, width: 24, height: 24))
    let confirmPasswordIcon = UIImageView(frame: CGRect(x: 9, y: 9, width: 24, height: 24))
    
    let AD = UIApplication.shared().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        let boldFontName = "Avenir-Black"
        let fontName = "Avenir-Book"
        
        let onColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1)
        let divider = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
        let mainColor = AD.myThemeColor()
        let buttonColor = UIColor(red: 246/255, green: 175/255, blue: 41/255, alpha: 1)
        
        updateTheme()
        
        style(segmentedControl: themeSelect, fontName: boldFontName, selectedColor: onColor, unselectedColor: UIColor.white(), dividerColor: divider)
        
        themeSelect.addTarget(self, action: #selector(themeChanged), for: .valueChanged)
        themeSelect.selectedSegmentIndex = AD.selectedTheme != nil ? AD.selectedTheme!.rawValue - 1 : 0
        
        // Email text field setup
        self.emailTextField.text = ""
        self.emailTextField.backgroundColor = UIColor.white()
        self.emailTextField.layer.cornerRadius = 3;
        self.emailTextField.placeholder = "Email";
        self.emailTextField.font = UIFont(name: fontName, size: 16)
        
        emailIcon.image = UIImage(named: "mail.png")?.withRenderingMode(.alwaysTemplate)
        emailIcon.tintColor = mainColor
        let emailIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: 41))
        emailIconContainer.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        emailIconContainer.addSubview(emailIcon)
        
        self.emailTextField.leftViewMode = UITextFieldViewMode.always
        self.emailTextField.leftView = emailIconContainer
        
        // Username text field setup
        self.usernameTextField.text = ""
        self.usernameTextField.backgroundColor = UIColor.white()
        self.usernameTextField.layer.cornerRadius = 3;
        self.usernameTextField.placeholder = "Username";
        self.usernameTextField.font = UIFont(name: fontName, size: 16)
        
        usernameIcon.image = UIImage(named: "username.png")?.withRenderingMode(.alwaysTemplate)
        usernameIcon.tintColor = mainColor
        let usernameIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: 41))
        usernameIconContainer.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        usernameIconContainer.addSubview(usernameIcon)
        
        self.usernameTextField.leftViewMode = UITextFieldViewMode.always
        self.usernameTextField.leftView = usernameIconContainer
        
        // Password text field setup
        self.passwordTextField.text = ""
        self.passwordTextField.backgroundColor = UIColor.white()
        self.passwordTextField.layer.cornerRadius = 3;
        self.passwordTextField.placeholder = "Password";
        self.passwordTextField.font = UIFont(name: fontName, size: 16)
        
        passwordIcon.image = UIImage(named: "lock.png")?.withRenderingMode(.alwaysTemplate)
        passwordIcon.tintColor = mainColor
        let passwordIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: 41))
        passwordIconContainer.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        passwordIconContainer.addSubview(passwordIcon)
        
        self.passwordTextField.leftViewMode = UITextFieldViewMode.always
        self.passwordTextField.leftView = passwordIconContainer
        
        // Confirm password text field setup
        self.confirmPasswordTextField.text = ""
        self.confirmPasswordTextField.backgroundColor = UIColor.white()
        self.confirmPasswordTextField.layer.cornerRadius = 3;
        self.confirmPasswordTextField.placeholder = "Confirm password";
        self.confirmPasswordTextField.font = UIFont(name: fontName, size: 16)
        
        confirmPasswordIcon.image = UIImage(named: "lock.png")?.withRenderingMode(.alwaysTemplate)
        confirmPasswordIcon.tintColor = mainColor
        let confirmPasswordIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: 41))
        confirmPasswordIconContainer.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        confirmPasswordIconContainer.addSubview(confirmPasswordIcon)
        
        self.confirmPasswordTextField.leftViewMode = UITextFieldViewMode.always
        self.confirmPasswordTextField.leftView = confirmPasswordIconContainer
        
        // Setup create account button
        self.createButton.backgroundColor = buttonColor
        self.createButton.layer.cornerRadius = 3
        self.createButton.titleLabel?.font = UIFont(name: boldFontName, size: 20)
        self.createButton.setTitle("Create!", for: [])
        self.createButton.setTitleColor(UIColor.white(), for: [])
        self.createButton.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .highlighted)
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
        
        emailIcon.tintColor = themeColor
        usernameIcon.tintColor = themeColor
        passwordIcon.tintColor = themeColor
        confirmPasswordIcon.tintColor = themeColor
    }
    
    func dismissKeyboard() {
        self.view.endEditing(false)
    }

    @IBAction func createButtonPressed(_ sender: AnyObject) {
        // Create account
        // Check email is correct email
        // Check it doesnt exist in DB
        // Check username is unique
        // Check passwords are same, and follow proper rules
        
        // Upload info to Firebase
        
        // Save selected theme
        AD.selectedTheme = Theme(rawValue: themeSelect.selectedSegmentIndex + 1)
        let defaults = UserDefaults()
        defaults.set(themeSelect.selectedSegmentIndex + 1, forKey: "THEME")
        defaults.synchronize()
        
        
        // Segue back to login view
        performSegue(withIdentifier: "UnwindToLoginView", sender: self)
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
