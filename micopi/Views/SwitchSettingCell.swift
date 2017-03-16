//
//  SwitchSettingCell.swift
//  micopi
//
//  Created by Michel Sievers on 16/03/2017.
//  Copyright © 2017 Easy Target. All rights reserved.
//

import UIKit

class SwitchSettingCell: UITableViewCell {
    
    static let identifier = "SwitchSettingCell"

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var valueSwitch: UISwitch!
    
    var switchValueChangeHandler: ((Bool) -> ())!

    @IBAction func onSwitchValueChanged(_ sender: Any) {
        switchValueChangeHandler(valueSwitch.isOn)
    }
    
}
