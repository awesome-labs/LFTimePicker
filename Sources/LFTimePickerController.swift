//
//  LFTimePickerController.swift
//  LFTimePicker
//
//  Created by Lucas Farah on 6/1/16.
//  Copyright © 2016 Lucas Farah. All rights reserved.
//

import UIKit

//MARK: - LFTimePickerDelegate

/**
 Used to return information after user taps the "Save" button
 - requires: func didPickTime(start: String, end: String)
 */

public protocol LFTimePickerDelegate: class {

	/**
	 Called after pressing save. Used so the user can call their server to check user's information.
	 - returns: start and end times in hh:mm aa
	 */
	func didPickTime(start: String, end: String)
}

/**
 ViewController that handles the Time Picking
 - customizations: timeType, startTimes, endTimes
 */
public class LFTimePickerController: UIViewController {

	// MARK: - Variables
	public weak var delegate: LFTimePickerDelegate?
	var startTimes: [String] = []
	var endTimes: [String] = []

	var table = UITableView()
	var table2 = UITableView()
	var lblDetail = UILabel()
	var lblDetail2 = UILabel()
	var detailBackgroundView = UIView()
	var lblAMPM = UILabel()
	var lblAMPM2 = UILabel()
	var firstRowIndex = 0

	var isCustomTime = false

	/// Used to customize a 12-hour or 24-hour times
	public enum TimeType {

		/// Enables AM-PM
		case hour12

		/// 24-hour format
		case hour24
	}

	/// Used for customization of time possibilities
	public enum Time {

		/// Customizing possible start times
		case startTime

		/// Customizing possible end times
		case endTime
	}

	/// Hour Format: 12h (default) or 24h format
	public var timeType = TimeType.hour12

	// MARK: - Methods

	/// Used to load all the setup methods
	override public func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		self.title = "Change Time"
		self.view.backgroundColor = UIColor(red: 255 / 255, green: 128 / 255, blue: 0, alpha: 1)

