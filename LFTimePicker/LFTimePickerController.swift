//
//  LFTimePickerController.swift
//  LFTimePicker
//
//  Created by Lucas Farah on 6/1/16.
//  Copyright © 2016 Lucas Farah. All rights reserved.
//

import UIKit

//MARK: - LFTimePickerDelegate
protocol LFTimePickerDelegate: class {
  
 ///LFTimePickerController: Called after pressing save. Format: hh:mm aa
	func didPickTime(start: String, end: String)
}

class LFTimePickerController: UIViewController {

  //MARK: - Variables
  weak var delegate: LFTimePickerDelegate?
	var arr: [String] = []
	var table = UITableView()
	var table2 = UITableView()
	var lblDetail = UILabel()
	var lblDetail2 = UILabel()
	var detailBackgroundView = UIView()
	var lblAMPM = UILabel()
	var lblAMPM2 = UILabel()

  //MARK: - Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		self.title = "Change Time"
		self.view.backgroundColor = UIColor(red: 255 / 255, green: 128 / 255, blue: 0, alpha: 1)

		setupTimeArray()
		setupTables()
		setupDetailView()
		setupBottomDetail()
		setupNavigationBar()
	}
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  //MARK: Setup
	func setupNavigationBar() {

		let saveButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(butSave))
		saveButton.tintColor = .redColor()

		let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(butCancel))
		cancelButton.tintColor = .redColor()

		self.navigationItem.rightBarButtonItem = saveButton
		self.navigationItem.leftBarButtonItem = cancelButton
	}

	func setupTables() {

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

	func setupDetailView() {

		detailBackgroundView = UIView(frame: CGRect(x: 0, y: (self.view.bounds.height / 5) * 2, width: self.view.bounds.width, height: self.view.bounds.height / 6))
		detailBackgroundView.backgroundColor = .whiteColor()

		lblDetail = UILabel(frame: CGRect(x: 20, y: detailBackgroundView.frame.height / 2, width: 110, height: detailBackgroundView.frame.height))
		lblDetail.center = CGPointMake(60, detailBackgroundView.frame.height / 2)

		lblDetail.font = UIFont.systemFontOfSize(40)
		lblDetail.text = "11:11"
		lblDetail.textAlignment = .Center

		lblDetail2 = UILabel(frame: CGRect(x: detailBackgroundView.frame.width / 7 * 6 + 20, y: detailBackgroundView.frame.height / 2, width: 110, height: detailBackgroundView.frame.height))
		lblDetail2.center = CGPointMake(detailBackgroundView.bounds.width - 60, detailBackgroundView.frame.height / 2)

		lblDetail2.font = UIFont.systemFontOfSize(40)
		lblDetail2.text = "11:11"
		lblDetail2.textAlignment = .Center

		detailBackgroundView.addSubview(lblDetail)
		detailBackgroundView.addSubview(lblDetail2)

		let lblTo = UILabel(frame: CGRect(x: detailBackgroundView.frame.width / 2, y: detailBackgroundView.frame.height / 2, width: 30, height: 20))
		lblTo.text = "TO"

		detailBackgroundView.addSubview(lblTo)

		self.view.addSubview(detailBackgroundView)
	}

	func setupBottomDetail() {

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

	func setupTimeArray() {

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

  //MARK: Button Methods
	func butSave() {

		let time = self.lblDetail.text!
		let time2 = self.lblDetail2.text!

		delegate?.didPickTime(time + " \(self.lblAMPM.text!)", end: time2 + " \(self.lblAMPM2.text!)")

		self.navigationController?.popViewControllerAnimated(true)
	}

	func butCancel() {

		self.navigationController?.popViewControllerAnimated(true)
	}
}

//MARK: - UITableViewDataSource
extension LFTimePickerController: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return arr.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
		if !(cell != nil)
		{
			cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
		}

		// setup cell without force unwrapping it
		cell.textLabel!.text = arr[indexPath.row]
		cell.textLabel?.textColor = .whiteColor()

		cell.backgroundColor = .clearColor()
		return cell
	}

}

//MARK: - UITableViewDelegate
extension LFTimePickerController: UITableViewDelegate {

	func scrollViewDidScroll(scrollView: UIScrollView) {

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

			if text.textLabel?.text != "" {
				self.lblDetail.text = text.textLabel?.text
			}

			if text2.textLabel?.text != "" {
				self.lblDetail2.text = text2.textLabel?.text
			}
		}
	}
}
