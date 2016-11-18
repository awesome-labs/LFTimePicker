//
//  LFTimePickerController.swift
//  LFTimePicker
//
//  Created by Lucas Farah on 6/1/16.
//  Copyright © 2016 Lucas Farah. All rights reserved.
//

import UIKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


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
    func didPickTime(_ start: String, end: String)
}

/**
 ViewController that handles the Time Picking
 - customizations: timeType, startTimes, endTimes
 */
open class LFTimePickerController: UIViewController {
    
    // MARK: - Variables
    open weak var delegate: LFTimePickerDelegate?
    var startTimes: [String] = []
    var endTimes: [String] = []
    
    var leftTimeTable = UITableView()
    var rightTimeTable = UITableView()
    var lblLeftTimeSelected  = UILabel()
    var lblRightTimeSelected = UILabel()
    var detailBackgroundView = UIView()
    var lblAMPM = UILabel()
    var lblAMPM2 = UILabel()
    var firstRowIndex = 0
    var lastSelectedLeft = "00:00"
    var lastSelectedRight = "00:00"

    
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
    open var timeType = TimeType.hour12
    
    // MARK: - Methods
    
    /// Used to load all the setup methods
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    var alreadyLayout = false
    open override func viewWillLayoutSubviews() {
        
        if !alreadyLayout {
        self.title = "Change Time"
        self.view.backgroundColor = UIColor(red: 255 / 255, green: 128 / 255, blue: 0, alpha: 1)
        
        setupTables()
        setupDetailView()
        setupBottomDetail()
        setupNavigationBar()
        setupTime()
            
            alreadyLayout = true
        }
    }
    
