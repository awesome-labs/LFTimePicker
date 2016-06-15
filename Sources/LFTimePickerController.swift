//
//  LFTimePickerController.swift
//  LFTimePicker
//
//  Created by Lucas Farah on 6/1/16.
//  Copyright © 2016 Lucas Farah. All rights reserved.
//

import UIKit

//MARK: - LFTimePickerDelegate
public protocol LFTimePickerDelegate: class {

	/// LFTimePickerController: Called after pressing save. Format: hh:mm aa
	func didPickTime(_ start: String, end: String)
}

public class LFTimePickerController: UIViewController {

	// MARK: - Variables
	public weak var delegate: LFTimePickerDelegate?
	var arr: [String] = []
	var table = UITableView()
	var table2 = UITableView()
	var lblDetail = UILabel()
	var lblDetail2 = UILabel()
	var detailBackgroundView = UIView()
	var lblAMPM = UILabel()
	var lblAMPM2 = UILabel()
	var firstRowIndex = 0

	public enum TimeType {

		case hour12
		case hour24
	}

	/// Hour Format: 12h (default) or 24h format
	public var timeType = TimeType.hour12

	// MARK: - Methods
	override public func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		self.title = "Change Time"
		self.view.backgroundColor = #colorLiteral(red: 1, green: 0.5019607843, blue: 0, alpha: 1)

		setupTables()
		setupDetailView()
		setupBottomDetail()
		setupNavigationBar()
		setupTime()

	}

	override public func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
    
	}

	// MARK: Setup
	public func setupNavigationBar() {

		let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(butSave))
		saveButton.tintColor = #colorLiteral(red: 0.8949507475, green: 0.1438436359, blue: 0.08480125666, alpha: 1)

		let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(butCancel))
		cancelButton.tintColor = #colorLiteral(red: 0.8949507475, green: 0.1438436359, blue: 0.08480125666, alpha: 1)

		self.navigationItem.rightBarButtonItem = saveButton
		self.navigationItem.leftBarButtonItem = cancelButton
	}

	public func setupTables() {

		let frame1 = CGRect(x: 30, y: 0, width: 100, height: self.view.bounds.height)
		table = UITableView(frame: frame1, style: .plain)

		let frame2 = CGRect(x: self.view.frame.width - 100, y: 0, width: 100, height: self.view.bounds.height)

		table2 = UITableView(frame: frame2, style: .plain)

		table.separatorStyle = .none
		table2.separatorStyle = .none

		table.dataSource = self
		table.delegate = self
		table2.dataSource = self
		table2.delegate = self

		table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		table2.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

		table.backgroundColor = .clear()
		table2.backgroundColor = .clear()

		table.showsVerticalScrollIndicator = false
		table2.showsVerticalScrollIndicator = false

		table.allowsSelection = false
		table2.allowsSelection = false

		view.addSubview(table)
		view.addSubview(table2)

		self.view.sendSubview(toBack: table)
		self.view.sendSubview(toBack: table2)
	}

	public func setupDetailView() {

		detailBackgroundView = UIView(frame: CGRect(x: 0, y: (self.view.bounds.height / 5) * 2, width: self.view.bounds.width, height: self.view.bounds.height / 6))
		detailBackgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

		lblDetail = UILabel(frame: CGRect(x: 20, y: detailBackgroundView.frame.height / 2, width: 110, height: detailBackgroundView.frame.height))
		lblDetail.center = CGPoint(x: 60, y: detailBackgroundView.frame.height / 2)

		lblDetail.font = UIFont.systemFont(ofSize: 40)
		lblDetail.text = "11:11"
		lblDetail.textAlignment = .center

		lblDetail2 = UILabel(frame: CGRect(x: detailBackgroundView.frame.width / 7 * 6 + 20, y: detailBackgroundView.frame.height / 2, width: 110, height: detailBackgroundView.frame.height))
		lblDetail2.center = CGPoint(x: detailBackgroundView.bounds.width - 60, y: detailBackgroundView.frame.height / 2)

		lblDetail2.font = UIFont.systemFont(ofSize: 40)
		lblDetail2.text = "11:11"
		lblDetail2.textAlignment = .center

		detailBackgroundView.addSubview(lblDetail)
		detailBackgroundView.addSubview(lblDetail2)

		let lblTo = UILabel(frame: CGRect(x: detailBackgroundView.frame.width / 2, y: detailBackgroundView.frame.height / 2, width: 30, height: 20))
		lblTo.text = "TO"

		detailBackgroundView.addSubview(lblTo)

		self.view.addSubview(detailBackgroundView)
	}

	public func setupBottomDetail() {

		let bottomDetailMainBackground = UIView(frame: CGRect(x: 0, y: self.detailBackgroundView.frame.maxY, width: self.view.frame.width, height: 38))
		bottomDetailMainBackground.backgroundColor = #colorLiteral(red: 1, green: 0.5019607843, blue: 0, alpha: 1)
    
		let bottomDetailMainShade = UIView(frame: CGRect(x: 0, y: self.detailBackgroundView.frame.maxY, width: self.view.frame.width, height: 38))
		bottomDetailMainShade.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6)
      

		lblAMPM = UILabel(frame: CGRect(x: 20, y: bottomDetailMainShade.frame.height / 2, width: 110, height: bottomDetailMainShade.frame.height))
		lblAMPM.center = CGPoint(x: 60, y: bottomDetailMainShade.frame.height / 2)

		lblAMPM.font = UIFont.systemFont(ofSize: 15)
		lblAMPM.text = "AM"
		lblAMPM.textAlignment = .center

		lblAMPM2 = UILabel(frame: CGRect(x: bottomDetailMainShade.frame.width / 7 * 6 + 20, y: bottomDetailMainShade.frame.height / 2, width: 110, height: bottomDetailMainShade.frame.height))
		lblAMPM2.center = CGPoint(x: bottomDetailMainShade.bounds.width - 60, y: bottomDetailMainShade.frame.height / 2)

		lblAMPM2.font = UIFont.systemFont(ofSize: 15)
		lblAMPM2.text = "AM"
		lblAMPM2.textAlignment = .center

		bottomDetailMainShade.addSubview(lblAMPM)
		bottomDetailMainShade.addSubview(lblAMPM2)

		self.view.addSubview(bottomDetailMainBackground)
		self.view.addSubview(bottomDetailMainShade)
	}

	public func setupTime() {

		switch timeType {

		case TimeType.hour12:
			setupTimeArray12()
			break

		case TimeType.hour24:
			setupTimeArray24()
			break
		}
	}

	public func setupTimeArray12() {

		lblAMPM.isHidden = false
		lblAMPM2.isHidden = false

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
	}

	public func setupTimeArray24() {

		lblAMPM.isHidden = true
		lblAMPM2.isHidden = true

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
	}

	// MARK: Button Methods
	func butSave() {

		let time = self.lblDetail.text!
		let time2 = self.lblDetail2.text!

		if timeType == .hour12 {

			delegate?.didPickTime(time + " \(self.lblAMPM.text!)", end: time2 + " \(self.lblAMPM2.text!)")
		} else {

			delegate?.didPickTime(time, end: time2)
		}

    _ = self.navigationController?.popViewController(animated: true)
	}

	func butCancel() {

		_ = self.navigationController?.popViewController(animated: true)
	}
}

