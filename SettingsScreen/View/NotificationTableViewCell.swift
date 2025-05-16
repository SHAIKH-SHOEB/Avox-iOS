//
//  NotificationTableViewCell.swift
//  Avox
//
//  Created by Nimap on 02/02/24.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var deviceManager       : DeviceManager?
    var fontSize            : CGFloat = 0.0
    var constant            : CGFloat = 0.0
    
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
        }else if deviceManager!.deviceType == deviceManager!.iPhone6plus || deviceManager!.deviceType == deviceManager!.iPhoneX {
            fontSize = Helper.DeviceManager.IPHONE_6PLUS_X_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_6PLUS_X_CONSTANT
        }else if deviceManager!.deviceType == deviceManager!.iphone12Family || deviceManager!.deviceType == deviceManager!.iphoneProMax {
            fontSize = Helper.DeviceManager.IPHONE_12FAMILY_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_12FAMILY_CONSTANT
        }else if deviceManager!.deviceType == deviceManager!.iPhone {
            fontSize = Helper.DeviceManager.IPHONE_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_CONSTANT
        }
    }
    
    func loadBaseView() {
        AppUtils.applyBorderOnView(view: baseView, radius: constant)
        
        dateLabel.font = UIFont.appFontLight(ofSize: fontSize*0.8)
        dateLabel.textColor = Helper.Color.textSecondary
        
        userLabel.font = UIFont.appFontBold(ofSize: fontSize*0.8)
        userLabel.textColor = Helper.Color.textPrimary
        
        titleLabel.font = UIFont.appFontRegular(ofSize: fontSize*0.8)
        titleLabel.textColor = Helper.Color.textSecondary
        titleLabel.numberOfLines = 0
    }
    
    func updateNotificationTableViewCell(models: NotificationData) {
        let dateFormat = AppUtils.dateToDateFormatAsString(date: models.date!)
        dateLabel.text = dateFormat
        userLabel.text = models.title
        titleLabel.text = models.body
    }
}
