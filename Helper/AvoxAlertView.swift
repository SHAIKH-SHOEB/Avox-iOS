//
//  AvoxAlertView.swift
//  Avox
//
//  Created by Nimap on 21/02/24.
//

import UIKit

@objc protocol AvoxAlertViewDelegate: NSObjectProtocol {
    @objc optional func clickOnPositiveButton(tag: String)
    @objc optional func clickOnNigativeButton(tag: String)
}

class AvoxAlertView: UIView {

    var deviceManager   : DeviceManager?
    weak var delegate   : AvoxAlertViewDelegate?
    
    var mainView        : UIView?
    var baseView        : UIStackView?
    var titleLabel      : UILabel?
    var messageLabel    : UILabel?
    
    var stackView       : UIStackView?
    var okButton        : UIButton?
    var cancelButton    : UIButton?
    
    var titles          : String?
    var messages        : String?
    var action          : [String]?
    var tags            : [String]?
    var target          : UIViewController?
    
    var fontSize        : CGFloat = 0.0
    var constant        : CGFloat = 0.0
    var cellHeight      : CGFloat = 0.0
    var containerHeight : CGFloat = 0.0
    
    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    init(title: String, message: String, actions: [String] = [AppUtils.localizableString(key: LanguageConstant.ok)], tag: [String], target: UIViewController){
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        target.view.addSubview(self)
        self.titles = title
        self.messages = message
        self.action = actions
        self.tags = tag
        self.target = target
        loadDeviceManager()
        loadBaseView()
    }
    
