//
//  ServiceDetailNameTableViewCell.swift
//  Network Browser
//
//  Created by Thomas Petz, Jr. on 8/9/18.
//  Copyright © 2018 Thomas J. Petz, Jr. All rights reserved.
//

import UIKit

class ServiceDetailNameTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
