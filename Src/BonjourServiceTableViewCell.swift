//
//  BonjourServiceTableViewCell.swift
//  Network Browser
//
//  Created by Thomas Petz, Jr. on 12/24/15.
//  Copyright © 2015 Thomas J. Petz, Jr. All rights reserved.
//

import Foundation
import UIKit

class BonjourServiceTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceFriendlyName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
