//
//  PhotoCell.swift
//  PhotoJournal
//
//  Created by casandra grullon on 1/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    
    func configureCell(for image: PhotoJournal) {
        imageNameLabel.text = image.name
        dateCreatedLabel.text = image.dateCreated.description
        
        guard let image = UIImage(data: image.imageData) else {
            return
        }
        imageView.image = image
    }
    
    private func showMenu() {
        //TODO: add cell delegate
        
        let view = UIViewController()
        var optionsMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        var edit = UIAlertAction(title: "Edit", style: .default)
        var delete = UIAlertAction(title: "Delete", style: .destructive)
        var cancel = UIAlertAction(title: "Cancel", style: .cancel)
        optionsMenu.addAction(edit)
        optionsMenu.addAction(delete)
        optionsMenu.addAction(cancel)
        
        optionsMenu.present(view, animated: true, completion: nil)
//        present(optionsMenu, animated: true)
        
        
    }
    
    @IBAction func optionsButtonAction(_ sender: UIButton) {
        showMenu()
    }
}
