//
//  SettingsVC.swift
//  PhotoJournal
//
//  Created by casandra grullon on 1/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
enum ScrollDirection: String {
    case horizontal = "horizontal"
    case vertical = "vertical"
}
protocol SettingDelegate: AnyObject {
    func didUpdateColor(color: UIColor)
    func didUpdateDirection(direction: ScrollDirection)
}

class SettingsVC: UIViewController {

    var backgroundColor: UIColor?
    weak var settingDelegate: SettingDelegate?
    var direction = ScrollDirection.vertical
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backgroundColorButton(_ sender: UIButton) {
        backgroundColor = sender.tintColor
        settingDelegate?.didUpdateColor(color: backgroundColor ?? .white)
        UserPreference.shared.updateColor(with: sender.tag)
    }
    
    @IBAction func scrollDirectionButton(_ sender: UISegmentedControl) {
        switch sender.tag {
        case 0:
            direction = .vertical
        case 1:
            direction = .horizontal
        default:
            direction = .vertical
        }
        UserPreference.shared.updateDirection(with: direction)
        settingDelegate?.didUpdateDirection(direction: direction)
    }
    
    
}
