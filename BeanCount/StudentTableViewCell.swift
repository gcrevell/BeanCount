//
//  StudentTableViewCell.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/1/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var radialView: FillButtonView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
