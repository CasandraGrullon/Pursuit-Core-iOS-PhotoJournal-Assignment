//
//  ViewController.swift
//  PhotoJournal
//
//  Created by casandra grullon on 1/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class ImageCollectionVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos = [PhotoJournal]() {
        didSet {
            loadPhotos()
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotos()
    }

    func loadPhotos() {
        do {
           photos = try PersistanceHelper.loadData()
        } catch {
            print("issue loading photos \(error)")
        }
    }
    
    

}

