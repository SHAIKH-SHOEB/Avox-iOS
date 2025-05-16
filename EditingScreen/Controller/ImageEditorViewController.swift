//
//  ImageEditorViewController.swift
//  Avox
//
//  Created by Shaikh Shoeb on 27/07/24.
//

import UIKit
import CoreImage

class ImageEditorViewController: UIViewController {
    
    @IBOutlet weak var editorImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var activityIndicator   : AvoxAlertView?
    var orgImage            : UIImage?
    var filterTitleArray    : [String] = ["ORIGINAL", "COOL", "MONO", "SEPIA", "VINTAGE","WARM", "COLD", "RETRO", "NEON", "SKETCH"]
    var filterImageCallback : ((_ image: UIImage)-> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        editorImageView.image = orgImage
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func applyFilter(to image: UIImage, filterName: String, intensity: CGFloat = 1.0) -> UIImage? {
        guard let ciImage = CIImage(image: image) else {
            print("Unable to create CIImage")
            return nil
        }
        
        let filter = CIFilter(name: filterName)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        // Adjust filter parameters based on the filter type
        switch filterName {
        case "CISepiaTone":
            filter?.setValue(intensity, forKey: kCIInputIntensityKey)
        case "CIColorControls":
            filter?.setValue(intensity, forKey: kCIInputContrastKey)
        case "CIPhotoEffectNoir":
            break
        default:
            break
        }
        
        guard let outputImage = filter?.outputImage else {
            print("Failed to get output image")
            return nil
        }
        
        let context = CIContext()
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        return nil
    }
    
    func applyFilterAndUpdateUI(with filterName: String, intensity: CGFloat = 1.0) {
        // Show activity indicator
        loadActivityIndicator()
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let filteredImage = self.applyFilter(to: self.orgImage!, filterName: filterName, intensity: intensity) {
                DispatchQueue.main.async {
                    self.editorImageView.image = filteredImage
                    // Hide activity indicator
                    self.unloadActivityIndicator()
                }
            } else {
                DispatchQueue.main.async {
                    // Hide activity indicator in case of failure
                    self.unloadActivityIndicator()
                }
            }
        }
    }
    
    @IBAction func didCancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didDoneButtonPressed(_ sender: Any) {
        filterImageCallback?(orgImage!)
        self.navigationController?.popViewController(animated: true)
        print("Hello World")
    }
    
    func loadActivityIndicator() {
        activityIndicator = AvoxAlertView(target: self)
        activityIndicator!.activityIndicator.startAnimating()
    }
    
    func unloadActivityIndicator() {
        activityIndicator!.activityIndicator.stopAnimating()
        activityIndicator!.removeFromSuperview()
    }
}

extension ImageEditorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterTitleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageEditorCollectionViewCell.identifier, for: indexPath) as! ImageEditorCollectionViewCell
        cell.updateCollectionViewCellForEditorImage(image: orgImage!, title: filterTitleArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filterName = filterTitleArray[indexPath.row]
        let filterNameMapping: [String: String] = [
            "ORIGINAL": "CIVibrance",
            "COOL": "CISepiaTone",
            "MONO": "CICrystallize",
            "SEPIA": "CICMYKHalftone",
            "VINTAGE": "CIPhotoEffectTransfer",
            "WARM": "CIPhotoEffectMono",
            "COLD": "CIPhotoEffectInstant",
            "RETRO": "CIFalseColor",
            "NEON": "CIPhotoEffectProcess",
            "SKETCH": "CIPhotoEffectTonal"
        ]
        
        guard let filterNameForSelection = filterNameMapping[filterName] else {
            print("No filter found for \(filterName)")
            return
        }
        
        applyFilterAndUpdateUI(with: filterNameForSelection)
    }
}
