//
//  PersistanceHelper.swift
//  PhotoJournal
//
//  Created by casandra grullon on 1/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

enum DataPersistenceError: Error { // conforming to the Error protocol
    case savingError(Error) // associative value
    case fileDoesNotExist(String)
    case noData
    case decodingError(Error)
    case deletingError(Error)
}


class PersistenceHelper {
    
    private var photos = [PhotoJournal]()
    
    private var filename: String
    
    init(filename: String) {
        self.filename = filename
    }
    
    private func save() throws {
        do {
            let url = FileManager.pathToDocumentsDirectory(with: filename)
            let data = try PropertyListEncoder().encode(photos)
            
            try data.write(to: url, options: .atomic)
        } catch {
            throw DataPersistenceError.savingError(error)
        }
    }
    
    public func reorder(photos: [PhotoJournal]) {
        self.photos = photos
        try? save()
    }
    
    public func create(photo: PhotoJournal) throws {
        photos.append(photo)
        
        do {
            try save()
        } catch {
            throw DataPersistenceError.savingError(error)
        }
    }
    
    public func loadPhotos() throws -> [PhotoJournal] {
        let url = FileManager.pathToDocumentsDirectory(with: filename)
        
        if FileManager.default.fileExists(atPath: url.path) {
            if let data = FileManager.default.contents(atPath: url.path) {
                do {
                    photos = try PropertyListDecoder().decode([PhotoJournal].self, from: data)
                } catch {
                    throw DataPersistenceError.decodingError(error)
                }
            } else {
                throw DataPersistenceError.noData
            }
        }
        else {
            throw DataPersistenceError.fileDoesNotExist(filename)
        }
        return photos
    }
    
    @discardableResult
    public func updateItems(_ olditem: PhotoJournal, _ newitem: PhotoJournal) -> Bool {
        if let index = photos.firstIndex(of: olditem) {
            let result = updateWithIndex(newitem, at: index)
            return result
        }
        return false
    }
    
    @discardableResult
    public func updateWithIndex(_ item: PhotoJournal, at index: Int) -> Bool {
        photos[index] = item
        do {
            try save()
            return true
        } catch {
            return false
        }
    }
    
    public func delete(photo index: Int) throws {
        photos.remove(at: index)
        do {
            try save()
        } catch {
            throw DataPersistenceError.deletingError(error)
        }
    }
}
