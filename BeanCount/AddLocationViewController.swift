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
    
    // MARK: Variables
    @IBOutlet weak var locationNameTextField: UITextField!
    
    @IBOutlet weak var locationPickerView: UIView!
    @IBOutlet weak var locationIconView: UIView!
    @IBOutlet weak var locationTextLabel: UILabel!
    
    @IBOutlet weak var securityView: UIView!
    @IBOutlet weak var passwordTextField: RoundedTextField!
    @IBOutlet weak var inviteSwitch: UISwitch!
    @IBOutlet weak var inviteCodeLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    var currentLocation: CLLocationCoordinate2D?
    let UID = NSUUID().uuidString
    
    let AD = UIApplication.shared.delegate as! AppDelegate
    let locationManager = CLLocationManager()
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let mainColor = AD.myThemeColor()
        
        updateTheme()
        
        // Setup location view
        self.locationPickerView.clipsToBounds = true
        self.locationPickerView.layer.cornerRadius = 3
        self.locationPickerView.backgroundColor = UIColor.white
        
        self.locationIconView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.locationIconView.tintColor = mainColor
        
        let imageView = UIImageView(frame: CGRect(x: 9, y: 9, width: 23, height: 23))
        imageView.image = UIImage(named: "location.png")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        locationIconView.addSubview(imageView)
        
        self.locationTextLabel.text = "Choose a location"
        self.locationTextLabel.textColor = UIColor(red: 199/255, green: 199/255, blue: 205/255, alpha: 1)
        self.locationTextLabel.font = UIFont(name: themeFont, size: 16)
        
        self.locationPickerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandMapView)))
        
        self.submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
        inviteCodeLabel.text = ""
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Map location
    
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
    
    func locationToCityState(location: CLLocationCoordinate2D, completion: @escaping (_ placemarks: [CLPlacemark]?, _ error: NSError?) -> Void) {
        let lat = location.latitude
        let lon = location.longitude
        
        let loc = CLLocation(latitude: lat, longitude: lon)
        
        CLGeocoder().reverseGeocodeLocation(loc) { (placemarks, error) in
            completion(placemarks, error as NSError?)
        }
    }
    
    // MARK: - UI
    
    func updateTheme() {
        let mainColor = AD.myThemeColor()
        
        view.backgroundColor = mainColor
        
        locationNameTextField.tintColor = mainColor
        locationIconView.tintColor = mainColor
    }
    
    func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    func expandMapView() {
        print("Opening map")
        
        self.view.endEditing(true)
        
        self.locationPickerView.gestureRecognizers = nil
        
        let width = self.locationPickerView.frame.size.width
        
        self.locationIconView.isHidden = true
        self.locationTextLabel.isHidden = true
        
        self.viewHeightConstraint.constant = width + 41
        
        self.securityView.isUserInteractionEnabled = false
        self.submitButton.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 1, animations: {
            self.locationPickerView.frame.size = CGSize(width: width, height: width + 41)
            
            self.securityView.alpha = 0
            self.securityView.frame.origin.y += width
            
            self.submitButton.alpha = 0
            self.submitButton.frame.origin.y += width
        }) { (completed) in
            self.securityView.isHidden = true
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
            closeButton.titleLabel?.font = UIFont(name: themeFont, size: 20)
            self.locationPickerView.addSubview(closeButton)
            
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func closeMapView() {
        dismissKeyboard()
        
        for view in self.locationPickerView.subviews {
            if view != locationIconView && view != locationTextLabel {
                view.removeFromSuperview()
            }
        }
        
        self.locationPickerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandMapView)))
        
        let width = self.locationPickerView.frame.size.width
        let height = CGFloat(41)
        
        self.viewHeightConstraint.constant = height
        
        self.securityView.isHidden = false
        self.submitButton.isHidden = false
        
        UIView.animate(withDuration: 1, animations: {
            self.locationPickerView.frame.size = CGSize(width: width, height: height)
            
            self.securityView.alpha = 1
            self.securityView.frame.origin.y -= width
            
            self.submitButton.alpha = 1
            self.submitButton.frame.origin.y -= width
        }) { (completed) in
            self.locationIconView.isHidden = false
            self.locationTextLabel.isHidden = false
            
            self.securityView.isUserInteractionEnabled = true
            self.submitButton.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func inviteSwitch(_ sender: UISwitch) {
        dismissKeyboard()
        
        if sender.isOn {
            let invite = self.UID.components(separatedBy: "-")[0]
        
            inviteCodeLabel.setTextWithTypeAnimation(typedText: invite, characterInterval: 0.0625)
        } else {
            inviteCodeLabel.deleteTextWithAnimation(characterInterval: 0.0625)
        }
        
    }
    
    func submit() {
        dismissKeyboard()
        
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
        self.view.isUserInteractionEnabled = false
        let waitView = LoadingView(frame: self.view.frame)
        self.view.addSubview(waitView)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Create location unique ID
        print("This location's UUID is \(UID)")
        // Add location Lat, Long, Name, City/State name to firebase with UID as key
        
        // Invite & password
        var invite: String? = nil
        var password: String? = nil
        
        if inviteSwitch.isOn {
            invite = self.UID.components(separatedBy: "-")[0]
        }
        
        if passwordTextField.text != nil && passwordTextField.text != "" {
            password = passwordTextField.text
        }
        
        locationToCityState(location: self.currentLocation!) { (placemarks, error) in
            if error != nil {
                print("Error: there was an error with finding the current location name.")
                print(error)
                
                let title = "Location error"
                let subtitle = "There was an error with the selected location."
                
                let alert = UIAlertView(title: title, message: subtitle, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Okay")
                alert.show()
                
                waitView.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                
                return
            }
            
            let placemark = placemarks![0]
            let city = placemark.locality == nil ? "" : placemark.locality!
            let state = placemark.administrativeArea == nil ? "" : placemark.administrativeArea!
            let latitude = self.currentLocation!.latitude as Double
            let longitude = self.currentLocation!.longitude as Double
            
            let newLocation = Location(latitude: latitude, longitude: longitude, name: self.locationNameTextField.text!, UID: self.UID, city: city, state: state)
            
            Database().create(location: newLocation, invite: invite, password: password, completionHandler: { (data, response, error) in
                var title = ""
                var subtitle = ""
                
                if data == nil || response == nil || error != nil {
                    // Network error
                    title = "Network error"
                    subtitle = "There was a network error. Please try again later."
                    
                    
                } else {
                    let reply = String(data: data!, encoding: .utf8)
                    
                    if reply == "1" {
                        // Success
                        DispatchQueue.main.async {
                            self.AD.selectedLocation = newLocation
                            self.performSegue(withIdentifier: "UnwindToSettingsView", sender: self)
                            return
                        }
                        return
                    }
                    
                    title = "Error occurred"
                    subtitle = "An error occurred when creating the new location. Please try again."
                }
                
                let alert = UIAlertView(title: title, message: subtitle, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Okay")
                
                DispatchQueue.main.async {
                    alert.show()
                    
                    waitView.removeFromSuperview()
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                }
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
