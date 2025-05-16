//
//  ViewController.swift
//  Avox
//
//  Created by Nimap on 26/01/24.
//

//com.SoftyInfotech.Avox

import UIKit
import Photos

class ViewController: UIViewController, AvoxAlertViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var editImage: UIImageView!
    @IBOutlet weak var downloadImage: UIImageView!
    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var flashLightView: UIView!
    @IBOutlet weak var flashLightImage: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraImage: UIImageView!
    
    lazy var rightSwipeGestureRecognizer: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe(_:)))
        gesture.direction = .right
        return gesture
    }()
    
    var deviceManager       : DeviceManager?
    var fontSize            : CGFloat = 0.0
    var constant            : CGFloat = 0.0
    var cellHeight          : CGFloat = 0.0
    var containerHeight     : CGFloat = 0.0
    
    var alertView           : AvoxAlertView?
    var imageUrl            : String = ""
    var orgImage            : UIImage? = UIImage(named: "PlaceHolder")
    
    var isViewVisible       = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(rightSwipeGestureRecognizer)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showOptionView)))
        loadDeviceManager()
        loadBaseView()
        loadImageView(url:imageUrl)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return AppConstants.APP_MODE == "dark" ? .darkContent : .lightContent
    }
    
    func loadDeviceManager() {
        deviceManager = DeviceManager.instance
        if deviceManager!.deviceType == deviceManager!.iPhone5 || deviceManager!.deviceType == deviceManager!.iPhone6 {
            fontSize = Helper.DeviceManager.IPHONE_5_6_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_5_6_CONSTANT
            cellHeight = Helper.DeviceManager.IPHONE_5_6_CELL_HEIGHT
            containerHeight = Helper.DeviceManager.IPHONE_5_6_CONTAINER_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iPhone6plus || deviceManager!.deviceType == deviceManager!.iPhoneX {
            fontSize = Helper.DeviceManager.IPHONE_6PLUS_X_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_6PLUS_X_CONSTANT
            cellHeight = Helper.DeviceManager.IPHONE_6PLUS_X_CELL_HEIGHT
            containerHeight = Helper.DeviceManager.IPHONE_6PLUS_X_CONTAINER_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iphone12Family || deviceManager!.deviceType == deviceManager!.iphoneProMax {
            fontSize = Helper.DeviceManager.IPHONE_12FAMILY_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_12FAMILY_CONSTANT
            cellHeight = Helper.DeviceManager.IPHONE_12FAMILY_CELL_HEIGHT
            containerHeight = Helper.DeviceManager.IPHONE_12FAMILY_CONTAINER_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iPhone {
            fontSize = Helper.DeviceManager.IPHONE_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_CONSTANT
            cellHeight = Helper.DeviceManager.IPHONE_CELL_HEIGHT
            containerHeight = Helper.DeviceManager.IPHONE_CONTAINER_HEIGHT
        }
    }
    
    func loadBaseView() {
        imageView.image = UIImage(named: "Placeholder")
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        stackView.backgroundColor = UIColor.clear
        optionView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        optionView.layer.cornerRadius = cellHeight*0.6
        optionView.alpha = 1.0
        
        phoneImage.isUserInteractionEnabled = true
        phoneImage.tag = 0
        phoneImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
        editImage.isUserInteractionEnabled = true
        editImage.tag = 1
        editImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
        downloadImage.isUserInteractionEnabled = true
        downloadImage.tag = 2
        downloadImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
        shareImage.isUserInteractionEnabled = true
        shareImage.tag = 3
        shareImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
        timeStackView.backgroundColor = UIColor.clear
        timeStackView.isHidden = true
        timeStackView.alpha = 0.0
        
        dateLabel.text = AppUtils.getCurrentDate()
        timeLabel.text = AppUtils.getCurrentTime()
        
        bottomStackView.backgroundColor  = UIColor.clear
        bottomStackView.isHidden = true
        bottomStackView.alpha = 0.0
        
        flashLightView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        flashLightView.layer.cornerRadius = 30
        cameraView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cameraView.layer.cornerRadius = 30
    }
    
    func loadImageView(url: String) {
        downloadImage(from: url) { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.orgImage = image
                }
            } else {
                print("Handle the case where the image couldn't be downloaded")
            }
        }
    }
    
    @objc func handleRightSwipe(_ gesture: UISwipeGestureRecognizer) {
        // Handle the right swipe here
        if gesture.state == .ended {
            // Perform the pop action or any other action you want
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func loadAlertView(title: String, message: String, tag: [String]) {
        unloadAlertView()
        alertView = AvoxAlertView(title: title, message: message, tag: tag, target: self)
        alertView!.delegate = self
    }
    
    func unloadAlertView() {
        if alertView != nil {
            alertView!.removeFromSuperview()
            alertView = nil
        }
    }
    
    func clickOnPositiveButton(tag: String) {
        unloadAlertView()
        if tag == "downloaded" {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension ViewController {
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            // Access the tag value of the tapped UIImageView
            let tagValue = imageView.tag
            buttonPressedOperation(index: tagValue)
            print("Tag value of tapped image: \(tagValue)")
        }
    }
    
    func buttonPressedOperation(index: Int) {
        switch index {
        case 0 :
            print("Phone Button Pressed")
            checkImageOnFullScreen()
        case 1 :
            print("Edit Button Pressed")
            editButtonPressed(image: orgImage!)
        case 2 :
            print("Download Button Pressed")
            saveImageToPhotoLibrary(image: orgImage!)
        case 3:
            print("Share Button Pressed")
            sharedButtonPressed()
        default:
            return
        }
    }
    
    func saveImageToPhotoLibrary(image: UIImage) {
        requestPhotoLibraryPermission { granted in
            if granted {
                PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.creationRequestForAsset(from: image)}) { success, error in
                    if success {
                        print("Image saved to photo library.")
                        self.createImageUrlDatabaseInstant(url: self.imageUrl)
                    } else if let error = error {
                        print("Error saving image: \(error)")
                    }
                }
            } else {
                print("Permission denied.")
            }
        }
    }
   
    func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status == .authorized)
            }
        }
    }
    
    func createImageUrlDatabaseInstant(url: String) {
        let imageUrl = ImageData(context: DatabaseManager.share.context)
        imageUrl.imageUrl = url
        imageUrl.title = "\(AppConstants.NAME)_Image_\(Int(Date().timeIntervalSince1970)).png"
        imageUrl.date = Date()
        imageUrl.id = UUID()
        DatabaseManager.share.saveContext()
        DispatchQueue.main.async {
            self.loadAlertView(title: AppUtils.localizableString(key: LanguageConstant.successful), message: AppUtils.localizableString(key: LanguageConstant.downloadMessage), tag: ["downloaded"])
        }
    }
    
    func editButtonPressed(image: UIImage) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ImageEditorViewController") as? ImageEditorViewController
        vc?.orgImage = image
        self.navigationController?.pushViewController(vc!, animated: true)
        vc?.filterImageCallback = { (image) in
            self.imageView.image = image
            self.imageView.layoutIfNeeded()
        }
    }
    
    func sharedButtonPressed() {
        guard let imageToShare = imageView.image else {
            // Handle the case where there is no image to share
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        // Exclude some activity types if needed
        activityViewController.excludedActivityTypes = [.assignToContact, .addToReadingList, .openInIBooks]
        // Replace 'sender' with the actual view or button that triggers the share action
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = shareImage
            popoverController.sourceRect = shareImage.bounds
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    func checkImageOnFullScreen() {
        imageView!.contentMode = .scaleAspectFill
        loadViewVisibility()
    }
    
    @objc func showOptionView() {
        imageView!.contentMode = .scaleAspectFit
        loadViewVisibility()
    }
    
    func loadViewVisibility() {
        if isViewVisible {
            UIView.animate(withDuration: 0.3) {
                self.optionView.alpha = 1.0
                self.timeStackView.alpha = 0.0
                self.bottomStackView.alpha = 0.0
            } completion: { _ in
                self.optionView.isHidden = false
                self.timeStackView.isHidden = true
                self.bottomStackView.isHidden = true
            }
        } else {
            optionView.isHidden = true
            timeStackView.isHidden = false
            bottomStackView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.optionView.alpha = 0.0
                self.timeStackView.alpha = 1.0
                self.bottomStackView.alpha = 1.0
            }
        }
        isViewVisible = !isViewVisible
    }
}
