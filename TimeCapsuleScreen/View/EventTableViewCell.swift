//
//  EventTableViewCell.swift
//  Avox
//
//  Created by Shoeb on 20/04/25.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var colorImageView: UIImageView!
    
    var deviceManager : DeviceManager?
    var fontSize      : CGFloat = 0.0
    var constant      : CGFloat = 0.0
    
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
        backView!.backgroundColor = Helper.Color.bgPrimary
        AppUtils.applyBorderOnView(view: backView, radius: constant)
        
        timeLabel.textColor = Helper.Color.textSecondary
        timeLabel.font = UIFont.appFontMedium(ofSize: fontSize*0.7)
        
        titleLabel.textColor = Helper.Color.textSecondary
        titleLabel.font = UIFont.appFontBold(ofSize: fontSize*0.7)
        
        locationLabel.textColor = Helper.Color.textSecondary
        locationLabel.font = UIFont.appFontMedium(ofSize: fontSize*0.7)
    }
    
    func updateTableViewCellForEvent(model: EventData) {
        timeLabel.text = "\(model.startTime!) - \(model.endTime!)"
        titleLabel.text = model.title
        locationLabel.text = model.location
        locationLabel.numberOfLines = 0
        switch model.color! {
        case "Red":
            colorImageView.tintColor = UIColor.systemRed
            break
        case "Blue":
            colorImageView.tintColor = UIColor.systemBlue
            break
        case "Green":
            colorImageView.tintColor = UIColor.systemGreen
            break
        case "Yello":
            colorImageView.tintColor = UIColor.systemYellow
            break
        default:
            colorImageView.tintColor = UIColor.systemGreen
            break
        }
    }
}
