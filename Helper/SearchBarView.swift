//
//  SearchBarView.swift
//  Avox
//
//  Created by Nimap on 18/03/24.
//

import UIKit

@objc protocol SearchBarViewDelegate: NSObjectProtocol {
    @objc optional func textDidChange(searchText: String)
    @objc optional func backButtonPressed()
}

class SearchBarView: UIView, UITextFieldDelegate {

    var deviceManager     : DeviceManager?
    var delegate          : SearchBarViewDelegate?
    
    var cancelButton      : UIButton?
    var searchView        : UIView?
    var searchTextField   : UITextField?
    
    var fontSize          : CGFloat = 0.0
    var constant          : CGFloat = 0.0
    var cellHeight        : CGFloat = 0.0
    
    var leftIcon          : UIImage?
    var searchHint        : String?
    
    init(searchHint: String,leftIcon: UIImage? = nil) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.clear
        self.leftIcon = leftIcon
        self.searchHint = searchHint
        loadDeviceManager()
        loadBackButton()
        loadSearchBarView()
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
    
    func loadBackButton() {
        if leftIcon != nil {
            cancelButton = UIButton(type: .system)
            cancelButton!.translatesAutoresizingMaskIntoConstraints = false
            cancelButton!.backgroundColor = UIColor.clear
            cancelButton!.setImage(leftIcon, for: .normal)
            cancelButton!.tintColor = Helper.Color.appPrimary
            cancelButton!.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
            self.addSubview(cancelButton!)
            NSLayoutConstraint.activate([
                cancelButton!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constant*0.5),
                cancelButton!.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        }
    }
    
    func loadSearchBarView() {
        searchView = UIView()
        searchView!.translatesAutoresizingMaskIntoConstraints = false
        searchView!.backgroundColor = Helper.Color.bgPrimary
        AppUtils.applyBorderOnView(view: searchView!, radius: constant)
        searchView!.layer.masksToBounds = false
        self.addSubview(searchView!)
        if leftIcon != nil {
            NSLayoutConstraint.activate([
                searchView!.leadingAnchor.constraint(equalTo: cancelButton!.trailingAnchor, constant: constant),
                searchView!.topAnchor.constraint(equalTo: self.topAnchor),
                searchView!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -constant*0.5),
                searchView!.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
        }else {
            NSLayoutConstraint.activate([
                searchView!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constant*0.5),
                searchView!.topAnchor.constraint(equalTo: self.topAnchor),
                searchView!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -constant*0.5),
                searchView!.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
        }
        
        searchTextField = UITextField()
        searchTextField!.translatesAutoresizingMaskIntoConstraints = false
        searchTextField!.textColor = Helper.Color.textSecondary
        searchTextField!.backgroundColor = UIColor.clear
        searchTextField!.font = UIFont.appFontRegular(ofSize: fontSize)
        searchTextField!.delegate = self
        searchTextField!.keyboardType = .default
        searchTextField!.autocapitalizationType = .none
        searchTextField!.autocorrectionType = .no
        let placeholderAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.appFontRegular(ofSize: fontSize) as Any]
        let attributedPlaceholder = NSAttributedString(string: AppUtils.localizableString(key: searchHint!), attributes: placeholderAttributes)
        searchTextField!.attributedPlaceholder = attributedPlaceholder
        searchView!.addSubview(searchTextField!)
        NSLayoutConstraint.activate([
            searchTextField!.leadingAnchor.constraint(equalTo: searchView!.leadingAnchor, constant: constant*1.5),
            searchTextField!.topAnchor.constraint(equalTo: searchView!.topAnchor, constant: constant),
            searchTextField!.trailingAnchor.constraint(equalTo: searchView!.trailingAnchor, constant: -constant*1.5),
            searchTextField!.bottomAnchor.constraint(equalTo: searchView!.bottomAnchor, constant: -constant),
            searchTextField!.heightAnchor.constraint(equalToConstant: cellHeight*0.6)
        ])
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTextField!.endEditing(true)
        if delegate != nil {
            delegate!.textDidChange?(searchText: "\(textField.text ?? "")")
        }
        return true
    }
     
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if delegate != nil {
            delegate!.textDidChange?(searchText: "\(textField.text ?? "")")
        }
    }
    
    @objc func backButtonPressed() {
        if delegate != nil {
            delegate!.backButtonPressed!()
        }
    }
    
    func resignSearchBar() {
        searchTextField!.resignFirstResponder()
    }
}