		setupTables()
		setupDetailView()
		setupBottomDetail()
		setupNavigationBar()
		setupTime()
	}

	// MARK: Setup
	private func setupNavigationBar() {

		let saveButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(butSave))
		saveButton.tintColor = .redColor()

		let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(butCancel))
		cancelButton.tintColor = .redColor()

		self.navigationItem.rightBarButtonItem = saveButton
		self.navigationItem.leftBarButtonItem = cancelButton
	}

	private func setupTables() {

		let frame1 = CGRect(x: 30, y: 0, width: 100, height: self.view.bounds.height)
		table = UITableView(frame: frame1, style: .Plain)

		let frame2 = CGRect(x: self.view.frame.width - 100, y: 0, width: 100, height: self.view.bounds.height)

		table2 = UITableView(frame: frame2, style: .Plain)

		table.separatorStyle = .None
		table2.separatorStyle = .None

		table.dataSource = self
		table.delegate = self
		table2.dataSource = self
		table2.delegate = self

		table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
		table2.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

		table.backgroundColor = .clearColor()
		table2.backgroundColor = .clearColor()

		table.showsVerticalScrollIndicator = false
		table2.showsVerticalScrollIndicator = false

		table.allowsSelection = false
		table2.allowsSelection = false

		view.addSubview(table)
		view.addSubview(table2)

		self.view.sendSubviewToBack(table)
		self.view.sendSubviewToBack(table2)
	}

	private func setupDetailView() {

		detailBackgroundView = UIView(frame: CGRect(x: 0, y: (self.view.bounds.height / 5) * 2, width: self.view.bounds.width, height: self.view.bounds.height / 6))
		detailBackgroundView.backgroundColor = .whiteColor()

		lblDetail = UILabel(frame: CGRect(x: 20, y: detailBackgroundView.frame.height / 2, width: 110, height: detailBackgroundView.frame.height))
		lblDetail.center = CGPointMake(60, detailBackgroundView.frame.height / 2)

		lblDetail.font = UIFont.systemFontOfSize(40)
		lblDetail.text = "00:00"
		lblDetail.textAlignment = .Center

		lblDetail2 = UILabel(frame: CGRect(x: detailBackgroundView.frame.width / 7 * 6 + 20, y: detailBackgroundView.frame.height / 2, width: 110, height: detailBackgroundView.frame.height))
		lblDetail2.center = CGPointMake(detailBackgroundView.bounds.width - 60, detailBackgroundView.frame.height / 2)

		lblDetail2.font = UIFont.systemFontOfSize(40)
		lblDetail2.text = "00:00"
		lblDetail2.textAlignment = .Center

		detailBackgroundView.addSubview(lblDetail)
		detailBackgroundView.addSubview(lblDetail2)

		let lblTo = UILabel(frame: CGRect(x: detailBackgroundView.frame.width / 2, y: detailBackgroundView.frame.height / 2, width: 30, height: 20))
		lblTo.text = "TO"

		detailBackgroundView.addSubview(lblTo)

		self.view.addSubview(detailBackgroundView)
	}

	private func setupBottomDetail() {

		let bottomDetailMainBackground = UIView(frame: CGRect(x: 0, y: self.detailBackgroundView.frame.maxY, width: self.view.frame.width, height: 38))
		bottomDetailMainBackground.backgroundColor = UIColor(red: 255 / 255, green: 128 / 255, blue: 0, alpha: 1)

		let bottomDetailMainShade = UIView(frame: CGRect(x: 0, y: self.detailBackgroundView.frame.maxY, width: self.view.frame.width, height: 38))
		bottomDetailMainShade.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.6)

		lblAMPM = UILabel(frame: CGRect(x: 20, y: bottomDetailMainShade.frame.height / 2, width: 110, height: bottomDetailMainShade.frame.height))
		lblAMPM.center = CGPointMake(60, bottomDetailMainShade.frame.height / 2)

		lblAMPM.font = UIFont.systemFontOfSize(15)
		lblAMPM.text = "AM"
		lblAMPM.textAlignment = .Center

		lblAMPM2 = UILabel(frame: CGRect(x: bottomDetailMainShade.frame.width / 7 * 6 + 20, y: bottomDetailMainShade.frame.height / 2, width: 110, height: bottomDetailMainShade.frame.height))
		lblAMPM2.center = CGPointMake(bottomDetailMainShade.bounds.width - 60, bottomDetailMainShade.frame.height / 2)

		lblAMPM2.font = UIFont.systemFontOfSize(15)
		lblAMPM2.text = "AM"
		lblAMPM2.textAlignment = .Center

		bottomDetailMainShade.addSubview(lblAMPM)
		bottomDetailMainShade.addSubview(lblAMPM2)

		self.view.addSubview(bottomDetailMainBackground)
		self.view.addSubview(bottomDetailMainShade)
	}

	private func setupTime() {

		if !isCustomTime {

			switch timeType {

			case TimeType.hour12:
				lblAMPM.hidden = false

				startTimes = defaultTimeArray12()
				endTimes = defaultTimeArray12()
				break

			case TimeType.hour24:
				lblAMPM2.hidden = false

				startTimes = defaultTimeArray24()
				endTimes = defaultTimeArray24()
				break
			}
		} else {

			lblAMPM.hidden = true
			lblAMPM2.hidden = true
		}
	}

	private func defaultTimeArray12() -> [String] {

		var arr: [String] = []

		for _ in 0...8 {
			arr.append("")
		}

		for _ in 0...1 {
			for i in 0...11 {
				for x in 0 ..< 4 {

					if x == 0 {
						arr.append("\(i):00")
					} else {
						arr.append("\(i):\(x * 15)")
					}
				}
				table.reloadData()
			}
		}

		for _ in 0...8 {
			arr.append("")
		}

		return arr
	}

	private func defaultTimeArray24() -> [String] {

		var arr: [String] = []
		lblAMPM.hidden = true
		lblAMPM2.hidden = true

		for _ in 0...8 {
			arr.append("")
		}

		for i in 0...23 {
			for x in 0 ..< 4 {

				if x == 0 {
					arr.append("\(i):00")
				} else {
					arr.append("\(i):\(x * 15)")
				}
			}
			table.reloadData()
		}

		for _ in 0...8 {
			arr.append("")
		}

		return arr
	}

	// MARK: Button Methods
	@objc private func butSave() {

		let time = self.lblDetail.text!
		let time2 = self.lblDetail2.text!

		if isCustomTime {

			delegate?.didPickTime(time, end: time2)
		} else if timeType == .hour12 {

			delegate?.didPickTime(time + " \(self.lblAMPM.text!)", end: time2 + " \(self.lblAMPM2.text!)")
		} else {

			delegate?.didPickTime(time, end: time2)
		}

		self.navigationController?.popViewControllerAnimated(true)
	}

	@objc private func butCancel() {

		self.navigationController?.popViewControllerAnimated(true)
	}

	// MARK - Customisations
	public func customizeTimes(timesArray: [String], time: Time) {

		isCustomTime = true
		switch time {
		case .startTime:
			startTimes = timesArray
			table.reloadData()

			for _ in 0...8 {
				startTimes.insert("", atIndex: 0)
			}
			for _ in 0...8 {
				startTimes.append("")
			}

		case .endTime:
			endTimes = timesArray
			table2.reloadData()

			for _ in 0...8 {
				endTimes.insert("", atIndex: 0)
			}
			for _ in 0...8 {
				endTimes.append("")
			}

		}
	}
}

