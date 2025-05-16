//
//  ImageTableViewCell.swift
//  Avox
//
//  Created by Nimap on 26/02/24.
//

import UIKit

protocol ImageTableViewCellDelegate: NSObjectProtocol {
    func didClickOnProfile(url: String)
    func didClickOnOption(index: Int)
}

class ImageTableViewCell: UITableViewCell {
    
    weak var delegate : ImageTableViewCellDelegate?

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileTitleLabel: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var viewImageView: UIImageView!
    
    var deviceManager: DeviceManager?
    var fontSize    : CGFloat = 0.0
    var constant    : CGFloat = 0.0
    var cellHeight  : CGFloat = 0.0
    var containerHeight  : CGFloat = 0.0
    
    var urlString   : String? = ""
    var index       : Int? = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
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
        baseView.backgroundColor = Helper.Color.bgPrimary
        
        profileImageView.layer.cornerRadius = 30
        profileImageView.layer.masksToBounds = true
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileButtonPressed)))
        
        profileNameLabel.font = UIFont.appFontBold(ofSize: fontSize)
        profileNameLabel.textColor = Helper.Color.textPrimary
        
        profileTitleLabel.font = UIFont.appFontMedium(ofSize: fontSize*0.9)
        profileTitleLabel.textColor = Helper.Color.textSecondary
        
        optionButton!.addTarget(self, action: #selector(optionButtonPressed), for: .touchDown)
    }
    
    func updateTableViewCellForImageView(model: PexelsModel, index: Int) {
        self.index = index
        urlString = model.photographer_url
        viewImageView.downloadImage(from: URL(string: "\(model.src!.original!)")!, placeholder: UIImage(named: "Placeholder"))
        profileImageView.tintColor = UIColor(hexString: model.avg_color!)
        profileNameLabel.text = model.photographer
        profileTitleLabel.text = model.alt
    }
    
    @objc func profileButtonPressed() {
        if delegate != nil {
            delegate!.didClickOnProfile(url: urlString!)
        }
    }
    
    @objc func optionButtonPressed() {
        if delegate != nil {
            delegate!.didClickOnOption(index: index!)
        }
    }
    
}
