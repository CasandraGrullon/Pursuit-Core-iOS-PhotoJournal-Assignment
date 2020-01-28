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
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private var currentSegmentIndex: Int = 0 {
        didSet {
            switch segmentControl.selectedSegmentIndex {
            case 0 :
                direction = .vertical
                UserPreference.shared.updateDirection(with: direction)
                settingDelegate?.didUpdateDirection(direction: direction)
            case 1 :
                direction = .horizontal
                UserPreference.shared.updateDirection(with: direction)
                settingDelegate?.didUpdateDirection(direction: direction)
            default :
                direction = .vertical
                UserPreference.shared.updateDirection(with: direction)
                settingDelegate?.didUpdateDirection(direction: direction)
            }
        }
    }
    
    @IBAction func backgroundColorButton(_ sender: UIButton) {
        backgroundColor = sender.tintColor
        settingDelegate?.didUpdateColor(color: backgroundColor ?? .white)
        UserPreference.shared.updateColor(with: sender.tag)
    }
    
    @IBAction func scrollDirectionButton(_ sender: UISegmentedControl) {
        currentSegmentIndex = sender.selectedSegmentIndex
        UserPreference.shared.updateDirection(with: direction)
        settingDelegate?.didUpdateDirection(direction: direction)
    }
    
    
}
