//
//  SuggestionTableViewCell.swift
//  Avox
//
//  Created by Nimap on 03/03/24.
//

import UIKit

class SuggestionTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    var deviceManager       : DeviceManager?
    var fontSize            : CGFloat = 0.0
    var constant            : CGFloat = 0.0
    var cellHeight          : CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadDeviceManager()
        loadBaseView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
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
        AppUtils.applyBorderOnView(view: baseView, radius: constant)
        
        thumbnailImage.layer.cornerRadius = constant
        AppUtils.applyShadowOnImage(imageView: thumbnailImage)
        
        titleLabel.textColor = Helper.Color.textPrimary
        titleLabel.font = UIFont.appFontBold(ofSize: fontSize)
        
        subTitleLabel.textColor = Helper.Color.textSecondary
        subTitleLabel.font = UIFont.appFontRegular(ofSize: fontSize)
        
        imageWidth.constant = cellHeight*1.2
        imageHeight.constant = cellHeight*1.2
    }
    
    func updateTableViewCellForSuggestion(model: SuggestionProvider) {
        thumbnailImage.downloadImage(from: URL(string: "\(model.image!)")!, placeholder: UIImage(named: "Placeholder"))
        titleLabel.text = AppUtils.localizableString(key: model.title!)
        subTitleLabel.text = AppUtils.localizableString(key: model.subTitle!)
    }
}
