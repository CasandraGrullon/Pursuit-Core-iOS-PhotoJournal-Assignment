//
//  PhotoCell.swift
//  PhotoJournal
//
//  Created by casandra grullon on 1/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import AVFoundation

protocol CellDelegate: AnyObject {
    func didSelect(sender: UIButton)
}

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    
    weak var delegate: CellDelegate?
    
    lazy var dateFormatter:  DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "MMMM d, yyyy h:mm a"
      formatter.timeZone = .current
      return formatter
    }()
    
    func configureCell(for image: PhotoJournal) {
        imageNameLabel.text = image.name
        
        dateCreatedLabel.text = dateFormatter.string(from: image.dateCreated)
        
        guard let image = UIImage(data: image.imageData) else {
            return
        }
        imageView.image = image
    }
    
    @IBAction func optionsButtonAction(_ sender: UIButton) {
        delegate?.didSelect(sender: sender)
    }
}