    // MARK: Setup
    fileprivate func setupNavigationBar() {
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(butSave))
        saveButton.tintColor = .red
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(butCancel))
        cancelButton.tintColor = .red
        
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    fileprivate func setupTables() {
        
        let frame1 = CGRect(x: 30, y: 0, width: 100, height: self.view.bounds.height)
        leftTimeTable = UITableView(frame: frame1, style: .plain)
        
        let frame2 = CGRect(x: self.view.frame.width - 100, y: 0, width: 100, height: self.view.bounds.height)
        
        rightTimeTable = UITableView(frame: frame2, style: .plain)
        
        leftTimeTable.separatorStyle = .none
        rightTimeTable.separatorStyle = .none
        
        leftTimeTable.dataSource = self
        leftTimeTable.delegate = self
        rightTimeTable.dataSource = self
        rightTimeTable.delegate = self
        
        leftTimeTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        rightTimeTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        leftTimeTable.backgroundColor = .clear
        rightTimeTable.backgroundColor = .clear
        
        leftTimeTable.showsVerticalScrollIndicator = false
        rightTimeTable.showsVerticalScrollIndicator = false
        
        leftTimeTable.allowsSelection = false
        rightTimeTable.allowsSelection = false
        
        view.addSubview(leftTimeTable)
        view.addSubview(rightTimeTable)
        
        self.view.sendSubview(toBack: leftTimeTable)
        self.view.sendSubview(toBack: rightTimeTable)
    }
    
    fileprivate func setupDetailView() {
        
        detailBackgroundView = UIView(frame: CGRect(x: 0, y: (self.view.bounds.height / 5) * 2, width: self.view.bounds.width, height: self.view.bounds.height / 6))
        detailBackgroundView.backgroundColor = .white
        
        lblLeftTimeSelected = UILabel(frame: CGRect(x: 20, y: detailBackgroundView.frame.height / 2, width: 110, height: detailBackgroundView.frame.height))
        lblLeftTimeSelected.center = CGPoint(x: 60, y: detailBackgroundView.frame.height / 2)
        
        lblLeftTimeSelected.font = UIFont.systemFont(ofSize: 40)
        lblLeftTimeSelected.text = "00:00"
        lblLeftTimeSelected.textAlignment = .center
        
        lblRightTimeSelected = UILabel(frame: CGRect(x: detailBackgroundView.frame.width / 7 * 6 + 20, y: detailBackgroundView.frame.height / 2, width: 110, height: detailBackgroundView.frame.height))
        lblRightTimeSelected.center = CGPoint(x: detailBackgroundView.bounds.width - 60, y: detailBackgroundView.frame.height / 2)
        
        lblRightTimeSelected.font = UIFont.systemFont(ofSize: 40)
        lblRightTimeSelected.text = "00:00"
        lblRightTimeSelected.textAlignment = .center
        
        detailBackgroundView.addSubview(lblLeftTimeSelected)
        detailBackgroundView.addSubview(lblRightTimeSelected)
        
        let lblTo = UILabel(frame: CGRect(x: detailBackgroundView.frame.width / 2, y: detailBackgroundView.frame.height / 2, width: 30, height: 20))
        lblTo.text = "TO"
        
        detailBackgroundView.addSubview(lblTo)
        
        self.view.addSubview(detailBackgroundView)
    }
    
    fileprivate func setupBottomDetail() {
        
        let bottomDetailMainBackground = UIView(frame: CGRect(x: 0, y: self.detailBackgroundView.frame.maxY, width: self.view.frame.width, height: 38))
        bottomDetailMainBackground.backgroundColor = UIColor(red: 255 / 255, green: 128 / 255, blue: 0, alpha: 1)
        
        let bottomDetailMainShade = UIView(frame: CGRect(x: 0, y: self.detailBackgroundView.frame.maxY, width: self.view.frame.width, height: 38))
        bottomDetailMainShade.backgroundColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0.6)
        
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
    
    fileprivate func setupTime() {
        
        if !isCustomTime {
            
            switch timeType {
                
            case TimeType.hour12:
                lblAMPM.isHidden = false
                lblAMPM2.isHidden = false

                startTimes = defaultTimeArray12()
                endTimes = defaultTimeArray12()
                break
                
            case TimeType.hour24:
                lblAMPM.isHidden = true
                lblAMPM2.isHidden = true

                startTimes = defaultTimeArray24()
                endTimes = defaultTimeArray24()
                break
            }
        } else {
            
            lblAMPM.isHidden = true
            lblAMPM2.isHidden = true
        }
    }
    
    func defaultTimeArray12() -> [String] {
        
        var arr: [String] = []
        
        for _ in 0...8 {
            arr.append("")
        }
        
        for ampm in 0...1 {
            for hr in 0...11 {
                for min in 0 ..< 12 {
                    
                    if min == 0 && ampm == 1 && hr == 0 {
                        arr.append("12:00")
                    } else if hr == 0 && ampm == 1 {
                        
                        var minute = "\(min * 5)"
                        minute = minute.characters.count == 1 ? "0"+minute : minute
                        arr.append("12:\(minute)")
                        
                    } else if min == 0 {
                        arr.append("\(hr):00")
                    } else {
                        var minute = "\(min * 5)"
                        minute = minute.characters.count == 1 ? "0"+minute : minute
                        arr.append("\(hr):\(minute)")
                    }
                }
            }
        }
        
        for _ in 0...8 {
            arr.append("")
        }
        
        return arr
    }
    
    func defaultTimeArray24() -> [String] {
        
        var arr: [String] = []
        lblAMPM.isHidden = true
        lblAMPM2.isHidden = true
        
        for _ in 0...8 {
            arr.append("")
        }
        
        for hr in 0...23 {
            for min in 0 ..< 12 {
                
                if min == 0 {
                    arr.append("\(hr):00")
                } else {
                    var minute = "\(min * 5)"
                    minute = minute.characters.count == 1 ? "0"+minute : minute
                    arr.append("\(hr):\(minute)")
                }
            }
            leftTimeTable.reloadData()
        }
        
        for _ in 0...8 {
            arr.append("")
        }
        
        return arr
    }
    
    // MARK: Button Methods
    @objc fileprivate func butSave() {
        
        let time = self.lblLeftTimeSelected.text!
        let time2 = self.lblRightTimeSelected.text!
        
        if isCustomTime {
            
            delegate?.didPickTime(time, end: time2)
        } else if timeType == .hour12 {
            
            delegate?.didPickTime(time + " \(self.lblAMPM.text!)", end: time2 + " \(self.lblAMPM2.text!)")
        } else {
            
            delegate?.didPickTime(time, end: time2)
        }
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func butCancel() {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK - Customisations
    open func customizeTimes(_ timesArray: [String], time: Time) {
        
        isCustomTime = true
        switch time {
        case .startTime:
            startTimes = timesArray
            leftTimeTable.reloadData()
            
            for _ in 0...8 {
                startTimes.insert("", at: 0)
            }
            for _ in 0...8 {
                startTimes.append("")
            }
            
        case .endTime:
            endTimes = timesArray
            rightTimeTable.reloadData()
            
            for _ in 0...8 {
                endTimes.insert("", at: 0)
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
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == leftTimeTable {
            
            return startTimes.count
        } else if tableView == rightTimeTable {
            
            return endTimes.count
        }
        return 0
    }
    
    // Setup of Time cells
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        if !(cell != nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        // setup cell without force unwrapping it
        var arr: [String] = []
        if tableView == leftTimeTable {
            
            arr = startTimes
        } else if tableView == rightTimeTable {
            
            arr = endTimes
        }
        
        cell?.textLabel!.text = arr[indexPath.row]
        cell?.textLabel?.textColor = .white
        
        cell?.backgroundColor = .clear
        return cell!
    }
}

//MARK: - UITableViewDelegate
extension LFTimePickerController: UITableViewDelegate {
    
    /// Used to change AM from PM
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if leftTimeTable.visibleCells.count > 8 {
            
            let isLeftAM = leftTimeTable.indexPathsForVisibleRows?.first?.row < 48 * 3
            self.lblAMPM.text = isLeftAM ? "AM" : "PM"
            
            
            let text = leftTimeTable.visibleCells[8]
            if text.textLabel?.text != "" {
                self.lblLeftTimeSelected.text = text.textLabel?.text
                lastSelectedLeft = (text.textLabel?.text!)!
            } else {
                self.lblLeftTimeSelected.text = lastSelectedLeft

            }

        } else {
            self.lblLeftTimeSelected.text = "00:00"
        }
        
        if rightTimeTable.visibleCells.count > 8 {
            let isRightAM = rightTimeTable.indexPathsForVisibleRows?.first?.row < 48 * 3
            self.lblAMPM2.text = isRightAM ? "AM" : "PM"
            let text2 = rightTimeTable.visibleCells[8]
            
            if text2.textLabel?.text != "" {
                self.lblRightTimeSelected.text = text2.textLabel?.text
                lastSelectedRight = (text2.textLabel?.text!)!
            } else {
                self.lblRightTimeSelected.text = lastSelectedRight
            }
        } else {
            lblRightTimeSelected.text = "00:00"
        }
        
        if let rowIndex = leftTimeTable.indexPathsForVisibleRows?.first?.row {
            firstRowIndex = rowIndex
        }
        if let rowIndex = rightTimeTable.indexPathsForVisibleRows?.first?.row {
            firstRowIndex = rowIndex
        }

        
    }
}

//Got from EZSwiftExtensions
extension Timer {
    
    fileprivate static func runThisAfterDelay(seconds: Double, after: @escaping () -> ()) {
        runThisAfterDelay(seconds: seconds, queue: DispatchQueue.main, after: after)
    }
    
    fileprivate static func runThisAfterDelay(seconds: Double, queue: DispatchQueue, after: @escaping () -> ()) {
        let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        queue.asyncAfter(deadline: time, execute: after)
    }
}
