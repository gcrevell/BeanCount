//
//  StudentTagsTableViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/3/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

class StudentTagsTableViewController: UITableViewController {
    
    var tags:[UITextField] = []
    
    let AD = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.backgroundColor = AD.myThemeColor()
        tableView.separatorStyle = .none
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
        return tags.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == tags.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTagCell", for: indexPath) as! AddTagTableViewCell
            
            cell.selectionStyle = .none
            
            cell.backgroundColor = UIColor.clear
            
            let mainView = UIView(frame: CGRect(x: 4,
                                                y: 4,
                                                width: cell.frame.width - 8,
                                                height: cell.frame.height - 8))
            mainView.layer.cornerRadius = 3
            mainView.backgroundColor = UIColor(white: 1, alpha: 0.5)
            mainView.clipsToBounds = true
            
            let imageView = UIImageView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: mainView.frame.height * 0.7,
                                                      height: mainView.frame.height * 0.7))
            imageView.image = UIImage(named: "plus.png")?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = .darkGray
            imageView.center = mainView.frame.centerPoint
            
            mainView.addSubview(imageView)
            cell.addSubview(mainView)
            
            cell.mainView = mainView
            cell.plusImageView = imageView
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTagCell", for: indexPath) as! StudentTagTableViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.mainTextField.layer.cornerRadius = 3
        cell.mainTextField.backgroundColor = .white
        
        cell.mainTextField.text = tags[indexPath.row].text
        tags[indexPath.row] = cell.mainTextField
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == tags.count {
            let addCell = tableView.cellForRow(at: indexPath) as! AddTagTableViewCell
            
            UIView.animate(withDuration: 1.5,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.3,
                           options: .curveEaseInOut,
                           animations: {
                            addCell.mainView.frame.size.width = addCell.mainView.frame.height
                            addCell.mainView.center = addCell.frame.centerPoint
                            addCell.mainView.layer.cornerRadius = addCell.mainView.frame.height / 2
                            addCell.plusImageView.center = addCell.mainView.frame.centerPoint
                }, completion: {(completed) in
//                    addCell.plusImageView.rem
                    UIView.animate(withDuration: 1.5,
                                   delay: 0.2,
                                   usingSpringWithDamping: 0.7,
                                   initialSpringVelocity: 0.3,
                                   options: .beginFromCurrentState,
                                   animations: { 
                                    addCell.plusImageView.removeFromSuperview()
                                    addCell.mainView.backgroundColor = UIColor.white
                                    addCell.mainView.frame.size.width = addCell.frame.width - 8
                                    addCell.mainView.frame.origin.x = 4
                                    addCell.mainView.layer.cornerRadius = 3
                        },
                                   completion: { (completed) in
                                    self.tags.append(UITextField())
                                    addCell.removeAllSubviews()
                                    tableView.reloadData()
                                    
                    })
            })
        }
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
