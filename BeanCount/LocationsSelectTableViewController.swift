//
//  LocationsSelectTableViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/21/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit
import Firebase

class LocationsSelectTableViewController: UITableViewController {
    
    let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    let AD = UIApplication.shared().delegate as! AppDelegate
    let db = FIRDatabase.database().reference()
    
    let names = ["Michigan", "New Jersey", "Maryland"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.backgroundColor = AD.myThemeColor()
        self.tableView.separatorColor = UIColor.clear()
        self.tableView.sectionIndexColor = UIColor.clear()
        
        
        // Dont need following code because theres no pull to refresh
        // Using firebase means database is live updating
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
//        self.refreshControl?.tintColor = UIColor.white()
//        self.refreshControl?.beginRefreshing()
//        self.tableView.setContentOffset(CGPoint(x: 0, y: self.refreshControl!.frame.size.height), animated: false)
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func loadData() {
        print("Reload")
        
        activity.center = self.view.center
        activity.startAnimating()
        
        self.tableView.backgroundView = activity
        
        db.child("locations").queryOrdered(byChild: "city").observe(.value, with: { (snapshot) in
            if snapshot.value == nil || snapshot.value is NSNull {
                // Null. Tell user to add a new location
                return
            }
            
            for value in snapshot.children {
                print(value)
            }
            
//            print(snapshot.children)
        })
        
//        db.child("locations").queryOrdered(byChild: "name").observe(.value) { (snapshot) in
//            if snapshot == nil || snapshot is NSNull {
//                // Null. Tell user to add a new location
//                return
//            }
//            
//        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
        return names[section]
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textColor = UIColor.white()
        header.backgroundView?.backgroundColor = UIColor.clear()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableCell", for: indexPath) as! LocationTableViewCell
        
        cell.mainView.layer.cornerRadius = 4
        cell.mainView.backgroundColor = UIColor.white()
        cell.backgroundColor = AD.myThemeColor()

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
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
