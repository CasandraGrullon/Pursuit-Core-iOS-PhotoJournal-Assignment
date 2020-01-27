//
//  SettingsVC.swift
//  PhotoJournal
//
//  Created by casandra grullon on 1/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    var backgroundColor: String? {
        didSet {
            UserPreference.shared.updateColor(with: backgroundColor ?? ".white")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: UserPreference.shared.getColor() ?? ".white")
    }

    
    @IBAction func backgroundColorButton(_ sender: UIButton) {
        switch sender.tag {
        case 0 :
            backgroundColor = sender.backgroundColor?.description
            UserPreference.shared.updateColor(with: backgroundColor ?? ".darkGray")
        case 1 :
            backgroundColor = sender.backgroundColor?.description
            UserPreference.shared.updateColor(with: backgroundColor ?? ".pink")
        case 2:
            backgroundColor = sender.backgroundColor?.description
            UserPreference.shared.updateColor(with: backgroundColor ?? ".lightGray")
        case 3:
            backgroundColor = sender.backgroundColor?.description
            UserPreference.shared.updateColor(with: backgroundColor ?? ".white")
        default:
            backgroundColor = ".white"
            UserPreference.shared.updateColor(with: backgroundColor ?? ".white")
        }
    }
    
    
    @IBAction func scrollDirectionButton(_ sender: UISegmentedControl) {
        if sender.isEnabledForSegment(at: 0) {
            
        } else if sender.isEnabledForSegment(at: 1) {
            
        }
    }
    
    
    
}
