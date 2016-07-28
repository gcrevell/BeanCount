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
        themeSelector.addTarget(self, action: #selector(themeChanged), for: .valueChanged)
        themeSelector.selectedSegmentIndex = AD.selectedTheme != Theme.None ? AD.selectedTheme!.rawValue - 1 : 0
        
        locationImageView.image = UIImage(named: "location.png")?.withRenderingMode(.alwaysTemplate)
        locationImageView.tintColor = mainColor
        locationImageView.contentMode = .scaleAspectFit
        locationImageView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        locationLabel.textColor = AD.selectedLocation == nil ? UIColor.lightGray() : UIColor.black()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTheme()
        updateLocationLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func themeChanged() {
        AD.selectedTheme = Theme(rawValue: themeSelector.selectedSegmentIndex + 1)
        updateTheme()
    }
    
    func updateTheme() {
        let mainColor = AD.myThemeColor()
        
        self.view.backgroundColor = mainColor
        
        locationImageView.tintColor = mainColor
    }
    
    func updateLocationLabel() {
        locationLabel.text = AD.selectedLocation == nil ? "Please set your location." : AD.selectedLocation?.name
    }
    
    func updateLocation() {
        print("PRESSED")
        performSegue(withIdentifier: "SegueToLocationsListView", sender: self)
    }
    
    @IBAction func unwindToSettings(segue: UIStoryboardSegue) {
        
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
