//
//  SettingTableViewCell.swift
//  Avox
//
//  Created by Nimap on 26/01/24.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var IconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionSwitch: UISwitch!
    @IBOutlet weak var iconWidth: NSLayoutConstraint!
    @IBOutlet weak var iconHeight: NSLayoutConstraint!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    var deviceManager       : DeviceManager?
    var fontSize            : CGFloat = 0.0
    var constant            : CGFloat = 0.0
    
    var id = 0
    
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
        
        optionSwitch.onTintColor = Helper.Color.appPrimary
        optionSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        optionSwitch.isOn = false
        
        titleLabel.font = UIFont.appFontRegular(ofSize: fontSize*1.1)
        subTitleLabel.font = UIFont.appFontMedium(ofSize: fontSize)
        
        iconWidth.constant = constant*3
        iconHeight.constant = constant*3
    }

    
    func updateSettingTableViewCell(model: AppProvider) {
        id = model.id!
        IconView.image = UIImage(systemName: model.icon!)
        if model.id == 4 {
            subTitleLabel.isHidden = false
            subTitleLabel.text = AppUtils.getSelectedLanguage()
        }
        titleLabel.text = AppUtils.localizableString(key: model.title!)
        optionSwitch.isHidden = (model.index == nil)
        if id == 5 {
            if "dark" == Helper.isAppMode {
                optionSwitch.isOn = true
            }else{
                optionSwitch.isOn = false
            }
        }else if id == 6 {
            if "granted" == UserDefaults.standard.string(forKey: "notification") {
                optionSwitch.isOn = true
            }else{
                optionSwitch.isOn = false
            }
        }
    }
    
    func updateOptionTableViewCell(model: AppProvider) {
        optionSwitch.isHidden = true
        IconView.image = UIImage(systemName: model.icon!)
        titleLabel.text = AppUtils.localizableString(key: model.title!)
    }
    
    func updateLanguageTableViewCell(model: AppProvider) {
        optionSwitch.isHidden = true
        if model.id == UserDefaults.standard.integer(forKey: "language") {
            IconView.image = UIImage(systemName: "checkmark.square")
            print(model.title!)
        }else {
            IconView.image = UIImage(systemName: model.icon!)
        }
        titleLabel.text = model.title
    }
    
    func updateCustomSheetTableViewCell(model: AddEventProvider, type: Int) {
        optionSwitch.isHidden = true
        titleLabel.text = model.title
        if type == 1 {
            IconView.image = UIImage(systemName: "app.fill")
            IconView.tintColor = model.value as? UIColor
        }else {
            IconView.image = model.value as? UIImage
        }
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        if id == 5 {
            if sender.isOn {
                if #available(iOS 13.0, *) {
                    window!.overrideUserInterfaceStyle = .dark
                    UserDefaults.standard.set("dark", forKey: AppConstants.APP_MODE)
                }
            }else {
                if #available(iOS 13.0, *) {
                    window!.overrideUserInterfaceStyle = .light
                    UserDefaults.standard.set("light", forKey: AppConstants.APP_MODE)
                }
            }
        }
        
        if id == 6 {
            if sender.isOn {
                NotificationManager.shared.requestNotificationPermission()
            }else {
                NotificationManager.shared.stopNotifications()
            }
        }
    }
}
