//
//  HistoryTableViewCell.swift
//  Avox
//
//  Created by Shaikh Shoeb on 20/10/24.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var deviceManager  : DeviceManager?
    var fontSize       : CGFloat = 0.0
    
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
            fontSize = Helper.DeviceManager.IPHONE_5_6_FONT_SIZE
        }else if deviceManager!.deviceType == deviceManager!.iPhone6plus || deviceManager!.deviceType == deviceManager!.iPhoneX {
            fontSize = Helper.DeviceManager.IPHONE_6PLUS_X_FONT_SIZE
        }else if deviceManager!.deviceType == deviceManager!.iphone12Family || deviceManager!.deviceType == deviceManager!.iphoneProMax {
            fontSize = Helper.DeviceManager.IPHONE_12FAMILY_FONT_SIZE
        }else if deviceManager!.deviceType == deviceManager!.iPhone {
            fontSize = Helper.DeviceManager.IPHONE_FONT_SIZE
        }
    }
    
    func loadCell() {
        AppUtils.applyBorderOnView(view: baseView, radius: 10.0)
        titleLabel.font = UIFont.appFontBold(ofSize: fontSize*0.7)
        descriptionLabel.font = UIFont.appFontRegular(ofSize: fontSize*0.6)
        descriptionLabel.numberOfLines = 2
        dateLabel.font = UIFont.appFontLight(ofSize: fontSize*0.6)
    }
    
    func updateTableViewCellForHistory(model: ImageData) {
        titleLabel.text = model.title
        descriptionLabel.text = model.imageUrl
        dateLabel.text = AppUtils.dateToDateFormatAsString(date: model.date!)
        thumbnailImageView.downloadImage(from: URL(string: "\(model.imageUrl!)")!, placeholder: UIImage(named: "Placeholder"))
    }
}