//MARK: - UITableViewDataSource
extension LFTimePickerController: UITableViewDataSource {

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return arr.count
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
		if !(cell != nil)
		{
			cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
		}

		// setup cell without force unwrapping it
		cell?.textLabel!.text = arr[(indexPath as NSIndexPath).row]
		cell?.textLabel?.textColor = .white()

		cell?.backgroundColor = .clear()
		return cell!
	}
}

//MARK: - UITableViewDelegate
extension LFTimePickerController: UITableViewDelegate {

	public func scrollViewDidScroll(_ scrollView: UIScrollView) {

		if table.visibleCells.count > 8 && table2.visibleCells.count > 8 {

			if (table.indexPathsForVisibleRows?.first as NSIndexPath?)?.row < 48 {

				self.lblAMPM.text = "AM"
			} else {

				self.lblAMPM.text = "PM"
			}

			if (table2.indexPathsForVisibleRows?.first as NSIndexPath?)?.row < 48 {

				self.lblAMPM2.text = "AM"
			} else {

				self.lblAMPM2.text = "PM"
			}

			let text = table.visibleCells[8]
			let text2 = table2.visibleCells[8]
      self.lblDetail.text = text.textLabel?.text
      self.lblDetail2.text = text2.textLabel?.text

//			if firstRowIndex != (table.indexPathsForVisibleRows?.first as NSIndexPath?)?.row {
//
//				UIView.animate(withDuration: 0.3, animations: {
//					self.lblDetail.center = CGPoint(x: 60, y: -5)
//					self.lblDetail.alpha = 0
//					}, completion: { (completed) in
//
//					self.lblDetail.center = CGPoint(x: 60, y: 130)
//					if text.textLabel?.text != "" {
//						self.lblDetail.text = text.textLabel?.text
//					}
//
//					UIView.animate(withDuration: 0.3, animations: {
//
//						self.lblDetail.center = CGPoint(x: 60, y: self.detailBackgroundView.frame.height / 2)
//						self.lblDetail.alpha = 1
//					})
//
//				})
//			}

			if text2.textLabel?.text != "" {
				self.lblDetail2.text = text2.textLabel?.text
			}

		}

		firstRowIndex = ((table.indexPathsForVisibleRows?.first as NSIndexPath?)?.row)!

	}
}

//Got from EZSwiftExtensions
extension Timer {

	public static func runThisAfterDelay(seconds: Double, after: () -> ()) {
		runThisAfterDelay(seconds: seconds, queue: DispatchQueue.main, after: after)
	}

	public static func runThisAfterDelay(seconds: Double, queue: DispatchQueue, after: () -> ()) {
		let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    
		queue.after(when: time, execute: after)
	}
}
