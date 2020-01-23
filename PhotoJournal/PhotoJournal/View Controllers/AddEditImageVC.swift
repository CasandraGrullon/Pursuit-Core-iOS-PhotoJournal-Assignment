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
    func didSave(_photo: PhotoJournal)
}

class AddEditImageVC: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate: SaveImageDelegate?
    
    private let imagePicker = UIImagePickerController()
    //private let dataPersistance = PersistenceHelper(filename: "images.plist")
    
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
            state = .editing
        } else {
//            photo = PhotoJournal(name: "", imageData: imageView.image?.jpegData(compressionQuality: 1.0), description: "", dateCreated: Date())
            state = .addingNew
        }
    }
    
    func savingImage() {
        guard let pic = photo else {
            return
        }
        delegate?.didSave(_photo: pic)
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        self.showImageController(isCameraSelected: false)
    }
    
    @IBAction func cameraButtonSelected(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.showImageController(isCameraSelected: true)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
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
