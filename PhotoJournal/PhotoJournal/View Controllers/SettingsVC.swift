//
//  SettingsVC.swift
//  PhotoJournal
//
//  Created by casandra grullon on 1/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

protocol SettingDelegate: AnyObject {
    func didUpdateColor(color: UIColor)
}

class SettingsVC: UIViewController {

    var backgroundColor: UIColor?
    weak var settingDelegate: SettingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backgroundColorButton(_ sender: UIButton) {
        backgroundColor = sender.tintColor
        settingDelegate?.didUpdateColor(color: backgroundColor ?? .white)
        UserPreference.shared.updateColor(with: sender.tag)
    }
    
    @IBAction func scrollDirectionButton(_ sender: UISegmentedControl) {
        if sender.isEnabledForSegment(at: 0) {
            
        } else if sender.isEnabledForSegment(at: 1) {
            
        }
    }
    
    
}
