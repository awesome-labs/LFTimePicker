//
//  ExampleViewController.swift
//  LFTimePicker
//
//  Created by Lucas Farah on 6/2/16.
//  Copyright © 2016 Lucas Farah. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit

class ExampleViewController: UIViewController {

	// MARK: - Outlets
	@IBOutlet weak var lblStartSelectedTime: UILabel!
	@IBOutlet weak var lblFinishSelectedTime: UILabel!

	// MARK: - Variables
	let timePicker = LFTimePickerController()

	// MARK: - Methods
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		timePicker.delegate = self
        timePicker.timeType = .hour12
		// Customizing time
		// let startTimes = ["6:00", "6:30", "7:00", "7:30", "8:00", "8:30"]
		// let endTimes = ["8:30", "9:00", "9:30", "10:00", "10:30", "11:00"]
		// timePicker.customizeTimes(startTimes, time: .startTime)
		// timePicker.customizeTimes(endTimes, time: .endTime)
	}

	@IBAction func butShowTime(_ sender: AnyObject) {

		self.navigationController?.pushViewController(timePicker, animated: true)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

//MARK: - LFTimePickerDelegate
extension ExampleViewController: LFTimePickerDelegate {

	func didPickTime(_ start: String, end: String) {
		self.lblStartSelectedTime.text = start

		self.lblFinishSelectedTime.text = end

		print(start)
		print(end)
	}
}
