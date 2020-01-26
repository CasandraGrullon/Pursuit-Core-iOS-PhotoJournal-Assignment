//
//  SettingsVC.swift
//  PhotoJournal
//
//  Created by casandra grullon on 1/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    var backgroundColor: UIColor? {
        didSet {
            UserPreference.shared.updateColor(with: backgroundColor!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    @IBAction func backgroundColorButton(_ sender: UIButton) {
        
        switch sender.tag {
        case 0 :
            backgroundColor = sender.backgroundColor
            UserPreference.shared.updateColor(with: backgroundColor!)
        case 1 :
            backgroundColor = sender.backgroundColor
            UserPreference.shared.updateColor(with: backgroundColor!)
        case 2:
            backgroundColor = sender.backgroundColor
            UserPreference.shared.updateColor(with: backgroundColor!)
        case 3:
            backgroundColor = sender.backgroundColor
            UserPreference.shared.updateColor(with: backgroundColor!)
        default:
            backgroundColor = .white
            UserPreference.shared.updateColor(with: backgroundColor!)
        }
        
        
    }
    
    
    @IBAction func scrollDirectionButton(_ sender: UISegmentedControl) {
        if sender.isEnabledForSegment(at: 0) {
            
        } else if sender.isEnabledForSegment(at: 1) {
            
        }
    }
    
}
