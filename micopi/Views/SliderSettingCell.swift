//
//  SliderSettingCell.swift
//  micopi
//
//  Created by Michel Sievers on 16/03/2017.
//  Copyright © 2017 Easy Target. All rights reserved.
//

import UIKit

class SliderSettingCell: UITableViewCell {
    
    static let identifier = "SliderSettingCell"
    
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var slider: UISlider!
    
    var intSteps = false
    
//    fileprivate var lastIntValue =
    
    var sliderValueChangedHandler: ((Float) -> ())!
    
    var sliderIntValueChangedHandler: ((Int) -> ())!
    
    @IBAction func onSliderValueChanged(_ sender: Any) {
        if intSteps {
            let roundedValue = slider.value.rounded()
            slider.setValue(roundedValue, animated: true)
            sliderIntValueChangedHandler(Int(roundedValue))
        } else {
            sliderValueChangedHandler(slider.value)
        }
    }

}
