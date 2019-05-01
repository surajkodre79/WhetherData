//
//  WhetherTableViewCell.swift
//  WhetherInfo
//
//  Created by Suraj Kodre on 30/04/19.
//  Copyright © 2019 Suraj Kodre. All rights reserved.
//

import UIKit

class WhetherTableViewCell: UITableViewCell {

	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
