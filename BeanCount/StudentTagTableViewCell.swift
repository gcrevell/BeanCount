//
//  StudentTagTableViewCell.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/3/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

class StudentTagTableViewCell: UITableViewCell {

    @IBOutlet weak var mainTextField: UITextField!
    var displayedTag: StudentTags = .otherBook
//    var color
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateTag() {
        mainTextField.leftView?.removeAllSubviews()
        
        mainTextField.placeholder = getTextPlaceholder(of: displayedTag)
        
        let imageView = UIImageView(frame: CGRect(x: 9, y: 9, width: 24, height: 24))
        imageView.image = getImage(of: displayedTag).withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        
        mainTextField.leftView?.addSubview(imageView)
    }

}
