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
     let url = FileManager.pathToDocumentsDirectory(with: filename)
    
    do {
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
  
  public func delete(photo index: Int) throws {
    photos.remove(at: index)
    
    do {
      try save()
    } catch {
      throw DataPersistenceError.deletingError(error)
    }
  }
}
