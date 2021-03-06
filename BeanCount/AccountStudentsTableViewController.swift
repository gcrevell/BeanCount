//
//  AccountStudentsTableViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/21/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit
import Firebase

class AccountStudentsTableViewController: UITableViewController {
    
    var show = false
    var students:[[String : AnyObject]] = []
    
//    var db:FIRDatabaseReference!
//    var studentsDB: FIRDatabaseReference!
    let AD = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        db = FIRDatabase.database().reference()
//        studentsDB = db.child("locations").child(AD.selectedLocation!.UID).child("students")
        
        tableView.backgroundColor = AD.myThemeColor()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 237/255,
                                                                        green: 237/255,
                                                                        blue: 237/255,
                                                                        alpha: 0.7)
        
        tableView.separatorStyle = .none
        tableView.allowsSelectionDuringEditing = true
        
        if AD.selectedLocation == nil {
            let label = UILabel()
            label.text = "Please select a location in settings."
            label.numberOfLines = 0
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.font = UIFont(name: themeFontBold,
                                size: 17)
            
            tableView.backgroundView = label
            return
        }
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem?.action = #selector(startEditing)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.backgroundColor = AD.myThemeColor()
    }
    
    func startEditing() {
        self.tableView.setEditing(true,
                                  animated: true)
        
        self.navigationItem.rightBarButtonItem = nil
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .done,
                                                                   target: self,
                                                                   action: #selector(endEditing)),
                                                   UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                                   target: nil,
                                                                   action: nil),
                                                   UIBarButtonItem(barButtonSystemItem: .add,
                                                                   target: self,
                                                                   action: #selector(addStudent)),
                                                   UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                                   target: nil,
                                                                   action: nil)]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEditing))
    }
    
    func endEditing() {
        // Save user data
//        for var student in students {
//            let uid = student.removeValue(forKey: "UID") as! String
//            studentsDB.child(uid).setValue(student)
//        }
        
        cancelEditing()
    }
    
    func cancelEditing() {
        self.navigationItem.rightBarButtonItems = nil
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem?.action = #selector(startEditing)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsButtonPressed(_:)))
        
        self.reload()
        self.tableView.reloadData()
    }
    
//    func toggleEditing() {
//        
//        if self.tableView.isEditing {
//            // Currently editing. Stop
//        } else {
//            // Not editing. Start
//            self.tableView.setEditing(true,
//                                      animated: true)
//            
//            self.navigationItem.rightBarButtonItem = nil
//            
//            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .done,
//                                                                       target: self,
//                                                                       action: #selector(toggleEditing)),
//                                                       UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
//                                                                       target: nil,
//                                                                       action: nil),
//                                                       UIBarButtonItem(barButtonSystemItem: .add,
//                                                                       target: self,
//                                                                       action: #selector(addStudent)),
//                                                       UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
//                                                                       target: nil,
//                                                                       action: nil)]
//            
//        }
//        
//    }
    
    func addStudent() {
        performSegue(withIdentifier: "SegueToAddStudent", sender: self)
    }
    
    @IBAction func settingsButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "SegueToSettingsView", sender: self)
    }
    
    func reload() {
//        studentsDB.queryOrdered(byChild: "count").observeSingleEvent(of: .value, with: {(snapshot) in
//            self.students = []
//            for child in snapshot.children {
//                let snap = child as! FIRDataSnapshot
//                
//                let name = snap.key
//                print(name)  // Gets name
//                
//                var values = snap.value as! [String : AnyObject]
//                print(values)
//                
//                values["UID"] = name as AnyObject
//
//                self.students.append(values)
//                
//                self.tableView.reloadData()
//            }
//        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableCell", for: indexPath) as! StudentTableViewCell
        
        // Configure the cell...
        
        cell.clipsToBounds = true
        cell.backgroundColor = UIColor.clear
        
        cell.mainView.clipsToBounds = true
        cell.mainView.backgroundColor = UIColor.white
        cell.mainView.layer.cornerRadius = 4
        
        cell.mainLabel.text = self.students[indexPath.row]["name"] as? String
        cell.subLabel.text = "\((self.students[indexPath.row]["count"] as! Int) + 1)"
        cell.radialView.active = self.students[indexPath.row]["active"] as! Bool
        print(cell.radialView.active)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView.isEditing {
            return indexPath
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let cell = tableView.cellForRow(at: indexPath) as! StudentTableViewCell
        
        cell.radialView.active = !cell.radialView.active
        
        self.students[indexPath.row]["active"] = !((self.students[indexPath.row]["active"]) as! Bool) as AnyObject
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    @IBAction func unwindToStudentsTableView(segue: UIStoryboardSegue) {
        endEditing()
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