    init(target: UIViewController){
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        target.view.addSubview(self)
        self.target = target
        loadDeviceManager()
        loadActivityIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func loadActivityIndicator() {
        mainView = UIView()
        mainView!.translatesAutoresizingMaskIntoConstraints = false
        mainView!.backgroundColor = Helper.Color.bgPrimary
        mainView!.layer.cornerRadius = constant
        AppUtils.applyShadowOnView(view: mainView!)
        self.addSubview(mainView!)
        NSLayoutConstraint.activate([
            mainView!.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainView!.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mainView!.widthAnchor.constraint(equalToConstant: cellHeight*1.5),
            mainView!.heightAnchor.constraint(equalToConstant: cellHeight*1.5)
        ])
        
        //activityIndicator.center = mainView!.center
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = Helper.Color.appPrimary
        activityIndicator.hidesWhenStopped = true
        mainView!.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: mainView!.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: mainView!.centerYAnchor)
        ])
    }
    
    func loadBaseView() {
        mainView = UIView()
        mainView!.translatesAutoresizingMaskIntoConstraints = false
        mainView!.backgroundColor = Helper.Color.bgPrimary
        mainView!.layer.cornerRadius = constant
        AppUtils.applyShadowOnView(view: mainView!)
        self.addSubview(mainView!)
        NSLayoutConstraint.activate([
            mainView!.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainView!.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mainView!.widthAnchor.constraint(equalToConstant: cellHeight*6)
        ])
        
        baseView = UIStackView()
        baseView!.translatesAutoresizingMaskIntoConstraints = false
        baseView!.backgroundColor = UIColor.clear
        baseView!.axis = NSLayoutConstraint.Axis.vertical
        baseView!.distribution = UIStackView.Distribution.fillProportionally
        baseView!.spacing = constant*2
        mainView!.addSubview(baseView!)
        NSLayoutConstraint.activate([
            baseView!.leadingAnchor.constraint(equalTo: mainView!.leadingAnchor, constant: constant*2),
            baseView!.topAnchor.constraint(equalTo: mainView!.topAnchor, constant: constant*2),
            baseView!.trailingAnchor.constraint(equalTo: mainView!.trailingAnchor, constant: -constant*2),
            baseView!.bottomAnchor.constraint(equalTo: mainView!.bottomAnchor, constant: -constant*2)
        ])
        
        titleLabel = UILabel()
        titleLabel!.text = titles
        titleLabel!.numberOfLines = 1
        titleLabel!.font = UIFont.appFontMedium(ofSize: fontSize*1.2)
        titleLabel!.textColor = Helper.Color.textPrimary
        titleLabel!.textAlignment = .center
        baseView!.addArrangedSubview(titleLabel!)
        
        messageLabel = UILabel()
        messageLabel!.text = messages
        messageLabel!.numberOfLines = 0
        messageLabel!.font = UIFont.appFontRegular(ofSize: fontSize)
        messageLabel!.textColor = Helper.Color.textSecondary
        messageLabel!.textAlignment = .center
        baseView!.addArrangedSubview(messageLabel!)
        
        stackView = UIStackView()
        stackView!.translatesAutoresizingMaskIntoConstraints = false
        stackView!.axis = NSLayoutConstraint.Axis.horizontal
        stackView!.distribution = UIStackView.Distribution.fillEqually
        stackView!.spacing = constant*0.5
        stackView!.backgroundColor = UIColor.clear
        baseView!.addArrangedSubview(stackView!)
        
        cancelButton = UIButton()
        cancelButton!.translatesAutoresizingMaskIntoConstraints  = false
        //cancelButton!.setTitle("", for: .normal)
        cancelButton!.titleLabel!.font = UIFont.appFontBold(ofSize: fontSize)
        cancelButton!.backgroundColor = UIColor.lightGray
        cancelButton!.setTitleColor(Helper.Color.accent, for: .normal)
        cancelButton!.layer.cornerRadius = cellHeight*0.4
        cancelButton!.addTarget(self, action: #selector(clickOnCancelButton), for: .touchDown)
        cancelButton!.isHidden = true
        stackView!.addArrangedSubview(cancelButton!)
        NSLayoutConstraint.activate([
            cancelButton!.heightAnchor.constraint(equalToConstant: cellHeight*0.8)
        ])
        
        okButton = UIButton()
        okButton!.translatesAutoresizingMaskIntoConstraints  = false
        //okButton!.setTitle("", for: .normal)
        okButton!.titleLabel!.font = UIFont.appFontBold(ofSize: fontSize)
        okButton!.backgroundColor = Helper.Color.appPrimary
        okButton!.setTitleColor(Helper.Color.accent, for: .normal)
        okButton!.layer.cornerRadius = cellHeight*0.4
        okButton!.addTarget(self, action: #selector(clickOnOkButton), for: .touchDown)
        stackView!.addArrangedSubview(okButton!)
        NSLayoutConstraint.activate([
            okButton!.heightAnchor.constraint(equalToConstant: cellHeight*0.8)
        ])
        
        if action!.count > 1 {
            cancelButton!.isHidden = false
            okButton!.setTitle("\(action![0])", for: .normal)
            cancelButton!.setTitle("\(action![1])", for: .normal)
        }else {
            okButton!.setTitle("\(action![0])", for: .normal)
        }
    }
    
    @objc func clickOnOkButton() {
        if delegate != nil {
            delegate!.clickOnPositiveButton?(tag: "\(tags![0])")
        }
    }
    
    @objc func clickOnCancelButton() {
        if delegate != nil {
            delegate!.clickOnNigativeButton?(tag: "\(tags![1])")
        }
    }
    
//    func show() {
//            guard let window = UIApplication.shared.windows.first else {
//                return
//            }
//
//            // Add the alert view to the window
//            window.addSubview(self)
//            window.bringSubviewToFront(self)
//
//            // Ensure the alert covers the entire window
//            translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                topAnchor.constraint(equalTo: window.topAnchor),
//                bottomAnchor.constraint(equalTo: window.bottomAnchor),
//                leadingAnchor.constraint(equalTo: window.leadingAnchor),
//                trailingAnchor.constraint(equalTo: window.trailingAnchor)
//            ])
//
//            stratAnimation()
//        }

}
