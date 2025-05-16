//
//  ImageCollectionViewCell.swift
//  Avox
//
//  Created by Nimap on 26/01/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadBaseView()
    }

    func loadBaseView() {
        self.backgroundColor = UIColor.clear
        imageView.layer.cornerRadius = 10.0
        AppUtils.applyShadowOnImage(imageView: imageView)
    }
    
    func updateDownloadCollectionViewCell(model: String) {
        if let fileURL = URL(string: model) {
            // Load image from file URL
            if let image = UIImage(contentsOfFile: fileURL.path) {
                // Display the image in the UIImageView
                imageView.image = image
            } else {
                print("Failed to create UIImage from file at path: \(fileURL.path)")
            }
        } else {
            print("Invalid file URL string: \(model)")
        }
    }
}
