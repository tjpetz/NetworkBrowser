//
//  BonjourDomainTableViewCell.swift
//  Network Browser
//
//  Created by Thomas Petz, Jr. on 12/29/15.
//  Copyright © 2015 Thomas J. Petz, Jr. All rights reserved.
//

import UIKit

class BonjourDomainTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var domain: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
