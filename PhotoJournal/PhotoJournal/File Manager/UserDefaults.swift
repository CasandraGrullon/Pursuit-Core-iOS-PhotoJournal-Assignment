//
//  UserDefaulta.swift
//  PhotoJournal
//
//  Created by casandra grullon on 1/26/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation
import UIKit

enum ScrollDirection: String {
    case horizontal = "horizontal"
    case vertical = "vertical"
}

struct UserPreferenceKey {
    static let color = "Color"
    static let scrollDirection = "Scroll Direction"
}

class UserPreference {
    
    private init() {}
    
    static let shared = UserPreference()
    
    func updateColor(with color: Int) {
        UserDefaults.standard.set(color, forKey: UserPreferenceKey.color)
    }
    func getColor() -> Int? {
        guard let bgColor = UserDefaults.standard.object(forKey: UserPreferenceKey.color) as? Int else {
            return nil
        }
        return bgColor
    }
    
    
}
