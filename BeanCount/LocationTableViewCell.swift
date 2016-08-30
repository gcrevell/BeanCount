//
//  LocationTableViewCell.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/21/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit
import MapKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var labelsView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapViewAspectConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    var location: Location!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func expandMap(_ animated: Bool, tableView: UITableView) {
        UIView.animate(withDuration: animated ? 0.8 : 0,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.3,
                       options: .beginFromCurrentState,
                       animations: {
                        self.mapView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width)
//                        self.mainView.frame.size.height = self.mainView.frame.width
                        tableView.endUpdates()
            }, completion: nil)
    }
    
    func compressMap(_ animated: Bool, tableView: UITableView) {
        self.mapView.frame = CGRect(x: 0,
                                        y: 0,
                                        width: self.frame.width,
                                        height: self.frame.width)
        
        UIView.animate(withDuration: animated ? 0.8 : 0,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.3,
                       options: .beginFromCurrentState,
                       animations: {
                        self.mainView.frame.size.height = 90
//                        if oldCell != nil {
//                            print("Here")
                            let x = self.mainView.frame.width - self.mainView.frame.height
                            self.mapView.frame = CGRect(x: x,
                                                            y: 0,
                                                            width: self.mainView.frame.height * 1.5,
                                                            height: self.mainView.frame.height)
//                        }
                        
//                        tableView.endUpdates()
            }, completion: nil)
    }

}
