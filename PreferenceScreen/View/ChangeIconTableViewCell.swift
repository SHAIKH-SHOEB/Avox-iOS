//
//  ChangeIconTableViewCell.swift
//  Avox
//
//  Created by Shoeb on 18/04/25.
//

import UIKit

class ChangeIconTableViewCell: UITableViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var deviceManager : DeviceManager?
    var fontSize      : CGFloat = 0.0
    var constant      : CGFloat = 0.0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadDeviceManager()
        loadCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func loadDeviceManager() {
        deviceManager = DeviceManager.instance
        if deviceManager!.deviceType == deviceManager!.iPhone5 || deviceManager!.deviceType == deviceManager!.iPhone6 {
            fontSize = Helper.DeviceManager.IPHONE_5_6_FONT_SIZE * 0.9
            constant = Helper.DeviceManager.IPHONE_5_6_CONSTANT
        }else if deviceManager!.deviceType == deviceManager!.iPhone6plus || deviceManager!.deviceType == deviceManager!.iPhoneX {
            fontSize = Helper.DeviceManager.IPHONE_6PLUS_X_FONT_SIZE * 0.9
            constant = Helper.DeviceManager.IPHONE_6PLUS_X_CONSTANT
        }else if deviceManager!.deviceType == deviceManager!.iphone12Family || deviceManager!.deviceType == deviceManager!.iphoneProMax {
            fontSize = Helper.DeviceManager.IPHONE_12FAMILY_FONT_SIZE * 0.9
            constant = Helper.DeviceManager.IPHONE_12FAMILY_CONSTANT
        }else if deviceManager!.deviceType == deviceManager!.iPhone {
            fontSize = Helper.DeviceManager.IPHONE_FONT_SIZE * 0.9
            constant = Helper.DeviceManager.IPHONE_CONSTANT
        }
    }
    
    func loadCell() {
        AppUtils.applyBorderOnView(view: baseView, radius: constant)
        AppUtils.applyBorderOnImage(image: iconImageView, radius: constant)
        titleLabel.font = UIFont.appFontBold(ofSize: fontSize)
    }
    
    func updateTableViewCellForIcon(model: AppProvider) {
        titleLabel.text = model.title
        iconImageView.image = UIImage(named: model.icon!)
        if model.index == 1 {
            selectedImageView.image = UIImage(systemName: "checkmark.circle.fill")
            baseView.backgroundColor = Helper.Color.appPrimary!.withAlphaComponent(0.1)
        }else {
            selectedImageView.image = UIImage(systemName: "circlebadge")
            baseView.backgroundColor = Helper.Color.bgPrimary
        }
    }
}
