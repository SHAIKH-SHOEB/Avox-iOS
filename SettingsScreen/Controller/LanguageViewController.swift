//
//  LanguageViewController.swift
//  Avox
//
//  Created by Nimap on 26/01/24.
//

import UIKit

protocol LanguageViewControllerDelegate: NSObjectProtocol {
    func didSelectChangeLanguage(languageKey: Int)
}

class LanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var navigationBar     : UILabel?
    var mainContainerView : UIView!
    var containerView     : UIView!
    var cancelButton      : UIButton!
    
    var languageModel     : [AppProvider]? = []
    var tableView         : UITableView?
    
    weak var delegate     : LanguageViewControllerDelegate?
    var deviceManager     : DeviceManager?
    
    var fontSize          : CGFloat = 0.0
    var constant          : CGFloat = 0.0
    var cellHeight        : CGFloat = 0.0
    var containerHeight   : CGFloat = 0.0
    
    var index             : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.edgesForExtendedLayout = UIRectEdge()
        languageModel = AppProvider.getLanguageProvider()
        loadDeviceManager()
        loadPage()
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
        self.view.addSubview(mainContainerView)
        NSLayoutConstraint.activate([
            mainContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mainContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mainContainerView.heightAnchor.constraint(equalToConstant: cellHeight*8)
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
        applyTopCorners(view: containerView, cornerRadius: constant*2.5)
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
        navigationBar!.text = AppUtils.localizableString(key: LanguageConstant.selectLanguage)
        navigationBar!.font = UIFont.appFontBold(ofSize: fontSize*1.4)
        navigationBar!.textColor = Helper.Color.textPrimary
        navigationBar!.textAlignment = .left
        navigationBar!.isUserInteractionEnabled = true
        containerView.addSubview(navigationBar!)
        NSLayoutConstraint.activate([
            navigationBar!.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: constant*2),
            navigationBar!.topAnchor.constraint(equalTo: containerView.topAnchor, constant: constant*2)
        ])
    }
    
    func loadTableView() {
        tableView = UITableView()
        tableView!.translatesAutoresizingMaskIntoConstraints = false
        tableView!.backgroundColor = UIColor.clear
        tableView!.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "LangaugeTableViewCell")
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
        return languageModel!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SettingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LangaugeTableViewCell", for: indexPath) as! SettingTableViewCell
        cell.updateLanguageTableViewCell(model: languageModel![indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        backButtonPressed()
        delegate!.didSelectChangeLanguage(languageKey: languageModel![indexPath.row].id!)
    }
    
    @objc func backButtonPressed() {
        startDownwardAnimation {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: For Blur Effect
    func loadBlackBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.5
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    func startDownwardAnimation(animationCompleted : @escaping (()->())) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            UIView.animate(withDuration: 0.3, animations: {
                self.mainContainerView?.frame.origin.y = self.view.frame.height
            }, completion: { (_) in
                animationCompleted()
            })
        }
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
