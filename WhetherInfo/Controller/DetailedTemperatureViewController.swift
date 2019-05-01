//
//  DetailedTemperatureViewController.swift
//  WhetherInfo
//
//  Created by Suraj Kodre on 30/04/19.
//  Copyright © 2019 Suraj Kodre. All rights reserved.
//

import UIKit

class DetailedTemperatureViewController: UIViewController {
	
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var maxTempLabel: UILabel!
	@IBOutlet weak var minTempLabel: UILabel!
	@IBOutlet weak var currentTempLabel: UILabel!
	
	var detailedWhetherInfo: WhetherData?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.navigationBar.isHidden = false
		if let detailedWhetherInfo = detailedWhetherInfo {
			cityLabel.text = detailedWhetherInfo.name
			currentTempLabel.text = "\(String(describing: detailedWhetherInfo.main.temp))"
			minTempLabel.text = "\(String(describing:detailedWhetherInfo.main.temp_min))"
			maxTempLabel.text = "\(String(describing:detailedWhetherInfo.main.temp_max))"
		}
    }

}
