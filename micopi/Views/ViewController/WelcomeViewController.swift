//
//  WelcomeViewController.swift
//  micopi
//
//  Created by michel@easy-target.org on 2016-02-22.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import ContactsUI

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var pickerButton: UIButton!
    
    @IBOutlet weak var multiButton: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    fileprivate static let toContactViewSegue = "WelcomeToContactSegue"
    
    fileprivate static let toMultipleModeSegue = "WelcomeToMultiSegue"
    
    fileprivate static let toResetModeSegue = "WelcomeToResetSegue"
    
    // MARK: - UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = ColorPalette.backgroundGradient
        view.layer.insertSublayer(gradient, at: 0)
        
        pickerButton.layer.cornerRadius = 4
        pickerButton.layer.borderColor = UIColor.white.cgColor
        pickerButton.layer.borderWidth = 1
        pickerButton.layer.masksToBounds = true
        
        multiButton.layer.cornerRadius = 4
        multiButton.layer.borderColor = UIColor.white.cgColor
        multiButton.layer.borderWidth = 1
        multiButton.layer.masksToBounds = true
        
//        resetButton.layer.cornerRadius = 4
//        resetButton.layer.borderColor = UIColor.white.cgColor
//        resetButton.layer.borderWidth = 1
//        resetButton.layer.masksToBounds = true
//        
//        settingsButton.layer.cornerRadius = 4
//        settingsButton.layer.borderColor = UIColor.white.cgColor
//        settingsButton.layer.borderWidth = 1
//        settingsButton.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: Navigation

    @IBAction func onSelectContactTouched(_ sender: AnyObject) {
        self.performSegue(
            withIdentifier: WelcomeViewController.toContactViewSegue,
            sender: nil
        )
    }
    
    @IBAction func onMultipleButtonTouched(_ sender: Any) {
        self.performSegue(
            withIdentifier: WelcomeViewController.toMultipleModeSegue,
            sender: nil
        )
    }
    
    @IBAction func onResetButtonTouched(_ sender: Any) {
        self.performSegue(
            withIdentifier: WelcomeViewController.toResetModeSegue,
            sender: nil
        )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case WelcomeViewController.toMultipleModeSegue:
            let viewController = segue.destination as! MultiModeViewController
            viewController.mode = .assign
        
        case WelcomeViewController.toResetModeSegue:
            let viewController = segue.destination as! MultiModeViewController
            viewController.mode = .reset
            
        default:
            return
        }

    }

}
