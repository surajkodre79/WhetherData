//
//  NetworkManager.swift
//  WhetherInfo
//
//  Created by Suraj Kodre on 30/04/19.
//  Copyright © 2019 Suraj Kodre. All rights reserved.
//

import UIKit

class NetWorkManager {
	public static let sharedInstance = NetWorkManager()
	
	func fetchDataFromURL(url: URL?, closure: @escaping (WhetherData?,Bool)->()) {
		guard let url = url else { return }
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			do {
				guard let data = data else { throw JSONError.NoData }
				guard let json = try? JSONDecoder().decode(WhetherData.self, from: data) else { throw JSONError.ConversionFailed }
				
				closure(json,true)
			} catch let error as JSONError {
				print(error.rawValue)
				closure(nil,false)
			} catch let error as NSError {
				print("Error: \(error)")
				closure(nil,false)
			}
			}.resume()
	}
}

