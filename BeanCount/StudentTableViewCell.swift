//
//  StudentTableViewCell.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/15/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    var active: Bool = true
    
    func update() {
        if active {
            checkImageView.image = UIImage(named: "check.png")
        } else {
            checkImageView.image = UIImage(named: "uncheck.png")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
