//
//  CoreDataManager.swift
//  WhetherInfo
//
//  Created by Suraj Kodre on 01/05/19.
//  Copyright © 2019 Suraj Kodre. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var context: NSManagedObjectContext?
	
	public static let sharedInstance = CoreDataManager()
	
	private init() {
		context = appDelegate.persistentContainer.viewContext
	}
	
	func saveWhetherInfo(whetherInformation: [WhetherData], closure: (Bool)-> Void) {
		
		let entity = NSEntityDescription.entity(forEntityName: "WhetherInfo", in: context!)
		
		for whether in whetherInformation {
			let whetherInfo = NSManagedObject(entity: entity!, insertInto: context)
			whetherInfo.setValue(whether.name, forKey: "city")
			whetherInfo.setValue(whether.main.temp, forKey: "temperature")
			whetherInfo.setValue(whether.main.temp_max, forKey: "max_temperature")
			whetherInfo.setValue(whether.main.temp_min, forKey: "min_temperature")
		}
		do {
			try context?.save()
			print("Data Saved")
			closure(true)
		} catch {
			print("Failed saving")
			closure(false)
		}
	}
	
	func fetchDataFromDB(closure: ([WhetherData]?,Bool)-> Void) {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WhetherInfo")
		request.returnsObjectsAsFaults = false
		var whetherdata: [WhetherData] = []
		do {
			guard let result = try context?.fetch(request) else { throw JSONError.NoData }
			for data in result as! [NSManagedObject] {
				let city = data.value(forKey: "city") as! String
				let temp = data.value(forKey: "temperature") as! Float
				let min_temp = data.value(forKey: "min_temperature") as! Float
				let max_temp = data.value(forKey: "max_temperature") as! Float
				let temperature = Temperature.init(temp: temp, temp_min: min_temp, temp_max: max_temp)
				
				whetherdata.append(WhetherData.init(name: city, main: temperature))
			}
			print("Fetching data")
			closure(whetherdata,true)
		} catch let error as JSONError {
			print(error)
			closure(nil,false)
		} catch let error as NSError {
			print(error)
			closure(nil,false)
		}
	}

	func deleteRecords(closure: (Bool)-> Void) {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WhetherInfo")
		do {
			guard let result = try context?.fetch(request) else { throw JSONError.NoData }
			for obj in result {
				context?.delete(obj as! NSManagedObject)
			}
			do {
				try context!.save()
			} catch let error as NSError {
				print(error)
				closure(false)
			}
			closure(true)
		} catch let error as JSONError {
			print(error)
			closure(false)
		} catch let error as NSError {
			print(error)
			closure(false)
		}
	}
}
