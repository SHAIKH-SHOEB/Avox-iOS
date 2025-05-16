//
//  OnBoardingCollectionViewCell.swift
//  Avox
//
//  Created by Shaikh Shoeb on 03/08/24.
//

import UIKit

class OnBoardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: OnBoardingCollectionViewCell.self)
    
    @IBOutlet weak var onBoardingImageView: UIImageView!
    @IBOutlet weak var onBoardingTitleLabel: UILabel!
    @IBOutlet weak var onBoardingDiscriptionLabel: UILabel!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    var deviceManager     : DeviceManager?
    
    var fontSize          : CGFloat = 0.0
    var constant          : CGFloat = 0.0
    var cellHeight        : CGFloat = 0.0
    
    
    
    func loadDeviceManager() {
        deviceManager = DeviceManager.instance
        if deviceManager!.deviceType == deviceManager!.iPhone5 || deviceManager!.deviceType == deviceManager!.iPhone6 {
            fontSize = Helper.DeviceManager.IPHONE_5_6_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_5_6_CONSTANT
            cellHeight = Helper.DeviceManager.IPHONE_5_6_CELL_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iPhone6plus || deviceManager!.deviceType == deviceManager!.iPhoneX {
            fontSize = Helper.DeviceManager.IPHONE_6PLUS_X_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_6PLUS_X_CONSTANT
            cellHeight = Helper.DeviceManager.IPHONE_6PLUS_X_CELL_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iphone12Family || deviceManager!.deviceType == deviceManager!.iphoneProMax {
            fontSize = Helper.DeviceManager.IPHONE_12FAMILY_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_12FAMILY_CONSTANT
            cellHeight = Helper.DeviceManager.IPHONE_12FAMILY_CELL_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iPhone {
            fontSize = Helper.DeviceManager.IPHONE_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_CONSTANT
            cellHeight = Helper.DeviceManager.IPHONE_CELL_HEIGHT
        }
    }
    
    func loadBaseView() {
        onBoardingImageView.layer.cornerRadius = cellHeight*2
        onBoardingImageView!.layer.masksToBounds = true
        
        onBoardingTitleLabel.font = UIFont.appFontBold(ofSize: fontSize*1.5)
        onBoardingDiscriptionLabel.font = UIFont.appFontRegular(ofSize: fontSize*1.2)
        
        imageWidth.constant = cellHeight*4
        imageHeight.constant = cellHeight*4
    }
    
    func updateCollectionViewCellForOnBoarding(_ model: AppProvider) {
        onBoardingImageView.image = UIImage(named: "\(model.icon!)")
        onBoardingTitleLabel.text = AppUtils.localizableString(key: model.title!)
        onBoardingDiscriptionLabel.text = AppUtils.localizableString(key: model.value!)
    }
}
