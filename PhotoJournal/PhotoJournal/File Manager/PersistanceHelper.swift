//
//  PersistanceHelper.swift
//  PhotoJournal
//
//  Created by casandra grullon on 1/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

enum DataPersistanceError: Error {
    case savingError(Error)
    case fileDoesNotExist(String)
    case noData
    case decodingError(Error)
    case deletingError(Error)
}

class PersistanceHelper {
    private static var photos = [PhotoJournal]()
    private static var filename = "photojournal.plist"
    
    private static func save() throws {
        let url = FileManager.pathToDocumentsDirectory(with: filename)
        do {
            let data = try PropertyListEncoder().encode(photos)
            try data.write(to: url, options: .atomic)
        } catch {
            throw DataPersistanceError.savingError(error)
        }
    }
    
    static func create(photo: PhotoJournal) throws {
        photos.append(photo)
        do {
            try save()
        } catch {
            throw DataPersistanceError.savingError(error)
        }
    }
    
    static func loadData() throws -> [PhotoJournal] {
        let url = FileManager.pathToDocumentsDirectory(with: filename)
        if FileManager.default.fileExists(atPath: url.path) {
            if let data = FileManager.default.contents(atPath: url.path) {
                do {
                    photos = try PropertyListDecoder().decode([PhotoJournal].self, from: data)
                } catch {
                    throw DataPersistanceError.decodingError(error)
                }
            } else {
                throw DataPersistanceError.noData
            }
        } else {
            throw DataPersistanceError.fileDoesNotExist(filename)
        }
        return photos
    }
    
    static func deletePhoto(photo index: Int) throws {
        photos.remove(at: index)
        do {
            try save()
        } catch {
            throw DataPersistanceError.deletingError(error)
        }
    }
}
