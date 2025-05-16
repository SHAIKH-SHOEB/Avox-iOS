//
//  CustomBottomSheetView.swift
//  Avox
//
//  Created by Nimap on 11/01/25.
//

import UIKit

protocol CustomBottomSheetViewDelegate: NSObjectProtocol {
    func backButtonPressed()
    func didCustomBottomSheetPressed(name: String, type: Int)
}

class CustomBottomSheetView: UIView, UITableViewDataSource, UITableViewDelegate {

    var navigationBar     : UILabel?
    var mainContainerView : UIView!
    var containerView     : UIView!
    var cancelButton      : UIButton!
    
    var optionModel       : [AddEventProvider]? = []
    var tableView         : UITableView?
    
    weak var delegate     : CustomBottomSheetViewDelegate?
    var deviceManager     : DeviceManager?
    
    var type              : Int = -1
    var navigationTitle   : String = ""
    
    var fontSize          : CGFloat = 0.0
    var constant          : CGFloat = 0.0
    var cellHeight        : CGFloat = 0.0
    var containerHeight   : CGFloat = 0.0
 
    init(type: Int) {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.type = type
        if type == 1 {
            optionModel = AddEventProvider.getColorTypeTitleProvider()
            navigationTitle = "Color Type"
        }else if type == 2 {
            optionModel = AddEventProvider.getEventTypeTitleProvider()
            navigationTitle = "Event Type"
        }else if type == 3 {
            optionModel = AddEventProvider.getReminderTitleProvider()
            navigationTitle = "Reminder"
        }
        loadDeviceManager()
        loadPage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadPage() {
        loadContainerView()
        loadNavigationBar()
        loadTableView()
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
    
    //MARK: For Bottom Sheet
    func loadContainerView(){
        mainContainerView = UIView()
        mainContainerView.translatesAutoresizingMaskIntoConstraints = false
        mainContainerView.backgroundColor = UIColor.clear
        self.addSubview(mainContainerView)
        NSLayoutConstraint.activate([
            mainContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainContainerView.heightAnchor.constraint(equalToConstant: containerHeight*5)
        ])
        
        cancelButton = UIButton(type: .system)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        cancelButton.tintColor = Helper.Color.appPrimary
        cancelButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        mainContainerView.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -constant*1.5)
        ])
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = Helper.Color.bgPrimary
        containerView.layer.cornerRadius = constant*2
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mainContainerView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: constant*1.5),
            containerView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor)
        ])
    }
    
    func loadNavigationBar() {
        navigationBar = UILabel()
        navigationBar!.translatesAutoresizingMaskIntoConstraints = false
        navigationBar!.text = AppUtils.localizableString(key: navigationTitle)
        navigationBar!.font = UIFont.appFontBold(ofSize: fontSize*1.4)
        navigationBar!.textColor = Helper.Color.textPrimary
        navigationBar!.textAlignment = .left
        navigationBar!.isUserInteractionEnabled = true
        containerView.addSubview(navigationBar!)
        NSLayoutConstraint.activate([
            navigationBar!.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: constant*1.5),
            navigationBar!.topAnchor.constraint(equalTo: containerView.topAnchor, constant: constant*1.5)
        ])
    }
    
    func loadTableView() {
        tableView = UITableView()
        tableView!.translatesAutoresizingMaskIntoConstraints = false
        tableView!.backgroundColor = UIColor.clear
        tableView!.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomBottomTableViewCell")
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.showsVerticalScrollIndicator = false
        tableView!.separatorStyle = .none
        containerView.addSubview(tableView!)
        NSLayoutConstraint.activate([
            tableView!.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: constant),
            tableView!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor, constant: constant*1.5),
            tableView!.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -constant),
            tableView!.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -constant)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionModel!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SettingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomBottomTableViewCell", for: indexPath) as! SettingTableViewCell
        cell.updateCustomSheetTableViewCell(model: optionModel![indexPath.row], type: type)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Hello World")
        if delegate != nil {
            delegate!.didCustomBottomSheetPressed(name: optionModel![indexPath.row].title!, type: type)
        }
    }
    
    @objc func backButtonPressed() {
        if delegate != nil {
            delegate!.backButtonPressed()
        }
    }
}
