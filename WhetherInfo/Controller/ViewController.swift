//
//  ViewController.swift
//  WhetherInfo
//
//  Created by Suraj Kodre on 30/04/19.
//  Copyright © 2019 Suraj Kodre. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var indicator: UIActivityIndicatorView!
	
	var whetherDataArray: [WhetherData]? = []
	var isTimerStarted = false
	let dispatchGroup = DispatchGroup()
	var urlArray: [URL] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.navigationBar.isHidden = true
		tableView.register(UINib(nibName: "WhetherTableViewCell", bundle: nil), forCellReuseIdentifier: "whetherCell")
	
		CoreDataManager.sharedInstance.deleteRecords { (sucess) in
			if sucess == true {
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			}
		}
		creatingUrlArray()
		self.indicator.isHidden = false
		indicator.startAnimating()
		checkWhetherDataChanged(urlArray: urlArray)
		Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
			self.indicator.startAnimating()
			self.isTimerStarted = true
			self.checkWhetherDataChanged(urlArray: self.urlArray)
		}
	}
	
	func creatingUrlArray() {
		let melbourneUrl = WhetherURLs.melbourneUrl
		let sydneyUrl = WhetherURLs.sydneyUrl
		let brisbaneUrl = WhetherURLs.brisbane
		
		urlArray.append(melbourneUrl)
		urlArray.append(sydneyUrl)
		urlArray.append(brisbaneUrl)
	}
	
	@objc func checkWhetherDataChanged(urlArray: [URL]) {
		var tempWhetherArray: [WhetherData] = []
		
		if self.isTimerStarted == true {
			CoreDataManager.sharedInstance.deleteRecords { (sucess) in
				if sucess == true {
					print("Sucessfully deleted records")
					DispatchQueue.main.async {
						self.whetherDataArray = nil
						self.indicator.isHidden = false
						self.indicator.startAnimating()
						self.tableView.reloadData()
					}
				}
			}
			self.isTimerStarted = false
		}
		
		dispatchGroup.enter()
		NetWorkManager.sharedInstance.fetchDataFromURL(url: urlArray[0]) { (whetherData, sucess) in
			guard let whetherData = whetherData else { return }
			tempWhetherArray.append(whetherData)
			self.dispatchGroup.leave()
		}
		
		dispatchGroup.enter()
		NetWorkManager.sharedInstance.fetchDataFromURL(url: urlArray[1]) { (whetherData, sucess) in
			guard let whetherData = whetherData else { return }
			tempWhetherArray.append(whetherData)
			self.dispatchGroup.leave()
		}
		
		dispatchGroup.enter()
		NetWorkManager.sharedInstance.fetchDataFromURL(url: urlArray[2]) { (whetherData, sucess) in
			guard let whetherData = whetherData else { return }
			tempWhetherArray.append(whetherData)
			self.dispatchGroup.leave()
		}
		
		dispatchGroup.notify(queue: .main) {
			CoreDataManager.sharedInstance.saveWhetherInfo(whetherInformation: tempWhetherArray, closure: { sucess in
				if sucess == true {
					CoreDataManager.sharedInstance.fetchDataFromDB(closure: { (whetherData, success) in
						if success == true {
							self.whetherDataArray = whetherData!
							DispatchQueue.main.async {
								self.indicator.stopAnimating()
								self.indicator.isHidden = true
								self.tableView.reloadData()
							}
						}
					})
				}
			})
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "detailedSegue" {
			let destinationVC = segue.destination as? DetailedTemperatureViewController
			destinationVC?.detailedWhetherInfo = whetherDataArray![sender as! Int]
		}
	}
}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return whetherDataArray?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "whetherCell", for: indexPath) as? WhetherTableViewCell
		cell?.cityLabel.text = whetherDataArray?[indexPath.row].name
		cell?.temperatureLabel.text =  String(whetherDataArray?[indexPath.row].main.temp ?? 0)
		return cell!
	}
}

extension ViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "detailedSegue", sender: indexPath.row)
	}
}
