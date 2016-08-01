//
//  StudentsTableViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/14/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

class Student {
    let name: String
    let count: Int
    var active: Bool
    
    init(name: String, count: Int, active: Bool) {
        self.name = name
        self.count = count
        self.active = active
    }
}

import UIKit
import Firebase

class StudentsTableViewController: UITableViewController {
    
    var students: [Student] = []
    var db:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = FIRDatabase.database().reference()
        students = []
        print("HER")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //        db.child("students").child("Volt A").setValue(["count" : 0, "active" : true])
        //        db.child("students").child("Voltage A").setValue(["count" : 2, "active" : false])
        //        db.child("students").child("Voltmeter A").setValue(["count" : 1, "active" : true])
        
        db.child("students").queryOrdered(byChild: "count").observe(.value, with: { (snapshot) in
            print("STARTING")
            for child in snapshot.children {
                let snap = child as! FIRDataSnapshot
                
                let name = snap.key
                print(name)  // Gets name
                
                let values = snap.value as! [String : Int]
                print(values)
                
                if self.students.count > values["count"] {
                    self.students[values["count"]!] = Student(name: name, count: values["count"]!, active: values["active"]! != 0)
                } else {
                    
                    self.students.append(Student(name: name, count: values["count"]!, active: values["active"]! != 0))
                }
                
                self.tableView.reloadData()
            }
        })
        
        //        db.queryOrderedByChild("count").observeSingleEventOfType(.Value, withBlock:  { (snapshot) in
        //            print(snapshot)
        //        })
        //
        //        let query = (db.child("student"))
        //        query.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        //            print(snapshot)
        //        })
        
        
        
        //        db.child("students").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        //            // Get user value
        //            let students = snapshot.value// as! [String]
        //
        //            print(students)
        //
        //            // ...
        //        }) { (error) in
        //            print(error.localizedDescription)
        //        }
        
        //        let query = (db.child("student")).queryOrderedByChild("count")
        
        //        print("QUERY")
        //        print(query)
        
        navigationController?.hidesBarsOnSwipe = true
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! StudentTableViewCell
        let student = students[(indexPath as NSIndexPath).row]
        
        cell.countLabel.text = "\(student.count + 1)"
        cell.active = student.active
        cell.nameLabel.text = student.name
        
        cell.update()
        
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[(indexPath as NSIndexPath).row]
        
        student.active = !student.active
        
        db.child("students").child(student.name).setValue(["active" : student.active, "count" : student.count])
        
        tableView.reloadData()
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "SegueToAddStudentView" {
            let dest = segue.destinationViewController as! AddStudentViewController
            
            dest.count = students.count
        }
    }
    
    @IBAction func returnToList(_ segue: UIStoryboardSegue) {
        
    }
    
}
