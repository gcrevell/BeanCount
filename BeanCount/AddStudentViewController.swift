//
//  AddStudentViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/2/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

class AddStudentViewController: UIViewController, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var studentNameField: UITextField!
    
    let AD = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let mainColor = AD.myThemeColor()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        self.view.backgroundColor = mainColor
        
        self.studentNameField.text = ""
        self.studentNameField.backgroundColor = UIColor.white
        self.studentNameField.layer.cornerRadius = 3
        self.studentNameField.placeholder = "Name"
        self.studentNameField.font = UIFont(name: themeFont, size: 17)
        self.studentNameField.autocapitalizationType = .words
        self.studentNameField.autocorrectionType = .no
        
        let studentNameIcon = UIImageView(frame: CGRect(x: 9, y: 9, width: 24, height: 24))
        studentNameIcon.image = UIImage(named: "id card.png")?.withRenderingMode(.alwaysTemplate)
        studentNameIcon.tintColor = mainColor
        studentNameIcon.contentMode = .scaleAspectFit
        let studentNameIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: 41))
        studentNameIconContainer.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        studentNameIconContainer.addSubview(studentNameIcon)
        
        self.studentNameField.leftViewMode = UITextFieldViewMode.always
        self.studentNameField.leftView = studentNameIconContainer
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(labelPressed))
        tap.delegate = self
//        typeLabel.addGestureRecognizer(tap)
//        typeLabel.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func done() {
        cancel()
    }
    
    func cancel() {
        performSegue(withIdentifier: "UnwindToStudentsTableView", sender: self)
    }
    
    func labelPressed() {
        print("Label Pressed")
        
        let labels = InformationLabelTableViewController()
        
        labels.modalPresentationStyle = .popover
        labels.preferredContentSize = CGSize(width: 200, height: 400)
        
        let popover = labels.popoverPresentationController
        popover?.permittedArrowDirections = .any
        popover?.delegate = self
        popover?.sourceView = self.view
//        popover?.sourceRect = typeLabel.frame
        
//        self.present(labels, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
//    func adaptivePresentationStyleForPresentationController(
//        controller: UIPresentationController!) -> UIModalPresentationStyle {
//        return .none
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
