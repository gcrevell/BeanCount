//
//  SettingsViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/17/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var themeSelector: UISegmentedControl!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationView: UIView!
    
    let AD = UIApplication.shared().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let fontNameBold = "Avenir-Black"
        let mainColor = AD.myThemeColor()
        
        updateTheme()
        
        locationView.layer.cornerRadius = 3
        locationView.backgroundColor = UIColor.white()
        locationView.contentScaleFactor = 0.5
        locationView.clipsToBounds = true
        
        locationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(updateLocation)))
        
        let onColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1)
        let divider = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
        
        style(segmentedControl: themeSelector, fontName: fontNameBold, selectedColor: onColor, unselectedColor: UIColor.white(), dividerColor: divider)
        
        locationImageView.image = UIImage(named: "location.png")?.withRenderingMode(.alwaysTemplate)
        locationImageView.tintColor = mainColor
        locationImageView.contentMode = .scaleAspectFit
        locationImageView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        locationLabel.text = "Please set your location..."
        locationLabel.textColor = UIColor.lightGray()
        
        
//        locationIcon.image = UIImage(named: "location.png")?.withRenderingMode(.alwaysTemplate)
//        locationIcon.tintColor = mainColor
//        locationIcon.contentMode = .scaleAspectFit
//        let locationIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: 41))
//        locationIconContainer.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
//        locationIconContainer.addSubview(locationIcon)
//        
//        locationButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        locationButton.setImage(UIImage(named: "location.png")?.withRenderingMode(.alwaysTemplate), for: [])
//        locationButton.contentMode = .scaleAspectFit
//        locationButton.tintColor = mainColor
//        locationButton.setTitle("Add a location...", for: [])
//        self.locationButton.leftViewMode = UITextFieldViewMode.always
//        self.locationButton.leftView = locationIconContainer
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTheme()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTheme() {
        let mainColor = AD.myThemeColor()
        
        self.view.backgroundColor = mainColor
        
        locationImageView.tintColor = mainColor
    }
    
    func updateLocation() {
        print("PRESSED")
        performSegue(withIdentifier: "SegueToLocationsListView", sender: self)
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
