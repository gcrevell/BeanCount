//
//  AddLocationViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/17/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class AddLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var locationNameTextField: UITextField!
    
    let locationIDIcon = UIImageView(frame: CGRect(x: 9, y: 9, width: 24, height: 24))
    @IBOutlet weak var locationPickerView: UIView!
    @IBOutlet weak var locationIconView: UIImageView!
    @IBOutlet weak var locationTextLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    var currentLocation: CLLocationCoordinate2D?
    
    let AD = UIApplication.shared.delegate as! AppDelegate
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let fontName = "Avenir-Book"
        let mainColor = AD.myThemeColor()
        
        updateTheme()
        
        self.locationNameTextField.text = ""
        self.locationNameTextField.backgroundColor = UIColor.white
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
        self.locationPickerView.backgroundColor = UIColor.white
        
        self.locationIconView.image = UIImage(named: "location.png")?.withRenderingMode(.alwaysTemplate)
        self.locationIconView.contentMode = .scaleAspectFit
        self.locationIconView.tintColor = mainColor
        self.locationIconView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        self.locationTextLabel.text = "Choose a location"
        self.locationTextLabel.textColor = UIColor(red: 199/255, green: 199/255, blue: 205/255, alpha: 1)
        self.locationTextLabel.font = UIFont(name: fontName, size: 16)
        
        self.locationPickerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandMapView)))
        
        self.submitButton.backgroundColor = UIColor(red: 246/255, green: 175/255, blue: 41/255, alpha: 1)
        self.submitButton.setTitle("Submit", for: [])
        self.submitButton.setTitleColor(UIColor.white, for: [])
        self.submitButton.layer.cornerRadius = 3
        self.submitButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
        self.submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
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
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("My location is \(mapView.centerCoordinate)")
        self.currentLocation = mapView.centerCoordinate
        self.locationToCityState(location: self.currentLocation!) { (placemarks, error) in
            let placemark = placemarks![0]
            print(placemark.locality)
            print(placemark.administrativeArea)
            
            if placemark.locality != nil && placemark.administrativeArea != nil {
                self.locationTextLabel.text = "\(placemark.locality!), \(placemark.administrativeArea!)"
            } else if placemark.administrativeArea != nil {
                self.locationTextLabel.text = "\(placemark.administrativeArea!)"
            } else {
                self.locationTextLabel.text = "Unknown location"
            }
            
            
            self.locationTextLabel.textColor = UIColor.black
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("My location 2 is \(mapView.centerCoordinate)")
    }
    
    func expandMapView() {
        print("Opening map")
        
        self.view.endEditing(true)
        
        self.locationPickerView.gestureRecognizers = nil
        
        let width = self.locationPickerView.frame.size.width
        
        self.locationIconView.isHidden = true
        self.locationTextLabel.isHidden = true
        
        self.viewHeightConstraint.constant = width + 41
        
        self.submitButton.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 1, animations: {
            self.locationPickerView.frame.size = CGSize(width: width, height: width + 41)
            
            self.submitButton.alpha = 0
            self.submitButton.frame.origin = CGPoint(x: self.submitButton.frame.origin.x, y: self.submitButton.frame.origin.y + width)
        }) { (completed) in
            self.submitButton.isHidden = true
            
            let mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: width, height: width))
            mapView.showsUserLocation = true
            mapView.userTrackingMode = MKUserTrackingMode.follow
            mapView.delegate = self
            self.locationPickerView.addSubview(mapView)
            
            let closeButton = UIButton(frame: CGRect(x: 0, y: width, width: width, height: 41))
            closeButton.backgroundColor = UIColor(red: 246/255, green: 175/255, blue: 41/255, alpha: 1)
            closeButton.setTitle("Set location", for: [])
            closeButton.setTitleColor(UIColor.white, for: [])
            closeButton.addTarget(self, action: #selector(self.closeMapView), for: .touchUpInside)
            closeButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 20)
            self.locationPickerView.addSubview(closeButton)
            
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func closeMapView() {
        print("Closing map")
        
        for view in self.locationPickerView.subviews {
            if view != locationIconView && view != locationTextLabel {
                view.removeFromSuperview()
            }
        }
        
        self.locationPickerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandMapView)))
        
        let width = self.locationPickerView.frame.size.width
        let height = CGFloat(41)
        
        self.viewHeightConstraint.constant = height
        
        self.submitButton.isHidden = false
        
        UIView.animate(withDuration: 1, animations: {
            self.locationPickerView.frame.size = CGSize(width: width, height: height)
            
            self.submitButton.alpha = 1
            self.submitButton.frame.origin = CGPoint(x: self.submitButton.frame.origin.x, y: self.locationPickerView.frame.origin.y + 41 + 60)
        }) { (completed) in
            self.locationIconView.isHidden = false
            self.locationTextLabel.isHidden = false
            
            self.submitButton.isUserInteractionEnabled = true
        }
    }
    
    func locationToCityState(location: CLLocationCoordinate2D, completion: (placemarks: [CLPlacemark]?, error: NSError?) -> Void) {
        let lat = location.latitude
        let lon = location.longitude
        
        let loc = CLLocation(latitude: lat, longitude: lon)
        
        CLGeocoder().reverseGeocodeLocation(loc) { (placemarks, error) in
            completion(placemarks: placemarks, error: error)
        }
    }
    
    func submit() {
        if self.currentLocation == nil {
            // No map location set for this location
            return
        }
        
        if self.locationNameTextField.text == nil || self.locationNameTextField.text! == "" {
            // No name for this location
            return
        }
        
        // We're good. Create a new location.
        // Show user things are happening
        self.submitButton.isEnabled = false
        let activity = UIActivityIndicatorView()
        activity.startAnimating()
        activity.center = CGPoint(x: self.submitButton.frame.size.width/2, y: self.submitButton.frame.size.height/2)
        self.submitButton.addSubview(activity)
        self.submitButton.setTitle("", for: [])
        
        // Add to Firebase.
        // Create location unique ID
        let UID = NSUUID().uuidString
        print("This location's UUID is \(UID)")
        // Add location Lat, Long, Name, City/State name to firebase with UID as key
        
        locationToCityState(location: self.currentLocation!) { (placemarks, error) in
            if error != nil {
                print("Error: there was an error with finding the current location name.")
                print(error)
                
                return
            }
            
            let placemark = placemarks![0]
            let db = FIRDatabase.database().reference()
            let city = placemark.locality == nil ? "" : placemark.locality!
            let state = placemark.administrativeArea == nil ? "" : placemark.administrativeArea!
            
            let values:[String : AnyObject] = ["latitude" : self.currentLocation!.latitude,
                                               "longitude" : self.currentLocation!.longitude,
                                               "locationName" : self.locationNameTextField.text!,
                                               "city" : city,
                                               "state" : state]
            
            db.child("locations").child(UID).setValue(values, withCompletionBlock: { (error, dbRef) in
                if error != nil {
                    print("Error: There was an error with uploading the location to the database.")
                    print(error)
                    
                    return
                }
                
                // Success!
                // Set as current location
                self.AD.selectedLocation = Location(latitude: self.currentLocation!.latitude, longitude: self.currentLocation!.longitude, name: self.locationNameTextField.text!, UID: UID, city: city, state: state)
                
                
                
                // Unwind to settings view
                self.performSegue(withIdentifier: "UnwindToSettingsView", sender: self)
            })
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
