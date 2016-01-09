//
//  DiscoveredServiceTableViewCell.swift
//  Network Browser
//
//  Created by Thomas Petz, Jr. on 1/9/16.
//  Copyright © 2016 Thomas J. Petz, Jr. All rights reserved.
//

import UIKit

class DiscoveredServiceTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var serviceName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
