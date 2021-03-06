//
//  PhotoJournal.swift
//  PhotoJournal
//
//  Created by casandra grullon on 1/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

struct PhotoJournal: Codable & Equatable {
    var name: String
    let imageData: Data
    let dateCreated: Date
}
