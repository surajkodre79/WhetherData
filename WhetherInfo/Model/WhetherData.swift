//
//  WhetherData.swift
//  WhetherInfo
//
//  Created by Suraj Kodre on 30/04/19.
//  Copyright © 2019 Suraj Kodre. All rights reserved.
//

import Foundation

struct WhetherData: Codable {
	let name: String
	let main: Temperature
}

struct Temperature: Codable {
	let temp: Float
	let temp_min: Float
	let temp_max: Float
}
