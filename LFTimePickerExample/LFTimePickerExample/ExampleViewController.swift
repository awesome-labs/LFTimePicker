//
//  ExampleViewController.swift
//  LFTimePicker
//
//  Created by Lucas Farah on 6/2/16.
//  Copyright © 2016 Lucas Farah. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {
  
  //MARK: - Outlets
  @IBOutlet weak var lblStartSelectedTime: UILabel!
  @IBOutlet weak var lblFinishSelectedTime: UILabel!
  
  //MARK: - Variables
  let timePicker = LFTimePickerController()
  
  //MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    timePicker.delegate = self
  }
  
  @IBAction func butShowTime(sender: AnyObject) {
    
    self.navigationController?.pushViewController(timePicker, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

//MARK: - LFTimePickerDelegate
extension ExampleViewController: LFTimePickerDelegate {
  
  func didPickTime(start: String, end: String) {
    self.lblStartSelectedTime.text = start
    
    self.lblFinishSelectedTime.text = end
    
    print(start)
    print(end)
  }
}
