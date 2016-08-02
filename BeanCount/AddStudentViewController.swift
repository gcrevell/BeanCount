//
//  AddStudentViewController.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/2/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

class AddStudentViewController: UIViewController, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var typeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(labelPressed))
        tap.delegate = self
        typeLabel.addGestureRecognizer(tap)
        typeLabel.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func labelPressed() {
        print("Label Pressed")
        
        let labels = InformationLabelTableViewController()
        
        labels.modalPresentationStyle = .popover
//        labels.modalTransitionStyle = .
        labels.preferredContentSize = CGSize(width: 200, height: 400)
        
        let popover = labels.popoverPresentationController
        popover?.permittedArrowDirections = .any
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = typeLabel.frame
        
        self.present(labels, animated: true, completion: nil)
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
