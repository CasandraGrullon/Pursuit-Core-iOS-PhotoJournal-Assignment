//
//  UserDefaulta.swift
//  PhotoJournal
//
//  Created by casandra grullon on 1/26/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation
import UIKit

enum Color: String {
    case darkGray = ".darkGray"
    case pink = ".pink"
    case lightGray = ".lightGray"
    case white = ".white"
}
enum ScrollDirection: Int {
    case horizontal = 0
    case vertical = 1
}

struct UserPreferenceKey {
    static let color = "Color"
    static let scrollDirection = "Scroll Direction"
}

class UserPreference {
    
    private init() {}
    
    static let shared = UserPreference()
    
    func updateColor(with color: Color.RawValue) {
        UserDefaults.standard.set(color, forKey: UserPreferenceKey.color)
    }
    func getColor() -> Color.RawValue? {
        guard let bgColor = UserDefaults.standard.object(forKey: UserPreferenceKey.color) as? String else {
            return nil
        }
        return bgColor
    }
    
    
}
