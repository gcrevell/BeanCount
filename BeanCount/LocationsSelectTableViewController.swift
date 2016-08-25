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

class LocationsSelectTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var selected: IndexPath?
    
    let AD = UIApplication.shared.delegate as! AppDelegate
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.backgroundColor = AD.myThemeColor()
        self.tableView.separatorStyle = .none
        self.tableView.sectionIndexColor = UIColor.clear
        
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        
//        loadData()
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
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return 0
//    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textColor = UIColor.white
        header.backgroundView?.backgroundColor = AD.myThemeColor()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableCell", for: indexPath) as! LocationTableViewCell
        
//        let location = recievedLocations[sortedStates[indexPath.section]]![indexPath.row]
//        
//        cell.location = location
//        
//        cell.clipsToBounds = true
//        
//        cell.mainView.layer.cornerRadius = 4
//        cell.mainView.backgroundColor = UIColor.white
//        cell.mainView.clipsToBounds = true
//        cell.backgroundColor = UIColor.clear
//        
//        cell.mapView.centerCoordinate = location.coordinate
//        cell.mapView.isUserInteractionEnabled = false
//        
//        cell.mapView.removeAnnotations(cell.mapView.annotations)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location.coordinate
//        cell.mapView.addAnnotation(annotation)
////        cell.mapView.center = cell.mainView.center
//        
//        let span = MKCoordinateSpan(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
//        let region = MKCoordinateRegion(center: location.coordinate, span: span)
//        
//        cell.mapView.setRegion(region, animated: false)
//        
//        cell.mainTitle.text = location.name
//        cell.subTitle.text = "\(location.city), \(location.state)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath == selected {
            AD.selectedLocation = (tableView.cellForRow(at: indexPath) as! LocationTableViewCell).location
            
            self.performSegue(withIdentifier: "UnwindToSettingsView", sender: self)
            return
        }
        
//        self.AD.selectedLocation = recievedLocations[sortedStates[indexPath.section]]![indexPath.row]
//        
//        var oldCell: LocationTableViewCell?
//        
//        if let current = selected {
//            selected = nil
//            oldCell = tableView.cellForRow(at: current) as? LocationTableViewCell
//        }
//        
//        selected = indexPath
//        
//        let currentCell = tableView.cellForRow(at: indexPath) as! LocationTableViewCell
//        
//        tableView.beginUpdates()
//        oldCell?.mapView.frame = CGRect(x: 0,
//                                        y: 0,
//                                        width: tableView.frame.width,
//                                        height: tableView.frame.width)
//        
//        UIView.animate(withDuration: 0.8,
//                       delay: 0,
//                       usingSpringWithDamping: 0.7,
//                       initialSpringVelocity: 0.3,
//                       options: .beginFromCurrentState,
//                       animations: {
//            oldCell?.mainView.frame.size.height = 90
//            if oldCell != nil {
//                print("Here")
//                let x = oldCell!.mainView.frame.width - oldCell!.mainView.frame.height
//                oldCell!.mapView.frame = CGRect(x: x,
//                                                y: 0,
//                                                width: oldCell!.mainView.frame.height,
//                                                height: oldCell!.mainView.frame.height)
//            }
//            currentCell.mapView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.width)
//            
//            tableView.endUpdates()
//            }, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selected {
            return tableView.frame.width
        }
        
        return 100
    }
    
    // MARK: - Search bar delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text)
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
