//
//  CollectionsTableViewCell.swift
//  Avox
//
//  Created by Shaikh Shoeb on 17/09/24.
//

import UIKit

class CollectionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pexelIdLabel: UILabel!
    @IBOutlet weak var copyIconImage: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var mediaLabel: UILabel!
    
    var deviceManager       : DeviceManager?
    var fontSize            : CGFloat = 0.0
    var constant            : CGFloat = 0.0
    var pexelId             : String = ""
    
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
        
        titleLabel.font = UIFont.appFontBold(ofSize: fontSize)
        pexelIdLabel.font = UIFont.appFontMedium(ofSize: fontSize)
        
        copyIconImage.isUserInteractionEnabled = true
        copyIconImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressedCopyButton)))
    }
    
    func updateTableViewCellForCollections(model: Collections) {
        pexelId = model.id
        titleLabel.text = model.title
        stackView.isHidden = model.isExpanded
        pexelIdLabel.setAttributedIdText(title: AppUtils.localizableString(key: LanguageConstant.id), value: model.id, titleColor: Helper.Color.textPrimary!, valueColor:  Helper.Color.textSecondary!, titleFont: UIFont.appFontRegular(ofSize: fontSize)!, valueFont: UIFont.appFontBold(ofSize: fontSize)!)
        photoLabel.setAttributedIdText(title: AppUtils.localizableString(key: LanguageConstant.photo), value: String(model.photosCount), titleColor: Helper.Color.textPrimary!, valueColor:  Helper.Color.textSecondary!, titleFont:UIFont.appFontRegular(ofSize: fontSize)!, valueFont: UIFont.appFontBold(ofSize: fontSize)!)
        videoLabel.setAttributedIdText(title: AppUtils.localizableString(key: LanguageConstant.video), value: String(model.videosCount), titleColor: Helper.Color.textPrimary!, valueColor:  Helper.Color.textSecondary!, titleFont:UIFont.appFontRegular(ofSize: fontSize)!, valueFont: UIFont.appFontBold(ofSize: fontSize)!)
        mediaLabel.setAttributedIdText(title: AppUtils.localizableString(key: LanguageConstant.media), value: String(model.mediaCount), titleColor: Helper.Color.textPrimary!, valueColor:  Helper.Color.textSecondary!, titleFont:UIFont.appFontRegular(ofSize: fontSize)!, valueFont: UIFont.appFontBold(ofSize: fontSize)!)
    }
    
    @objc func didPressedCopyButton() {
        AppUtils.copyTextToClipboard(pexelId)
        copyIconImage.tintColor = Helper.Color.textSecondary
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.copyIconImage.tintColor = Helper.Color.appPrimary
        }
    }
}
