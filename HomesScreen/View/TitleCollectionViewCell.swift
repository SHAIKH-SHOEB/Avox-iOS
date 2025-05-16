//
//  TitleCollectionViewCell.swift
//  Avox
//
//  Created by Nimap on 26/01/24.
//

import UIKit

class TitleCollectionViewCell: UICollectionViewCell {
    
    var deviceManager    : DeviceManager?
    
    var baseView         : UIView?
    var titleLabel       : UILabel?
    var titleImageView   : UIImageView?
    
    var fontSize         : CGFloat = 0.0
    var constant         : CGFloat = 0.0
    var cellHeight         : CGFloat = 0.0
    
    override init(frame : CGRect){
        super.init(frame: frame)
        loadDeviceManager()
        loadBaseView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.backgroundColor = Helper.Color.bgPrimary
        self.layer.cornerRadius = cellHeight*0.4
        self.layer.borderColor = UIColor.systemGray3.cgColor
        self.layer.borderWidth = 1
        AppUtils.applyBorderOnView(view: self, radius: constant)
        titleImageView = UIImageView()
        titleImageView!.translatesAutoresizingMaskIntoConstraints = false
        titleImageView!.contentMode = .scaleAspectFill
        titleImageView!.backgroundColor = UIColor.clear
        titleImageView!.image = UIImage(named: "Mountain")
        self.addSubview(titleImageView!)
        NSLayoutConstraint.activate([
            titleImageView!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constant*0.5),
            titleImageView!.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleImageView!.heightAnchor.constraint(equalToConstant: cellHeight*0.6),
            titleImageView!.widthAnchor.constraint(equalToConstant: cellHeight*0.6)
        ])
        
        titleLabel = UILabel()
        titleLabel!.translatesAutoresizingMaskIntoConstraints = false
        titleLabel!.text = "XYZ"
        titleLabel!.font = UIFont.appFontBold(ofSize: fontSize)
        titleLabel!.textColor = Helper.Color.textPrimary
        titleLabel!.textAlignment = .center
        titleLabel!.isUserInteractionEnabled = true
        self.addSubview(titleLabel!)
        NSLayoutConstraint.activate([
            titleLabel!.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel!.leadingAnchor.constraint(equalTo: titleImageView!.trailingAnchor),
            titleLabel!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -constant*0.5)
        ])
    }
    
    func updateTitleCollectionViewCell(model: AppProvider) {
        titleLabel!.text = model.icon
        titleImageView!.image = UIImage(named: model.title!)
        if model.index == 1 {
            self.layer.borderColor = Helper.Color.appPrimary?.cgColor
            self.layer.borderWidth = 2
        }else {
            self.layer.borderColor = UIColor.systemGray3.cgColor
            self.layer.borderWidth = 1
        }
    }
}
