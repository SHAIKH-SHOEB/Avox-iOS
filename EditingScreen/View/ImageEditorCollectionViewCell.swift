//
//  ImageEditorCollectionViewCell.swift
//  Avox
//
//  Created by Shaikh Shoeb on 03/08/24.
//

import UIKit

class ImageEditorCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: ImageEditorCollectionViewCell.self)
    
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var filterNameLabel: UILabel!
    
    func updateCollectionViewCellForEditorImage(image: UIImage, title: String) {
        filterImageView.image = image
        filterNameLabel.text = title
    }
}
