//
//  NoConnectionViewController.swift
//  Avox
//
//  Created by Nimap on 15/03/24.
//

import UIKit

class NoConnectionViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var noConnectionImage: UIImageView!
    @IBOutlet weak var whoopsLabel: UILabel!
    @IBOutlet weak var noConnectionLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    
    var deviceManager     : DeviceManager?
    var activityIndicator : AvoxAlertView?
    
    var fontSize          : CGFloat = 0.0
    var constant          : CGFloat = 0.0
    var cellHeight        : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadDeviceManager()
        loadBaseView()
    }

    override var prefersStatusBarHidden: Bool {
        return true
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
    
    func loadActivityIndicator() {
        activityIndicator = AvoxAlertView(target: self)
        activityIndicator!.activityIndicator.startAnimating()
    }
    
    func unloadActivityIndicator() {
        activityIndicator!.activityIndicator.stopAnimating()
        activityIndicator!.removeFromSuperview()
    }
    
    func loadBaseView() {
        whoopsLabel.text = AppUtils.localizableString(key: LanguageConstant.whoops)
        whoopsLabel.font = UIFont.appFontBold(ofSize: fontSize*2)
        
        noConnectionLabel.text = AppUtils.localizableString(key: LanguageConstant.noInternetConnection)
        noConnectionLabel.font = UIFont.appFontRegular(ofSize: fontSize+1)
        
        tryAgainButton.setTitle(AppUtils.localizableString(key: LanguageConstant.tryAgain), for: UIControl.State.normal)
        tryAgainButton.backgroundColor = Helper.Color.appPrimary
        tryAgainButton.clipsToBounds = true
        tryAgainButton.layer.cornerRadius = 10
        tryAgainButton.addTarget(self, action: #selector(tryAgainButtonPressed), for: .touchUpInside)
        
        imageWidth.constant = cellHeight*2.4
        imageHeight.constant = cellHeight*2.4
        buttonTopConstraint.constant = cellHeight*3
    }
    
    @objc func tryAgainButtonPressed() {
        if UIApplication.isConnectedToNetwork() {
            let homeViewController = HomeViewController()
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }else {
            let vc = DownloadViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
