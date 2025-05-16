//
//  SubscribeTableViewCell.swift
//  Avox
//
//  Created by Shoeb on 18/03/25.
//

import UIKit

class SubscribeTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var planLabel: UILabel!
    @IBOutlet weak var radioIcon: UIImageView!
    @IBOutlet weak var titleLabelF: UILabel!
    @IBOutlet weak var titleLabelS: UILabel!
    @IBOutlet weak var titleLabelT: UILabel!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var saveLabel: UILabel!
    
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
        backView!.backgroundColor = Helper.Color.bgPrimary
        AppUtils.applyBorderOnView(view: backView, radius: constant*2)
        
        planLabel.textColor = Helper.Color.textPrimary
        planLabel.font = UIFont.appFontBold(ofSize: fontSize)
        
        titleLabelF.textColor = Helper.Color.textSecondary
        titleLabelF.font = UIFont.appFontRegular(ofSize: fontSize*0.8)
        
        titleLabelT.textColor = Helper.Color.textSecondary
        titleLabelT.font = UIFont.appFontRegular(ofSize: fontSize*0.8)
        
        AppUtils.applyBorderOnView(view: saveView, radius: 10)
        saveLabel.text = "Save 20%"
        saveLabel.textColor = Helper.Color.textPrimary
        saveLabel.font = UIFont.appFontBold(ofSize: fontSize*0.6)
    }
    
    func updateTableViewCellForSubscribe(model: AppProvider) {
        planLabel.text = model.title
        
        titleLabelS.setAttributedIdText(title: AppUtils.localizableString(key: model.value!), value: AppUtils.localizableString(key: model.icon!), titleColor: Helper.Color.textSecondary!, valueColor:  Helper.Color.textSecondary!, titleFont: UIFont.appFontRegular(ofSize: fontSize*0.8)!, valueFont: UIFont.appFontBold(ofSize: fontSize*0.8)!, divider: "")
        
        saveView.isHidden = model.id != 1
        
        if model.index == 1 {
            radioIcon.image = UIImage(systemName: "checkmark.circle.fill")
            backView!.backgroundColor = Helper.Color.appPrimary!.withAlphaComponent(0.1)
        }else {
            radioIcon.image = UIImage(systemName: "circlebadge")
            backView!.backgroundColor = Helper.Color.bgPrimary
        }
    }
}
