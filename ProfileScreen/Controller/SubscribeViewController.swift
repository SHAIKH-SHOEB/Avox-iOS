//
//  SubscribeViewController.swift
//  Avox
//
//  Created by Shoeb on 17/03/25.
//

import UIKit

class SubscribeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var deviceManager      : DeviceManager?
    
    var backgroundImage    : UIImageView?
    var backView           : UIView?
    
    var navigationBar      : UILabel?
    var tableView          : UITableView?
    
    var continueButton     : UIButton?
    var subscribeModel     : [AppProvider]?
    
    var fontSize           : CGFloat = 0.0
    var constant           : CGFloat = 0.0
    var cellHeight         : CGFloat = 0.0
    var containerHeight    : CGFloat = 0.0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        subscribeModel = AppProvider.getSubscriptionProvider()
        loadDeviceManager()
        loadBaseView()
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
        backgroundImage = UIImageView()
        backgroundImage!.translatesAutoresizingMaskIntoConstraints = false
        //backgroundImage!.image = UIImage.setAnimatedGif(forResource: "background", ofType: "gif")
        backgroundImage!.image = UIImage(named: "Background")
        self.view.addSubview(backgroundImage!)
        NSLayoutConstraint.activate([
            backgroundImage!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundImage!.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundImage!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundImage!.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3)
        ])
        
        
        backView = UIView()
        backView!.translatesAutoresizingMaskIntoConstraints = false
        backView!.backgroundColor = Helper.Color.bgPrimary
        applyTopCorners(view: backView!)
        self.view.addSubview(backView!)
        NSLayoutConstraint.activate([
            backView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backView!.topAnchor.constraint(equalTo: backgroundImage!.bottomAnchor, constant: -10),
            backView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        navigationBar = UILabel()
        navigationBar!.translatesAutoresizingMaskIntoConstraints = false
        navigationBar!.text = AppUtils.localizableString(key: "Select Subscription Plan")
        navigationBar!.font = UIFont.appFontBold(ofSize: fontSize*1.6)
        navigationBar!.textColor = Helper.Color.textPrimary
        navigationBar!.textAlignment = .left
        navigationBar!.isUserInteractionEnabled = true
        backView!.addSubview(navigationBar!)
        NSLayoutConstraint.activate([
            navigationBar!.leadingAnchor.constraint(equalTo: backView!.leadingAnchor, constant: constant),
            navigationBar!.topAnchor.constraint(equalTo: backView!.topAnchor, constant: constant*2),
            navigationBar!.trailingAnchor.constraint(equalTo: backView!.trailingAnchor, constant: -constant)
        ])
        
        continueButton = UIButton(type: .system)
        continueButton!.translatesAutoresizingMaskIntoConstraints = false
        continueButton!.setTitle( AppUtils.localizableString(key: "Continue"), for: .normal)
        continueButton!.titleLabel!.font = UIFont.appFontBold(ofSize: fontSize)
        continueButton!.backgroundColor = Helper.Color.appPrimary
        continueButton!.layer.cornerRadius = cellHeight*0.5
        continueButton!.setTitleColor(Helper.Color.bgPrimary, for: .normal)
        continueButton!.addTarget(self, action: #selector(continueButtonPressed), for: .touchDown)
        backView!.addSubview(continueButton!)
        NSLayoutConstraint.activate([
            continueButton!.leadingAnchor.constraint(equalTo: backView!.leadingAnchor, constant: constant),
            continueButton!.trailingAnchor.constraint(equalTo: backView!.trailingAnchor, constant: -constant),
            continueButton!.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            continueButton!.heightAnchor.constraint(equalToConstant: cellHeight)
        ])
        
        tableView = UITableView()
        tableView!.translatesAutoresizingMaskIntoConstraints = false
        tableView!.backgroundColor = UIColor.clear
        tableView!.register(UINib(nibName: "SubscribeTableViewCell", bundle: nil), forCellReuseIdentifier: "SubscribeTableViewCell")
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.showsVerticalScrollIndicator = false
        tableView!.separatorStyle = .none
        backView!.addSubview(tableView!)
        NSLayoutConstraint.activate([
            tableView!.leadingAnchor.constraint(equalTo: backView!.leadingAnchor, constant: constant),
            tableView!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor, constant: constant*2),
            tableView!.trailingAnchor.constraint(equalTo: backView!.trailingAnchor, constant: -constant),
            tableView!.bottomAnchor.constraint(equalTo: continueButton!.topAnchor, constant: -constant)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribeModel!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SubscribeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SubscribeTableViewCell", for: indexPath) as! SubscribeTableViewCell
        cell.updateTableViewCellForSubscribe(model: subscribeModel![indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        unCheckAll()
        subscribeModel![indexPath.row].index = 1
        tableView.reloadData()
    }
    
    func unCheckAll() {
        for model in subscribeModel! {
            model.index = 0
        }
    }
    
    @objc func continueButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
   
    //MARK: Apply Corners To View
    func applyTopCorners(view:UIView, cornerRadius: Double = 20.0) {
        let path = UIBezierPath(roundedRect: self.view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.view.bounds
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
    }
}
