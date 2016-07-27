//
//  LocationsSelectTableViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/21/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class LocationsSelectTableViewController: UITableViewController {
    
    var selected: IndexPath?
    
    let AD = UIApplication.shared().delegate as! AppDelegate
    let db = FIRDatabase.database().reference()
    
    var recievedLocations: [String : [Location]] = [:]
    var sortedStates: [String] = []

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
        
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        activity.center = self.view.center
        activity.startAnimating()
        
        self.tableView.backgroundView = activity
        
        db.child("locations").queryOrdered(byChild: "city").observe(.value, with: { (snapshot) in
            if snapshot.value == nil || snapshot.value is NSNull {
                // Null. Tell user to add a new location
                return
            }
            
            for child in snapshot.children {
                print(child)
                let uid = (child as! FIRDataSnapshot).key
                let values = (child as! FIRDataSnapshot).value as! [String : AnyObject]
                
                let state = values["state"] as! String
                
                let location = Location(latitude: values["latitude"] as! Double,
                                        longitude: values["longitude"] as! Double,
                                        name: values["locationName"] as! String,
                                        UID: uid,
                                        city: values["city"] as! String,
                                        state: state)
                
                if self.recievedLocations[state] != nil {
                    // State exists
                    if !self.recievedLocations[state]!.contains({ (loc) -> Bool in
                        return loc.UID == uid
                    }) {
                        // UID does not exist. This location wasn't already in the dic
                        self.recievedLocations[state]!.append(location)
                    }
                } else {
                    // State doesn't exist yet
                    self.recievedLocations[state] = [location]
                }
                print(values)
            }
            
            print(self.recievedLocations)
            print(self.recievedLocations.count)
            
            self.sortedStates = Array(self.recievedLocations.keys).sorted()
            
            print(self.sortedStates)
            
            for state in self.sortedStates {
                self.recievedLocations[state] = self.recievedLocations[state]?.sorted(isOrderedBefore: { (left, right) -> Bool in
                    left.name < right.name
                })
            }
            
            self.tableView.backgroundView = nil
            
            self.tableView.reloadData()
            
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
        return self.sortedStates.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedStates[section]
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textColor = UIColor.white()
        header.backgroundView?.backgroundColor = AD.myThemeColor()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recievedLocations[sortedStates[section]]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableCell", for: indexPath) as! LocationTableViewCell
        
        cell.clipsToBounds = true
        
        if indexPath == selected {
            cell.labelsView.backgroundColor = UIColor(colorLiteralRed: 160/255, green: 160/255, blue: 160/255, alpha: 0.55)
        } else {
            cell.labelsView.backgroundColor = UIColor.white()
        }
        
        cell.mainView.layer.cornerRadius = 4
        cell.mainView.backgroundColor = UIColor.white()
        cell.mainView.clipsToBounds = true
        cell.backgroundColor = AD.myThemeColor()
        
        let location = recievedLocations[sortedStates[indexPath.section]]![indexPath.row]
        
        cell.mapView.centerCoordinate = location.coordinate
        cell.mapView.isUserInteractionEnabled = false
        
        cell.mapView.removeAnnotations(cell.mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        cell.mapView.addAnnotation(annotation)
        cell.mapView.center = cell.mainView.center
        
        let span = MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        
        cell.mapView.setRegion(region, animated: false)
        
        cell.mainTitle.text = location.name
        cell.subTitle.text = "\(location.city), \(location.state)"

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        self.AD.selectedLocation = recievedLocations[sortedStates[indexPath.section]]![indexPath.row]
        
        if let current = selected {
            selected = nil
//            tableView.reloadRows(at: [current], with: .none)
            (self.tableView(tableView, cellForRowAt: current) as! LocationTableViewCell).labelsView.backgroundColor = UIColor.white()
        }
        
        selected = indexPath
        tableView.reloadRows(at: [indexPath], with: .none)
//        tableView.reloadData()
        
        // Save selected location to UserDefaults...
        
//        self.performSegue(withIdentifier: "UnwindToSettingsView", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selected {
            return tableView.frame.width
        }
        
        return 100
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
