//
//  CreateAccountViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/16/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var themeSelect: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    let AD = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        return

        // Do any additional setup after loading the view.
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(dismissKeyboard)))
        
        print("HERE!!!!!! view loaded")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func themeChanged() {
        return
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
        
        // TODO: Implement checks
        // Create account
        // Check email is correct email
        // Check it doesnt exist in DB
        // Check username is unique
        // Check passwords are same, and follow proper rules
        
        // Deactivate button and set image to activity indicator
        self.createButton.isEnabled = false
        let activity = UIActivityIndicatorView()
        activity.startAnimating()
        activity.center = CGPoint(x: self.createButton.frame.size.width/2, y: self.createButton.frame.size.height/2)
        self.createButton.addSubview(activity)
        self.createButton.setTitle("", for: [])
        
        Database().createAccount(username: self.usernameTextField.text!,
                                 email: self.emailTextField.text!,
                                 password: self.passwordTextField.text!)
        { (data, response, error) in
            // Check user creation was successful
            
            // If successful, segue back
            self.performSegue(withIdentifier: "UnwindToLoginView", sender: self)
            
            // Else, reset
        }
        
        // Upload info to Firebase
//        print(passwordTextField.text!)
//        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
//            if user != nil {
//                let changeRequest = user?.profileChangeRequest()
//                
//                changeRequest?.displayName = self.usernameTextField.text!
//                changeRequest?.commitChanges(completion: { (error) in })
//                
//                let db = FIRDatabase.database().reference()
//                db.child("users").child(user!.uid).setValue(["username" : self.usernameTextField.text!,
//                                                             "theme" : self.themeSelect.selectedSegmentIndex + 1])
//                db.child("usernames").child(self.usernameTextField.text!).setValue(user!.uid)
//                
//                // Segue back to login view
//                self.performSegue(withIdentifier: "UnwindToLoginView", sender: self)
//            } else if error != nil {
//                // Unable to make the user. Maybe email exists?
//                // TODO: Inform user about fail
//                
//                print("AN ERROR OCCURED")
//                print(error)
//                print(user)
//                
//                var message = ""
//                
////                switch error!.code {
////                case FIRAuthErrorCode.errorCodeInvalidEmail.rawValue:
////                    print("Invalid email")
////                    message = "The email address entered is invalid."
////                    
////                case FIRAuthErrorCode.errorCodeEmailAlreadyInUse.rawValue:
////                    print("Email in use")
////                    message = "That email address is already registered. Forgot your email? Recover it from the login screen."
////                    
////                case FIRAuthErrorCode.errorCodeWeakPassword.rawValue:
////                    print("Password game is weak")
////                    message = "The password entered is too weak. Please try another."
////                    
////                case FIRAuthErrorCode.errorCodeNetworkError.rawValue:
////                    print("Network error")
////                    message = "There was a network error. Please check your connection and try again."
////                    
////                default:
////                    print("Not there")
////                }
//                
//                let alert = UIAlertController(title: "Failure", message: message, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//                
//                self.createButton.isEnabled = true
//                activity.removeFromSuperview()
//                self.createButton.setTitle("Create!", for: [])
//            }
//        })
        
        // Save selected theme locally
        AD.selectedTheme = Theme(rawValue: themeSelect.selectedSegmentIndex + 1)
//        let defaults = UserDefaults()
//        defaults.set(themeSelect.selectedSegmentIndex + 1, forKey: "THEME")
//        defaults.synchronize()
    }
    
    func checkUsernameUnique() {
        return
        let db = FIRDatabase.database().reference()
        
        let text = self.usernameTextField.text!
        
        if text == "" || text.contains(".") || text.contains("#") || text.contains("$") || text.contains("[") || text.contains("]") {
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 41, height: 41))
            imageView.image = UIImage(named: "red x.png")
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            rightView.addSubview(imageView)
            imageView.center = CGPoint(x: 20, y: 20)
            self.usernameTextField.rightView = rightView
            
            return
        }
        
        // Set right image in text field to be a loading icon
        let loading = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 41, height: 41))
        self.usernameTextField.rightViewMode = .always
        self.usernameTextField.rightView = loading
        loading.startAnimating()
        loading.activityIndicatorViewStyle = .gray
        
        db.child("usernames").child(self.usernameTextField.text!).observeSingleEvent(of: .value, with: {(snapshot) in
            if text == self.usernameTextField.text! {
                // Text in text field is unchanged
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                if snapshot.exists() {
                    // Value exists. Username is taken
                    // Show red x
                    imageView.image = UIImage(named: "red x.png")
                } else {
                    // Value doesnt exist. Username is avaiable
                    // Show green check
                    imageView.image = UIImage(named: "green check.png")
                }
                let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                rightView.addSubview(imageView)
                imageView.center = CGPoint(x: 20, y: 20)
                self.usernameTextField.rightView = rightView
            }
        })
        
//        db.child("users").observeSingleEvent(of: .value, with: {(snapshot) in
//            let name = (snapshot.value as! [String : String])["wowza7125"]!
//            db.child("users").queryEqual(toValue: name).observeSingleEvent(of: .value, with: {(snapshot) in
//                print(snapshot)
//            })
//        })
        
//        db.child("users").queryEqual(toValue: usernameTextField.text!).observeSingleEvent(of: .value, with: {(snapshot) in
//            print(snapshot)
//            if snapshot.exists() {
//                print("HEY IM HERE!!!!!!")
//                print()
//                print()
//                print()
//                print()
//                print()
//                print()
//                print()
//                print()
//                print()
//            } else {
//                print("Not there :(")
//            }
//        })
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
