//
//  ChooseAvatarViewController.swift
//  Avox
//
//  Created by Shaikh Shoeb on 14/04/24.
//

import UIKit

protocol ChooseAvatarViewControllerDelegate: NSObjectProtocol {
    func didSelectAvatarUrlString(avatarUrl: String)
}

class ChooseAvatarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var deviceManager     : DeviceManager?
    weak var delegate     : ChooseAvatarViewControllerDelegate?
    
    var navigationBar     : UILabel?
    var mainContainerView : UIView?
    var containerView     : UIView?
    var cancelButton      : UIButton?
    
    var segmentedControl  : UISegmentedControl?
    
    var avatarModel       : [AppProvider]?
    var collectionView    : UICollectionView?
    
    var fontSize          : CGFloat = 0.0
    var constant          : CGFloat = 0.0
    var cellHeight        : CGFloat = 0.0

    let itemsPerRow       : CGFloat = 4
    let sectionInsets     = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.edgesForExtendedLayout = UIRectEdge()
        avatarModel = AppProvider.getAvatarProvider()
        avatarModel!.shuffle()
        loadDeviceManager()
        loadPage()
    }
    
    func loadPage() {
        loadContainerView()
        loadNavigationBar()
        loadBaseView()
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
    
    func loadContainerView(){
        mainContainerView = UIView()
        mainContainerView!.translatesAutoresizingMaskIntoConstraints = false
        mainContainerView!.backgroundColor = UIColor.clear
        self.view.addSubview(mainContainerView!)
        NSLayoutConstraint.activate([
            mainContainerView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainContainerView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mainContainerView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mainContainerView!.heightAnchor.constraint(equalToConstant: cellHeight*8)
        ])
        
        cancelButton = UIButton(type: .system)
        cancelButton!.translatesAutoresizingMaskIntoConstraints = false
        cancelButton!.backgroundColor = UIColor.clear
        cancelButton!.setImage(UIImage(systemName: "xmark"), for: .normal)
        cancelButton!.tintColor = Helper.Color.appPrimary
        cancelButton!.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        mainContainerView!.addSubview(cancelButton!)
        NSLayoutConstraint.activate([
            cancelButton!.topAnchor.constraint(equalTo: mainContainerView!.topAnchor),
            cancelButton!.trailingAnchor.constraint(equalTo: mainContainerView!.trailingAnchor, constant: -constant*1.5)
        ])
        
        containerView = UIView()
        containerView!.translatesAutoresizingMaskIntoConstraints = false
        containerView!.backgroundColor = Helper.Color.bgPrimary
        applyTopCorners(view: containerView!, cornerRadius: constant*2.5)
        mainContainerView!.addSubview(containerView!)
        NSLayoutConstraint.activate([
            containerView!.leadingAnchor.constraint(equalTo: mainContainerView!.leadingAnchor),
            containerView!.topAnchor.constraint(equalTo: cancelButton!.bottomAnchor, constant: constant*1.5),
            containerView!.trailingAnchor.constraint(equalTo: mainContainerView!.trailingAnchor),
            containerView!.bottomAnchor.constraint(equalTo: mainContainerView!.bottomAnchor)
        ])
    }
    
    func loadNavigationBar() {
        navigationBar = UILabel()
        navigationBar!.translatesAutoresizingMaskIntoConstraints = false
        navigationBar!.text = AppUtils.localizableString(key: LanguageConstant.selectAvatar)
        //navigationBar!.font = UIFont.systemFont(ofSize: fontSize*1.2, weight: UIFont.Weight.bold)
        navigationBar!.font = UIFont.appFontBold(ofSize: fontSize*1.4)
        navigationBar!.textColor = Helper.Color.textPrimary
        navigationBar!.textAlignment = .left
        navigationBar!.isUserInteractionEnabled = true
        containerView!.addSubview(navigationBar!)
        NSLayoutConstraint.activate([
            navigationBar!.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor, constant: constant*2),
            navigationBar!.topAnchor.constraint(equalTo: containerView!.topAnchor, constant: constant*2)
        ])
    }
    
    func loadBaseView() {
        let items = [AppUtils.localizableString(key: LanguageConstant.all),
                     AppUtils.localizableString(key: LanguageConstant.man),
                     AppUtils.localizableString(key: LanguageConstant.woman)]
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl!.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl!.selectedSegmentIndex = 0
        segmentedControl!.backgroundColor = UIColor.clear
        segmentedControl!.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.appFontBold(ofSize: fontSize) as Any, NSAttributedString.Key.foregroundColor: Helper.Color.accent!],for: .selected)
        segmentedControl!.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.appFontBold(ofSize: fontSize) as Any, NSAttributedString.Key.foregroundColor: Helper.Color.textPrimary!],for: .normal)
        segmentedControl!.layer.cornerRadius = constant
        segmentedControl!.tintColor = Helper.Color.bgSecondary
        if #available(iOS 13.0, *) {
            segmentedControl!.selectedSegmentTintColor = Helper.Color.appPrimary
        } else {
            segmentedControl!.tintColor = Helper.Color.appPrimary
        }
        segmentedControl!.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        containerView!.addSubview(segmentedControl!)
        NSLayoutConstraint.activate([
            segmentedControl!.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor, constant: constant),
            segmentedControl!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor, constant: constant),
            segmentedControl!.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor, constant: -constant),
            segmentedControl!.heightAnchor.constraint(equalToConstant: cellHeight*0.8)
        ])
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView!.translatesAutoresizingMaskIntoConstraints = false
        collectionView!.register(UINib(nibName: "AvatarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AvatarCollectionViewCell")
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.backgroundColor = UIColor.clear
        containerView!.addSubview(collectionView!)
        NSLayoutConstraint.activate([
            collectionView!.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor, constant: constant),
            collectionView!.topAnchor.constraint(equalTo: segmentedControl!.bottomAnchor, constant: constant*2),
            collectionView!.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor, constant: -constant),
            collectionView!.bottomAnchor.constraint(equalTo: containerView!.bottomAnchor, constant: -constant)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarModel!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCollectionViewCell", for: indexPath) as! AvatarCollectionViewCell
        cell.imageView.image = UIImage(named: "\(avatarModel![indexPath.row].icon!)")
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left + sectionInsets.right + constant * CGFloat(itemsPerRow - 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return constant
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return constant
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if delegate != nil {
            delegate!.didSelectAvatarUrlString(avatarUrl: avatarModel![indexPath.row].icon!)
        }
        backButtonPressed()
    }
            
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        // Handle segmented control value changed event
        print("Selected segment index: \(sender.selectedSegmentIndex)")
        if sender.selectedSegmentIndex == 0 {
            avatarModel = AppProvider.getAvatarProvider()
            avatarModel!.shuffle()
        }else if sender.selectedSegmentIndex == 1 {
            avatarModel = AppProvider.getAvatarProvider(gender: "Man")
        }else if sender.selectedSegmentIndex == 2 {
            avatarModel = AppProvider.getAvatarProvider(gender: "Woman")
        }
        collectionView!.reloadData()
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
