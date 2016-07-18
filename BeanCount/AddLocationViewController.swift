//
//  AddLocationViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/17/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationNameTextField: UITextField!
    
    let locationIDIcon = UIImageView(frame: CGRect(x: 9, y: 9, width: 24, height: 24))
    @IBOutlet weak var locationPickerView: UIView!
    @IBOutlet weak var locationIconView: UIImageView!
    @IBOutlet weak var locationTextLabel: UILabel!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    let AD = UIApplication.shared().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let fontName = "Avenir-Book"
        let mainColor = AD.myThemeColor()
        
        updateTheme()
        
        self.locationNameTextField.text = ""
        self.locationNameTextField.backgroundColor = UIColor.white()
        self.locationNameTextField.layer.cornerRadius = 3
        self.locationNameTextField.placeholder = "Enter a name for this location"
        self.locationNameTextField.font = UIFont(name: fontName, size: 16)
        
        locationIDIcon.image = UIImage(named: "id card.png")?.withRenderingMode(.alwaysTemplate)
        locationIDIcon.tintColor = mainColor
        locationIDIcon.contentMode = .scaleAspectFit
        let locationIDIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: 41))
        locationIDIconContainer.backgroundColor = UIColor(white: 0.9, alpha: 1)
        locationIDIconContainer.addSubview(locationIDIcon)
        
        self.locationNameTextField.leftViewMode = .always
        self.locationNameTextField.leftView = locationIDIconContainer
        
        // Setup location view
        self.locationPickerView.clipsToBounds = true
        self.locationPickerView.layer.cornerRadius = 3
        self.locationPickerView.backgroundColor = UIColor.white()
        
        self.locationIconView.image = UIImage(named: "location.png")?.withRenderingMode(.alwaysTemplate)
        self.locationIconView.contentMode = .scaleAspectFit
        self.locationIconView.tintColor = mainColor
        self.locationIconView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        //        self.locationNameTextField.placehold
        
        self.locationTextLabel.text = "Choose a location"
        self.locationTextLabel.textColor = UIColor(red: 199/255, green: 199/255, blue: 205/255, alpha: 1)
        self.locationTextLabel.font = UIFont(name: fontName, size: 16)
        
        self.locationPickerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandLocationView)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTheme() {
        let mainColor = AD.myThemeColor()
        
        view.backgroundColor = mainColor
        
        locationIDIcon.tintColor = mainColor
        locationIconView.tintColor = mainColor
    }
    
    func expandLocationView() {
        let width = self.locationPickerView.frame.size.width
        
        self.locationIconView.isHidden = true
        self.locationTextLabel.isHidden = true
        
        self.locationIconView.removeFromSuperview()
        self.locationTextLabel.removeFromSuperview()
        
        self.viewHeightConstraint.constant = width + 41
        
        UIView.animate(withDuration: 1, animations: {
            self.locationPickerView.frame.size = CGSize(width: width, height: width + 41)
        }) { (completed) in
            let mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: width, height: width))
            mapView.showsUserLocation = true
            self.locationPickerView.addSubview(mapView)
        }
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