//MARK: - UITableViewDataSource
extension LFTimePickerController: UITableViewDataSource {

	/// Setup of Time cells
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		if tableView == table {

			return startTimes.count
		} else if tableView == table2 {

			return endTimes.count
		}
		return 0
	}

	// Setup of Time cells
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
		if !(cell != nil) {
			cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
		}

		// setup cell without force unwrapping it
		var arr: [String] = []
		if tableView == table {

			arr = startTimes
		} else if tableView == table2 {

			arr = endTimes
		}

		cell.textLabel!.text = arr[indexPath.row]
		cell.textLabel?.textColor = .whiteColor()

		cell.backgroundColor = .clearColor()
		return cell
	}
}

//MARK: - UITableViewDelegate
extension LFTimePickerController: UITableViewDelegate {

	/// Used to change AM from PM
	public func scrollViewDidScroll(scrollView: UIScrollView) {

		if table.visibleCells.count > 8 && table2.visibleCells.count > 8 {

			if table.indexPathsForVisibleRows?.first?.row < 48 {

				self.lblAMPM.text = "AM"
			} else {

				self.lblAMPM.text = "PM"
			}

			if table2.indexPathsForVisibleRows?.first?.row < 48 {

				self.lblAMPM2.text = "AM"
			} else {

				self.lblAMPM2.text = "PM"
			}

			let text = table.visibleCells[8]
			let text2 = table2.visibleCells[8]
			self.lblDetail.text = text.textLabel?.text

//			if firstRowIndex != table.indexPathsForVisibleRows?.first?.row {
//
//				UIView.animateWithDuration(0.3, animations: {
//					self.lblDetail.center = CGPointMake(60, -5)
//					self.lblDetail.alpha = 0
//					}, completion: { (completed) in
//
//					self.lblDetail.center = CGPointMake(60, 130)
//					if text.textLabel?.text != "" {
//						self.lblDetail.text = text.textLabel?.text
//					}
//
//					UIView.animateWithDuration(0.3, animations: {
//
//						self.lblDetail.center = CGPointMake(60, self.detailBackgroundView.frame.height / 2)
//						self.lblDetail.alpha = 1
//					})
//
//				})
//			}

			if text2.textLabel?.text != "" {
				self.lblDetail2.text = text2.textLabel?.text
			}

		}

		if let rowIndex = table.indexPathsForVisibleRows?.first?.row {
			firstRowIndex = rowIndex
		}

	}
}

//Got from EZSwiftExtensions
extension NSTimer {

	private static func runThisAfterDelay(seconds seconds: Double, after: () -> ()) {
		runThisAfterDelay(seconds: seconds, queue: dispatch_get_main_queue(), after: after)
	}

	private static func runThisAfterDelay(seconds seconds: Double, queue: dispatch_queue_t, after: () -> ()) {
		let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
		dispatch_after(time, queue, after)
	}
}
