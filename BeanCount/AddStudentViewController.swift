//
//  AddStudentViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/2/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddStudentViewController: UIViewController, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var studentNameField: RoundedTextField!
    var tagsTableView: StudentTagsTableViewController?
    var count: Int?
    
    let AD = UIApplication.shared.delegate as! AppDelegate
    let db = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let mainColor = AD.myThemeColor()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                target: self,
                                                                action: #selector(finish))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                 target: self,
                                                                 action: #selector(done))
        
        self.view.backgroundColor = mainColor
        
        self.studentNameField.placeholder = "Name"
        self.studentNameField.tintColor = mainColor
        self.studentNameField.autocapitalizationType = .words
        self.studentNameField.autocorrectionType = .no
        self.studentNameField.delegate = self
        self.studentNameField.returnKeyType = .default
        self.studentNameField.keyboardType = .default
        
        self.studentNameField.leftImage = UIImage(named: "id card.png")?.withRenderingMode(.alwaysTemplate)
        
        let query = db.child("locations").child(AD.selectedLocation!.UID).child("students").queryOrdered(byChild: "count")
        
        query.queryLimited(toLast: 1).observe(.value, with: {(snapshot) in
            if snapshot.value is NSNull || snapshot.value == nil {
                self.count = 0
                return
            }
            
            let values = (snapshot.value as! [String : AnyObject]).first?.value as! [String : AnyObject]
            
            print(values)
            
            self.count = (values["count"] as! Int) + 1
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func done() {
        // Create user UID
        let uid = NSUUID().uuidString
        
        var values: [String : AnyObject] = [:]
        
        // Get student name and all data
        if let tableView = tagsTableView {
            values = tableView.getTags()
        }
        values["name"] = self.studentNameField.text!
        if count == nil {
            return
        }
        values["count"] = count!
        values["active"] = true
        print(values)
        
        // Save user into firebase, under location's students
        let saveLocation = db.child("locations").child(AD.selectedLocation!.UID).child("students").child(uid)
        
        saveLocation.setValue(values,
                              withCompletionBlock: {(error, reference) in
            // Segue back after saving
            self.finish()
        })
    }
    
    func finish() {
        performSegue(withIdentifier: "UnwindToStudentsTableView", sender: self)
    }
    
    func labelPressed() {
        let labels = InformationLabelTableViewController()
        
        labels.modalPresentationStyle = .popover
        labels.preferredContentSize = CGSize(width: 200, height: 400)
        
        let popover = labels.popoverPresentationController
        popover?.permittedArrowDirections = .any
        popover?.delegate = self
        popover?.sourceView = self.view
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LoadTableView" {
            // Set global table view to the destination
            tagsTableView = segue.destination as? StudentTagsTableViewController
        }
    }

}
