//
//  AddStudentViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/15/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit
import Firebase

class AddStudentViewController: UIViewController {
    
    var count = 0
    @IBOutlet weak var nameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        let db = FIRDatabase.database().reference()
        
        db.child("students").child(nameTextField.text!).setValue(["count" : count, "active" : true])
        
        unwind()
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        unwind()
    }
    
    func unwind() {
        performSegueWithIdentifier("ReturnSegueToHome", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
