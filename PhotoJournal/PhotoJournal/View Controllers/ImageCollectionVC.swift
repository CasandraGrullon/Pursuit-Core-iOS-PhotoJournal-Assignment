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
    
    var backgroundColor: UIColor? {
        didSet {
            collectionView.backgroundColor = backgroundColor
            view.backgroundColor = backgroundColor
        }
    }
    
    var state = PhotoState.addingNew
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotos()
        collectionView.dataSource = self
        collectionView.delegate = self
        getUserPreferences()
    }
    
    private func getUserPreferences() {
        let button = UserPreference.shared.getColor()
        switch button{
        case 0:
            backgroundColor = .darkGray
            collectionView.backgroundColor = backgroundColor
            view.backgroundColor = backgroundColor
        case 1:
            backgroundColor = #colorLiteral(red: 1, green: 0.818012774, blue: 0.9189140201, alpha: 1)
            collectionView.backgroundColor = backgroundColor
            view.backgroundColor = backgroundColor
        case 2:
            backgroundColor = .lightGray
            collectionView.backgroundColor = backgroundColor
            view.backgroundColor = backgroundColor
        case 3:
            backgroundColor = .white
            collectionView.backgroundColor = backgroundColor
            view.backgroundColor = backgroundColor
        default:
            backgroundColor = .white
            collectionView.backgroundColor = backgroundColor
            view.backgroundColor = backgroundColor
        }
        
        guard let collectionScroll = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        let direction = UserPreference.shared.getDirection() ?? "vertical"
        
        switch ScrollDirection(rawValue: direction) {
        case .vertical:
            collectionScroll.scrollDirection = .vertical
        case .horizontal:
            collectionScroll.scrollDirection = .horizontal
        default:
            collectionScroll.scrollDirection = .vertical
        }
    }
    
    func loadPhotos() {
        do {
            photos = try dataPersistance.loadPhotos()
        } catch {
            print("issue loading photos \(error)")
        }
    }
    
    private func appendPhoto() {
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
        state = .addingNew
        showViewController()
    }
    
    //MARK: Show AddEdit View Controller
    private func showViewController(_ photo: PhotoJournal? = nil) {
        guard let addEditVC = storyboard?.instantiateViewController(identifier: "AddEditImageVC") as? AddEditImageVC else {
            fatalError("could not downcast to AddEditImageVC")
        }
        addEditVC.delegate = self
        addEditVC.photo = photo
        addEditVC.state = .editing
        present(addEditVC, animated: true)
        
        if addEditVC.state == .editing {
            let index = photos.firstIndex { $0.imageData == addEditVC.photo?.imageData }
            guard let itemIndex = index else { return }
            let oldPhoto = photos[itemIndex]
            
            guard let photo = addEditVC.photo else {
                return
            }
            update(old: oldPhoto, with: photo)
        } else {
            addEditVC.state = .addingNew
            return
        }
    }
    
    private func update(old: PhotoJournal, with new: PhotoJournal) {
        dataPersistance.updateItems(old, new)
        loadPhotos()
    }
    
    //MARK: Show Menu
    private func showMenu(for cell: PhotoCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        let optionsMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "Edit", style: .default) { [weak self] (action) in
            self?.state = .editing
            self?.showViewController(self?.photos[indexPath.row])
        }
        let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (action) in
            do{
                try self?.dataPersistance.delete(photo: indexPath.row)
                self?.loadPhotos()
                self?.collectionView.reloadData()
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
    
    //MARK: Segue to Settings
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsVC else {
            fatalError("could not segue to settings")
        }
        settingsVC.settingDelegate = self
    }
}

//MARK: Extensions
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
    
    
}
extension ImageCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth: CGFloat = UIScreen.main.bounds.size.width
        let itemWidth: CGFloat = maxWidth * 0.80
        return CGSize(width: itemWidth, height: itemWidth)  }
}

extension ImageCollectionVC: SaveImageDelegate {
    func didSave(photo: PhotoJournal, state: PhotoState) {
        if state == .addingNew {
            photos.append(photo)
            do {
                try dataPersistance.create(photo: photo)
            } catch {
                print("could not create photo")
            }
        } else if state == .editing {
            showViewController(photo)
        }
    }
}

extension ImageCollectionVC: CellDelegate {
    func didSelect(for cell: PhotoCell) {
        showMenu(for: cell)
    }
}
extension ImageCollectionVC: SettingDelegate {
    func didUpdateDirection(direction: ScrollDirection) {
        
        guard let collectionViewScroll = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        switch direction {
        case .horizontal:
            collectionViewScroll.scrollDirection = .horizontal
        case .vertical:
            collectionViewScroll.scrollDirection = .vertical
        }
    }
    
    func didUpdateColor(color: UIColor) {
        collectionView.backgroundColor = color
        view.backgroundColor = color
    }
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


