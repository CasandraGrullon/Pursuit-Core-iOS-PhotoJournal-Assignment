//
//  ViewController.swift
//  PhotoJournal
//
//  Created by casandra grullon on 1/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import AVFoundation

class ImageCollectionVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let dataPersistance = PersistenceHelper(filename: "images.plist")
    
    var photos = [PhotoJournal]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var selectedImage: UIImage? {
        didSet {
            appendPhoto()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotos()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func loadPhotos() {
        do {
            photos = try dataPersistance.loadPhotos()
        } catch {
            print("issue loading photos \(error)")
        }
    }
    
    func appendPhoto() {
        guard let image = selectedImage else {
            print("image is nil")
            return
        }
        let size = UIScreen.main.bounds.size
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        let smallImage = image.resizeImage(to: rect.size.width, height: rect.size.height)
        guard let imageData = smallImage.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        let photo = PhotoJournal(name: "" , imageData: imageData, dateCreated: Date())
        photos.insert(photo, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView.insertItems(at: [indexPath])
        
        do {
            try dataPersistance.create(photo: photo)
        } catch {
            print("error saving \(error)")
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showViewController()
    }
    
    private func showViewController(_ photo: PhotoJournal? = nil) {
        guard let addEditVC = storyboard?.instantiateViewController(identifier: "AddEditImageVC") as? AddEditImageVC else {
            fatalError("could not downcast to AddEditImageVC")
        }
        addEditVC.delegate = self
        addEditVC.photo = photo
        
        present(addEditVC, animated: true)
    }
    
    private func showMenu(for cell: PhotoCell? = nil) {
//        let view = UIViewController()
        
        guard let cell = cell else {
            return
        }
        
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        let optionsMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let edit = UIAlertAction(title: "Edit", style: .default) { [weak self] (action) in
            self?.showViewController()
        }
        let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (action) in
            do{
                try self?.dataPersistance.delete(photo: indexPath.row)
            }catch{
                print("could not delete")
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] (action) in
            self?.dismiss(animated: true)
        }
        optionsMenu.addAction(edit)
        optionsMenu.addAction(delete)
        optionsMenu.addAction(cancel)

         present(optionsMenu, animated: true, completion: nil)
    }
    
}

extension ImageCollectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else {
            fatalError("")
        }
        let photo = photos[indexPath.row]
        cell.configureCell(for: photo)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        
    }

}
extension ImageCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth: CGFloat = UIScreen.main.bounds.size.width
        let itemWidth: CGFloat = maxWidth * 0.80
        return CGSize(width: itemWidth, height: itemWidth)  }
}
extension UIImage {
    func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension ImageCollectionVC: SaveImageDelegate {
    func didSave(photo: PhotoJournal) {
        photos.append(photo)
        
        do {
            try dataPersistance.create(photo: photo)
        } catch {
            print("could not create photo")
        }
    }
}

extension ImageCollectionVC: CellDelegate {
    func didSelect(sender: UIButton) {
        //showMenu()
        print("hi")
let optionsMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

let edit = UIAlertAction(title: "Edit", style: .default) { [weak self] (action) in
    self?.showViewController()
}
let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (action) in
    do{
//        try self?.dataPersistance.delete(photo: indexPath.row)
    }catch{
        print("could not delete")
    }
}
let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] (action) in
    self?.dismiss(animated: true)
}
optionsMenu.addAction(edit)
optionsMenu.addAction(delete)
optionsMenu.addAction(cancel)

present(optionsMenu, animated: true)
    }
}
