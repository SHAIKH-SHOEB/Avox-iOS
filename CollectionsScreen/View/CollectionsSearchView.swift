//
//  CollectionsSearchView.swift
//  Avox
//
//  Created by Shaikh Shoeb on 05/10/24.
//

import UIKit

protocol CollectionsSearchViewDelegate: NSObjectProtocol {
    func searchButtonPressed(pexelId: String)
    func cancelButtonPressed()
}

class CollectionsSearchView: UIView, UITextFieldDelegate {

    var deviceManager         : DeviceManager?
    weak var delegate         : CollectionsSearchViewDelegate?
    
    var containerView         : UIView?
    var backButton            : UIButton?
    
    var titleLabel            : UILabel?
    var stackView             : UIStackView?
    
    var collectionIdView      : UIView?
    var collectionIdTextField : UITextField?
    var pasteButton           : UIButton?
    var searchButton          : UIButton?
    
    var fontSize              : CGFloat = 0.0
    var constant              : CGFloat = 0.0
    var containerHeight       : CGFloat = 0.0
   
    init() {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        //self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loadBackButtonPressed)))
        loadDeviceManager()
        loadContainerView()
        loadSearchButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    func loadDeviceManager() {
        deviceManager = DeviceManager.instance
        if deviceManager!.deviceType == deviceManager!.iPhone5 || deviceManager!.deviceType == deviceManager!.iPhone6 {
            fontSize = Helper.DeviceManager.IPHONE_5_6_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_5_6_CONSTANT
            containerHeight = Helper.DeviceManager.IPHONE_5_6_CONTAINER_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iPhone6plus || deviceManager!.deviceType == deviceManager!.iPhoneX {
            fontSize = Helper.DeviceManager.IPHONE_6PLUS_X_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_6PLUS_X_CONSTANT
            containerHeight = Helper.DeviceManager.IPHONE_6PLUS_X_CONTAINER_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iphone12Family || deviceManager!.deviceType == deviceManager!.iphoneProMax {
            fontSize = Helper.DeviceManager.IPHONE_12FAMILY_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_12FAMILY_CONSTANT
            containerHeight = Helper.DeviceManager.IPHONE_12FAMILY_CONTAINER_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iPhone {
            fontSize = Helper.DeviceManager.IPHONE_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_CONSTANT
            containerHeight = Helper.DeviceManager.IPHONE_CONTAINER_HEIGHT
        }
    }
    
    func loadContainerView() {
        containerView = UIView()
        containerView!.translatesAutoresizingMaskIntoConstraints = false
        containerView!.backgroundColor = Helper.Color.bgPrimary
        AppUtils.applyBorderOnView(view: containerView!, radius: constant*2)
        containerView!.layer.masksToBounds = true
        containerView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        self.addSubview(containerView!)
        NSLayoutConstraint.activate([
            containerView!.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView!.heightAnchor.constraint(equalToConstant: containerHeight*2),
            containerView!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constant*3),
            containerView!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -constant*3)
        ])
        
        stackView = UIStackView()
        stackView!.translatesAutoresizingMaskIntoConstraints = false
        stackView!.axis = NSLayoutConstraint.Axis.vertical
        stackView!.distribution = .fillEqually
        stackView!.spacing = constant
        stackView!.backgroundColor = UIColor.clear
        containerView!.addSubview(stackView!)
        NSLayoutConstraint.activate([
            stackView!.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor, constant: constant*3),
            stackView!.topAnchor.constraint(equalTo: containerView!.topAnchor, constant: constant*2),
            stackView!.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor, constant: -constant*3),
            stackView!.bottomAnchor.constraint(equalTo: containerView!.bottomAnchor, constant: -constant*2)
        ])
        
        titleLabel = UILabel()
        titleLabel!.text = AppUtils.localizableString(key: AppUtils.localizableString(key: LanguageConstant.searchCollections))
        titleLabel!.font = UIFont.appFontBold(ofSize: fontSize*1.2)
        titleLabel!.textAlignment = .center
        titleLabel!.textColor = Helper.Color.textPrimary
        stackView!.addArrangedSubview(titleLabel!)
        
        collectionIdView = UIView()
        AppUtils.applyBorderOnView(view: collectionIdView!, radius: constant)
        collectionIdView!.layer.masksToBounds = false
        stackView!.addArrangedSubview(collectionIdView!)
        
        pasteButton = UIButton(type: .system)
        pasteButton!.translatesAutoresizingMaskIntoConstraints = false
        pasteButton!.setTitle(AppUtils.localizableString(key: LanguageConstant.paste), for: .normal)
        pasteButton!.titleLabel!.font = UIFont.appFontBold(ofSize: fontSize)
        pasteButton!.backgroundColor = UIColor.clear
        pasteButton!.setTitleColor(Helper.Color.appPrimary, for: .normal)
        pasteButton!.addTarget(self, action: #selector(didPasteButtonPressed), for: .touchDown)
        collectionIdView!.addSubview(pasteButton!)
        NSLayoutConstraint.activate([
            pasteButton!.topAnchor.constraint(equalTo: collectionIdView!.topAnchor),
            pasteButton!.trailingAnchor.constraint(equalTo: collectionIdView!.trailingAnchor),
            pasteButton!.bottomAnchor.constraint(equalTo: collectionIdView!.bottomAnchor),
            pasteButton!.widthAnchor.constraint(equalToConstant: containerHeight)
        ])
        
        collectionIdTextField = UITextField()
        collectionIdTextField!.translatesAutoresizingMaskIntoConstraints = false
        collectionIdTextField!.textColor = Helper.Color.textSecondary
        collectionIdTextField!.backgroundColor = UIColor.clear
        collectionIdTextField!.font = UIFont.appFontRegular(ofSize: fontSize)
        collectionIdTextField!.delegate = self
        collectionIdTextField!.keyboardType = .alphabet
        collectionIdTextField!.autocapitalizationType = .none
        collectionIdTextField!.autocorrectionType = .no
        collectionIdTextField!.attributedPlaceholder = NSAttributedString(string: AppUtils.localizableString(key: LanguageConstant.collectionsId), attributes: [NSAttributedString.Key.font: UIFont.appFontRegular(ofSize: fontSize) as Any])
        collectionIdTextField!.inputAccessoryView = addToolBar(cancelSelector: #selector(cancelButtonTapped), doneSelector: #selector(doneButtonTapped))
        collectionIdView!.addSubview(collectionIdTextField!)
        NSLayoutConstraint.activate([
            collectionIdTextField!.leadingAnchor.constraint(equalTo: collectionIdView!.leadingAnchor, constant: constant*1.5),
            collectionIdTextField!.topAnchor.constraint(equalTo: collectionIdView!.topAnchor, constant: constant),
            collectionIdTextField!.trailingAnchor.constraint(equalTo: pasteButton!.leadingAnchor, constant: -constant*0.5),
            collectionIdTextField!.bottomAnchor.constraint(equalTo: collectionIdView!.bottomAnchor, constant: -constant),
        ])
    }
    
    func loadSearchButton() {
        searchButton = UIButton(type: .system)
        searchButton!.setTitle(AppUtils.localizableString(key: LanguageConstant.search), for: .normal)
        searchButton!.titleLabel!.font = UIFont.appFontBold(ofSize: fontSize)
        searchButton!.backgroundColor = Helper.Color.google
        searchButton!.isEnabled = false
        searchButton!.setTitleColor(Helper.Color.accent, for: .normal)
        searchButton!.layer.cornerRadius = constant
        searchButton!.addTarget(self, action: #selector(searchButtonPressed), for: .touchDown)
        stackView!.addArrangedSubview(searchButton!)
        
        backButton = UIButton(type: .system)
        backButton!.translatesAutoresizingMaskIntoConstraints = false
        backButton!.backgroundColor = UIColor.clear
        backButton!.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton!.tintColor = Helper.Color.appPrimary
        backButton!.addTarget(self, action: #selector(loadBackButtonPressed), for: .touchUpInside)
        containerView!.addSubview(backButton!)
        NSLayoutConstraint.activate([
            backButton!.topAnchor.constraint(equalTo: containerView!.topAnchor, constant: constant*2),
            backButton!.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor, constant: -constant*2)
        ])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == collectionIdTextField {
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let allowedCharacters = CharacterSet.letters
            let characterSet = CharacterSet(charactersIn: string)
            if newText.count <= 7 && allowedCharacters.isSuperset(of: characterSet) {
                textField.text = newText
                if newText.count == 7 {
                    searchButton!.backgroundColor = Helper.Color.appPrimary
                    searchButton!.isEnabled = true
                } else {
                    searchButton!.backgroundColor = Helper.Color.google
                    searchButton!.isEnabled = false
                }
            }
            return false
        }
        return true
    }
    
    private func addToolBar(cancelSelector: Selector, doneSelector: Selector) -> UIToolbar {
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .black
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: cancelSelector),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: doneSelector)
        ]
        numberToolbar.sizeToFit()
        return numberToolbar
    }
    
    @objc func doneButtonTapped() {
        collectionIdTextField!.resignFirstResponder()
    }
    
    @objc func cancelButtonTapped() {
        if collectionIdTextField!.text != "" {
            collectionIdTextField!.text = ""
        }
        collectionIdTextField!.resignFirstResponder()
    }
    
    @objc func didPasteButtonPressed() {
        if let copiedText = AppUtils.getCopiedText() {
            if copiedText.count == 7 {
                collectionIdTextField!.text = copiedText
                searchButton!.backgroundColor = Helper.Color.appPrimary
                searchButton!.isEnabled = true
            }
        }
    }
    
    @objc func searchButtonPressed() {
        if delegate != nil {
            delegate!.searchButtonPressed(pexelId: collectionIdTextField!.text!)
        }
    }
    
    @objc func loadBackButtonPressed() {
        if delegate != nil {
            delegate!.cancelButtonPressed()
        }
    }
}
