//
//  AddEditImageVC.swift
//  PhotoJournal
//
//  Created by casandra grullon on 1/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import AVFoundation

enum PhotoState {
    case addingNew
    case editing
}

protocol SaveImageDelegate: AnyObject {
    func didSave(photo: PhotoJournal, state: PhotoState)
}

class AddEditImageVC: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var photoLibraryOutlet: UIBarButtonItem!
    
    weak var delegate: SaveImageDelegate?
    
    private let imagePicker = UIImagePickerController()
    
    public private(set) var state = PhotoState.addingNew
    
    var photo: PhotoJournal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        imagePicker.delegate = self
        updateUI()
    }
    
    func updateUI() {
        if let photo = photo {
            self.photo = photo
            textField.text = photo.name
            imageView.image = UIImage(data: photo.imageData)
            delegate?.didSave(photo: photo, state: .editing)
        } else {
            state = .addingNew
        }
    }
    
    private func savingImage() {
        guard let image = imageView.image else {
            return
        }
        let size = UIScreen.main.bounds.size
        
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        let resizeImage = image.resizeImage(to: rect.size.width, height: rect.size.height)
        
        guard let photoData = resizeImage.jpegData(compressionQuality: 1.0) else {
            return
        }
        photo = PhotoJournal(name: textField.text ?? "", imageData: photoData, dateCreated: Date())
        guard let pic = photo else {
            print("could not get pic")
            return
        }
        delegate?.didSave(photo: pic, state: .addingNew)
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        self.showImageController(isCameraSelected: false)
    }
    
    @IBAction func cameraButtonSelected(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.showImageController(isCameraSelected: true)
        } else {
            cameraButtonOutlet.isEnabled = false
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if state == .addingNew {
            savingImage()
        } else if state == .editing {
            updateUI()
        }
        dismiss(animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    private func showImageController(isCameraSelected: Bool) {
        imagePicker.sourceType = .photoLibrary
        if isCameraSelected {
            imagePicker.sourceType = .camera
        }
        present(imagePicker, animated: true)
    }
}

extension AddEditImageVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        photo?.name = textField.text ?? "no name"
        return true
    }
}
extension AddEditImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("could not down cast image")
        }
        imageView.image = image
        dismiss(animated: true)
    }
}
