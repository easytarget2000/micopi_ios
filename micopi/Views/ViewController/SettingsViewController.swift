//
//  SettingsViewControllerTableViewController.swift
//  micopi
//
//  Created by Michel Sievers on 16/03/2017.
//  Copyright © 2017 Easy Target. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    @IBAction func onDoneButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return self.tableView(tableView, askOverwriteCellForRowAt: indexPath)
        
        case 1:
            return self.tableView(tableView, overdrawCellForRowAt: indexPath)
        
        case 2:
            return self.tableView(tableView, initialsCellForRowAt: indexPath)
            
        default:
            return UITableViewCell()
        }
    }
    
    fileprivate func tableView(_ tableView: UITableView, askOverwriteCellForRowAt indexPath: IndexPath) -> SwitchSettingCell {
        let overwriteCell = tableView.dequeueReusableCell(
            withIdentifier: SwitchSettingCell.identifier,
            for: indexPath
            ) as! SwitchSettingCell
        
        overwriteCell.label.text = "Always ask before overwriting images."
        overwriteCell.valueSwitch.isOn = DefaultsCoordinator.askBeforeOverwrite()
        overwriteCell.switchValueChangeHandler = {
            (value) in
            DefaultsCoordinator.set(askBeforeOverwrite: value)
        }
        return overwriteCell
    }
    
    fileprivate func tableView(_ tableView: UITableView, overdrawCellForRowAt indexPath: IndexPath) -> SwitchSettingCell {
        let useBGCell = tableView.dequeueReusableCell(
            withIdentifier: SwitchSettingCell.identifier,
            for: indexPath
        ) as! SwitchSettingCell
        
        useBGCell.label.text = "Draw over existing images."
        useBGCell.valueSwitch.isOn = DefaultsCoordinator.overdrawExistingImage()
        useBGCell.switchValueChangeHandler = {
            (value) in
            DefaultsCoordinator.set(overdrawExistingImage: value)
        }
        
        return useBGCell
    }
    
    fileprivate func tableView(_ tableView: UITableView, initialsCellForRowAt indexPath: IndexPath) -> SliderSettingCell {
        let initialsCell = tableView.dequeueReusableCell(
            withIdentifier: SliderSettingCell.identifier,
            for: indexPath
        ) as! SliderSettingCell
        
    
        let currentValue = DefaultsCoordinator.preferredNumberOfInitials()
        initialsCell.label.text = initialsLabel(textForValue: currentValue)
        initialsCell.slider.minimumValue = 0
        initialsCell.slider.maximumValue = 2
        initialsCell.slider.setValue(Float(currentValue), animated: true)
        initialsCell.intSteps = true
        initialsCell.sliderIntValueChangedHandler = {
            (value) in
            DefaultsCoordinator.set(preferredNumberOfInitials: value)
            initialsCell.label.text = self.initialsLabel(textForValue: value)
        }
        
        return initialsCell
    }
    
    fileprivate func initialsLabel(textForValue value: Int) -> String {
        var text = "Maximum length of initials: "
        switch value {
        case 1:
            text += "A"
        case 2:
            text += "AB"
        case 3:
            text += "ABC"
        default:
            break
        }
        
        return text
    }

}
