//
//  SettingViewController.swift
//  Avox
//
//  Created by Nimap on 26/01/24.
//

import UIKit
import SafariServices

class SettingViewController: UIViewController & UIScrollViewDelegate & UITableViewDelegate & UITableViewDataSource, LanguageViewControllerDelegate, AvoxAlertViewDelegate, AuthenticationUIViewDelegate, VerificationParserDelegate, ImageStatusViewDelegate, ChooseAvatarViewControllerDelegate {
    
    var deviceManager       : DeviceManager?
    var navigationBar       : UINavigationBar?
    
    var accountView         : UIView?
    var accountImageView    : UIImageView?
    
    var stackView           : UIStackView?
    var nickNameLabel       : UILabel?
    var emailIdLabel        : UILabel?
    
    var addAccountImage     : UIImageView?
    var generalLabel        : UILabel?
    
    var tableView           : UITableView?
    var settingArray        : [AppProvider]?
    
    var bottomView          : UIView?
    var descriptionLabel    : UILabel?
    var pexelsLogoImageView : UIImageView?
    
    var alertView           : AvoxAlertView?
    var activityIndicator   : AvoxAlertView?
    
    var authenticationView  : AuthenticationUIView?
    var verificationParser  : VerificationParser?
    var languageKey         : Int?
    
    var imageStatusView     : ImageStatusView?
    
    var fontSize            : CGFloat = 0.0
    var constant            : CGFloat = 0.0
    var cellHeight          : CGFloat = 0.0
    var containerHeight     : CGFloat = 0.0
    var avatarUrl           = "Person"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Helper.Color.bgPrimary
        UINavigationBar.appearance().isTranslucent = false
        settingArray = AppProvider.getSettingsTitleProvider()
        loadDeviceManager()
        loadPage()
    }
    
    @objc func handleSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        // You can adjust the threshold as needed
        let swipeThreshold: CGFloat = -50.0
        
        if translation.x < swipeThreshold {
            // Perform custom action or navigation
            print("Swiped back in the second page!")
        }
    }
    
    func loadPage(){
        loadNavigationBar()
        loadProfileView()
        loadBottomView()
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
    
    func loadNavigationBar() {
        navigationBar = UINavigationBar()
        navigationBar!.translatesAutoresizingMaskIntoConstraints = false
        let navigationItem = UINavigationItem()
        navigationItem.title = AppUtils.localizableString(key: LanguageConstant.settings)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backButtonPressed))
        navigationBar!.items = [navigationItem]
        navigationBar!.barTintColor = Helper.Color.bgPrimary
        navigationBar!.tintColor = Helper.Color.appPrimary
        navigationBar!.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar!.prefersLargeTitles = true
        let largeTitleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.appFontBold(ofSize: fontSize*1.8) as Any, .foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar!.largeTitleTextAttributes = largeTitleAttributes
        self.view.addSubview(navigationBar!)
        NSLayoutConstraint.activate([
            navigationBar!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            navigationBar!.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func loadProfileView() {
        accountView = UIView()
        accountView!.translatesAutoresizingMaskIntoConstraints = false
        accountView!.backgroundColor = Helper.Color.bgPrimary
        //accountView!.layer.cornerRadius = constant*1.5
        AppUtils.applyBorderOnView(view: accountView!, radius: constant*1.5)
        accountView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileButtonPressed)))
        self.view.addSubview(accountView!)
        NSLayoutConstraint.activate([
            accountView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: constant*1.5),
            accountView!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor),
            accountView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -constant*1.5),
            accountView!.heightAnchor.constraint(equalToConstant: cellHeight*1.5)
        ])
        
        accountImageView = UIImageView()
        accountImageView!.translatesAutoresizingMaskIntoConstraints = false
        if UserDefaults.standard.string(forKey: "profile") != nil {
            accountImageView!.image = UIImage(named: UserDefaults.standard.string(forKey: "profile")!)
        }else {
            accountImageView!.image = UIImage(named: avatarUrl)
        }
        accountImageView!.layer.cornerRadius = (cellHeight*1.2) / 2
        accountImageView!.layer.masksToBounds = true
        accountImageView!.layer.borderWidth = 2
        accountImageView!.layer.borderColor = Helper.Color.appPrimary?.cgColor
        accountImageView!.contentMode = UIView.ContentMode.scaleToFill
        accountImageView!.isUserInteractionEnabled = true
        accountImageView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loadImageStatusView)))
        accountView!.addSubview(accountImageView!)
        NSLayoutConstraint.activate([
            accountImageView!.heightAnchor.constraint(equalToConstant: cellHeight*1.2),
            accountImageView!.widthAnchor.constraint(equalToConstant: cellHeight*1.2),
            accountImageView!.leadingAnchor.constraint(equalTo: accountView!.leadingAnchor, constant: constant*1.5),
            accountImageView!.centerYAnchor.constraint(equalTo: accountView!.centerYAnchor)
        ])
        
        addAccountImage = UIImageView()
        addAccountImage!.translatesAutoresizingMaskIntoConstraints = false
        addAccountImage!.contentMode = .scaleAspectFill
        addAccountImage!.backgroundColor = UIColor.clear
        if UserDefaults.standard.string(forKey: "nickName") == "" {
            addAccountImage!.image = UIImage(systemName: "plus")
        }else {
            addAccountImage!.image = UIImage(systemName: "checkmark.seal")
        }
        addAccountImage!.tintColor = Helper.Color.appPrimary
        addAccountImage!.isUserInteractionEnabled = true
        addAccountImage!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressAuthentication)))
        accountView!.addSubview(addAccountImage!)
        NSLayoutConstraint.activate([
            addAccountImage!.trailingAnchor.constraint(equalTo: accountView!.trailingAnchor, constant: -constant*1.5),
            addAccountImage!.centerYAnchor.constraint(equalTo: accountView!.centerYAnchor),
            addAccountImage!.heightAnchor.constraint(equalToConstant: cellHeight*0.5),
            addAccountImage!.widthAnchor.constraint(equalToConstant: cellHeight*0.5)
        ])
        
        stackView = UIStackView()
        stackView!.translatesAutoresizingMaskIntoConstraints = false
        stackView!.axis = NSLayoutConstraint.Axis.vertical
        stackView!.distribution = .fillEqually
        stackView!.spacing = constant*0.5
        stackView!.backgroundColor = UIColor.clear
        accountView!.addSubview(stackView!)
        NSLayoutConstraint.activate([
            stackView!.leadingAnchor.constraint(equalTo: accountImageView!.trailingAnchor, constant: constant),
            stackView!.trailingAnchor.constraint(equalTo: addAccountImage!.leadingAnchor, constant: -constant),
            stackView!.centerYAnchor.constraint(equalTo: accountImageView!.centerYAnchor)
        ])
        
        nickNameLabel = UILabel()
        nickNameLabel!.text = "\(AppUtils.localizableString(key: LanguageConstant.name)) : \(AppUtils.setNickName())"
        nickNameLabel!.font = UIFont.appFontMedium(ofSize: fontSize)
        nickNameLabel!.textColor = Helper.Color.textPrimary
        nickNameLabel!.textAlignment = .left
        stackView!.addArrangedSubview(nickNameLabel!)
        
        emailIdLabel = UILabel()
        emailIdLabel!.text = "\(AppUtils.localizableString(key: LanguageConstant.email))  : \(AppUtils.setEmailID())"
        emailIdLabel!.font = UIFont.appFontRegular(ofSize: fontSize)
        emailIdLabel!.textColor = Helper.Color.textSecondary
        emailIdLabel!.textAlignment = .left
        stackView!.addArrangedSubview(emailIdLabel!)
        
        generalLabel = UILabel()
        generalLabel!.translatesAutoresizingMaskIntoConstraints = false
        generalLabel!.text = AppUtils.localizableString(key: LanguageConstant.general)
        generalLabel!.font = UIFont.appFontBold(ofSize: fontSize*1.4)
        generalLabel!.textColor = Helper.Color.textPrimary
        self.view.addSubview(generalLabel!)
        NSLayoutConstraint.activate([
            generalLabel!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: constant*1.5),
            generalLabel!.topAnchor.constraint(equalTo: accountView!.bottomAnchor, constant: constant*1.5)
        ])
    }
    
    func loadBottomView() {
        bottomView = UIView()
        bottomView!.translatesAutoresizingMaskIntoConstraints = false
        bottomView!.backgroundColor = Helper.Color.appPrimary
        bottomView!.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomView!.layer.cornerRadius = constant
        self.view.addSubview(bottomView!)
        NSLayoutConstraint.activate([
            bottomView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomView!.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            bottomView!.heightAnchor.constraint(equalToConstant: cellHeight)
        ])
        
        descriptionLabel = UILabel()
        descriptionLabel!.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel!.text = String(format: AppUtils.localizableString(key: LanguageConstant.appVersion), AppConstants.APP_VERSION)
        descriptionLabel!.numberOfLines = 2
        descriptionLabel!.font = UIFont.appFontRegular(ofSize: fontSize*0.8)
        descriptionLabel!.textColor = Helper.Color.accent
        descriptionLabel!.textAlignment = .right
        descriptionLabel!.lineBreakMode = .byWordWrapping
        bottomView!.addSubview(descriptionLabel!)
        NSLayoutConstraint.activate([
            descriptionLabel!.centerYAnchor.constraint(equalTo: bottomView!.centerYAnchor),
            descriptionLabel!.trailingAnchor.constraint(equalTo: bottomView!.trailingAnchor, constant: -constant*2)
        ])
        
        pexelsLogoImageView = UIImageView()
        pexelsLogoImageView!.translatesAutoresizingMaskIntoConstraints = false
        pexelsLogoImageView!.contentMode = .scaleAspectFill
        pexelsLogoImageView!.backgroundColor = UIColor.clear
        pexelsLogoImageView!.image = UIImage(named: "Pexels")
        pexelsLogoImageView!.isUserInteractionEnabled = true
        pexelsLogoImageView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressedPexelLogo)))
        bottomView!.addSubview(pexelsLogoImageView!)
        NSLayoutConstraint.activate([
            pexelsLogoImageView!.leadingAnchor.constraint(equalTo: bottomView!.leadingAnchor, constant: constant*2),
            pexelsLogoImageView!.centerYAnchor.constraint(equalTo: bottomView!.centerYAnchor),
            pexelsLogoImageView!.heightAnchor.constraint(equalToConstant: cellHeight*0.5),
            pexelsLogoImageView!.widthAnchor.constraint(equalToConstant: cellHeight*2)
        ])
    }
    
    func loadTableView() {
        //UIDevice.current.systemName
        tableView = UITableView()
        tableView!.translatesAutoresizingMaskIntoConstraints = false
        tableView!.backgroundColor = UIColor.clear
        tableView!.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.showsVerticalScrollIndicator = false
        tableView!.isScrollEnabled = true
        tableView!.alwaysBounceVertical = false
        tableView!.separatorStyle = .none
        self.view.addSubview(tableView!)
        NSLayoutConstraint.activate([
            tableView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: constant),
            tableView!.topAnchor.constraint(equalTo: generalLabel!.bottomAnchor, constant: constant),
            tableView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -constant),
            tableView!.bottomAnchor.constraint(equalTo: bottomView!.topAnchor, constant: -constant)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SettingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        cell.updateSettingTableViewCell(model: settingArray![indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / CGFloat(settingArray!.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = collectionView.cellForItem(at: indexPath)
        //let cell = tableView.cellForRow(at: indexPath)
        loadSettingNavigateVC(index: settingArray![indexPath.row].id!)
    }
    
    func loadSettingNavigateVC(index: Int) {
        switch index {
        case 1 :
            let vc = DownloadViewController()
            self.navigationController!.pushViewController(vc, animated: true)
        case 2 :
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CollectionsViewController") as? CollectionsViewController
            self.navigationController!.pushViewController(vc!, animated: true)
        case 3 :
            let vc = SuggestionViewController()
            self.navigationController!.pushViewController(vc, animated: true)
        case 4 :
            let vc = LanguageViewController()
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        case 5 :
            print("Dark Mode")
        case 6 :
            print("Notification On")
        case 7 :
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PreferenceViewController") as? PreferenceViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        case 8 :
            let vc = TermServiceViewController(isAbout: false)
            self.navigationController!.pushViewController(vc, animated: true)
        case 9 :
            let vc = TermServiceViewController(isAbout: true)
            self.navigationController!.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func profileButtonPressed() {
        let vc = SubscribeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: LanguageViewController Delegate
    func didSelectChangeLanguage(languageKey: Int) {
        self.languageKey = languageKey
        loadAlertView(title: AppUtils.localizableString(key: LanguageConstant.changeLanguage), message: AppUtils.localizableString(key: LanguageConstant.langaugeMessage), actions: [AppUtils.localizableString(key: LanguageConstant.yes), AppUtils.localizableString(key: LanguageConstant.no)], tag: ["yes", "no"])
    }
    
    func loadSetLanguageKey(index: Int) {
        UserDefaults.standard.set(languageKey, forKey: "language")
        switch index {
        case 1 :
            UserDefaults.standard.setValue(AppConstants.LanguageCode.banglaKey.rawValue, forKey: AppConstants.LANGUAGE_KEY)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            print("Bangla")
        case 2 :
            UserDefaults.standard.setValue(AppConstants.LanguageCode.englishKey.rawValue, forKey: AppConstants.LANGUAGE_KEY)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            print("English")
        case 3 :
            UserDefaults.standard.setValue(AppConstants.LanguageCode.gujaratiKey.rawValue, forKey: AppConstants.LANGUAGE_KEY)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            print("Gujarati")
        case 4 :
            UserDefaults.standard.setValue(AppConstants.LanguageCode.hindiKey.rawValue, forKey: AppConstants.LANGUAGE_KEY)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            print("Hindi")
        case 5 :
            UserDefaults.standard.setValue(AppConstants.LanguageCode.marathiKey.rawValue, forKey: AppConstants.LANGUAGE_KEY)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            print("Marathi")
        case 6:
            UserDefaults.standard.setValue(AppConstants.LanguageCode.tamilKey.rawValue, forKey: AppConstants.LANGUAGE_KEY)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            print("Tamil")
        case 7:
            UserDefaults.standard.setValue(AppConstants.LanguageCode.teluguKey.rawValue, forKey: AppConstants.LANGUAGE_KEY)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            print("Telugu")
        case 8:
            UserDefaults.standard.setValue(AppConstants.LanguageCode.urduKey.rawValue, forKey: AppConstants.LANGUAGE_KEY)
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            print("Urdu")
        default:
            return
        }
        UserDefaults.standard.synchronize()
        //updateLangaugeForView()
    }
    
    func loadAlertView(title: String, message: String, actions: [String], tag: [String]) {
        unloadAlertView()
        alertView = AvoxAlertView(title: title, message: message, actions: actions, tag: tag, target: self)
        alertView!.delegate = self
    }
    
    func unloadAlertView() {
        if alertView != nil {
            alertView!.removeFromSuperview()
            alertView = nil
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
    
    func clickOnPositiveButton(tag: String) {
        unloadAlertView()
        if tag == "yes" {
            //UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            //Thread.sleep(forTimeInterval: 0.2)
            //exit(0)
            loadSetLanguageKey(index: languageKey!)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "SplashViewController") as? SplashViewController
            self.navigationController!.setViewControllers([vc!], animated: true)
        }else if tag == "logoutYes" {
            avatarUrl = "Person"
            loadResetProfileView(name: "", email: "", image: "plus", avatar: avatarUrl, isRegistration: false)
        }
    }
    
    func clickOnNigativeButton(tag: String) {
        unloadAlertView()
        if tag == "no" {}
    }
    
    @objc func pressAuthentication() {
        if UserDefaults.standard.string(forKey: "nickName") == "" {
            authenticationView = AuthenticationUIView()
            authenticationView!.delegate = self
            authenticationView!.alpha = 0.0
            self.view.addSubview(authenticationView!)
            
            UIView.animate(withDuration: 0.3) {
                self.authenticationView!.alpha = 1.0
            }
        }else {
            loadAlertView(title: AppUtils.localizableString(key: LanguageConstant.logout), message: AppUtils.localizableString(key: LanguageConstant.logoutTitle), actions: [AppUtils.localizableString(key: LanguageConstant.yes), AppUtils.localizableString(key: LanguageConstant.no)], tag: ["logoutYes", "logoutNo"])
        }
    }
    
    func unloadAuthenticationView() {
        if authenticationView != nil {
            authenticationView!.removeFromSuperview()
            authenticationView!.delegate = nil
            authenticationView = nil
        }
    }
    
    //MARK: AuthenticationView Delegate Functions
    func cancelButtonPressed() {
        unloadAuthenticationView()
    }
    
    func termsServicesButtonPressed() {
        unloadAuthenticationView()
        let vc = TermServiceViewController(isAbout: false)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func sendOTPButtonPressed(name: String, email: String) {
        let otp = AppUtils.generateRandomNumber()
        print("Your OTP : \(otp)")
        //verificationParser = VerificationParser()
        //verificationParser!.delegate = self
        //verificationParser!.getOTPVerification(otp: otp, name: name, email: email)
    }
    
    func verifyButtonPressed(name: String, email: String) {
        unloadAuthenticationView()
        loadResetProfileView(name: name, email: email, image: "checkmark.seal", avatar: avatarUrl, isRegistration: true)
    }
    
    func didPressedAvatarImageView() {
        let vc = ChooseAvatarViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func didSelectAvatarUrlString(avatarUrl: String) {
        self.avatarUrl = avatarUrl
        authenticationView!.avatarTextField!.text = avatarUrl
    }
    
    func didRecievedOTP(status: Int, message: String) {
        if status == 111 {
            print(message)
        }else {
            print(message)
        }
    }
    
    func loadResetProfileView(name: String, email: String, image: String, avatar: String, isRegistration: Bool) {
        loadActivityIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.unloadActivityIndicator()
            UserDefaults.standard.set(name, forKey: "nickName")
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(avatar, forKey: "profile")
            UserDefaults.standard.set(isRegistration, forKey: AppConstants.IS_REGISTRATION)
            UserDefaults.standard.synchronize()
            self.accountImageView!.image = UIImage(named: avatar)
            self.nickNameLabel!.text = "\(AppUtils.localizableString(key: LanguageConstant.name)) : \(AppUtils.setNickName())"
            self.emailIdLabel!.text = "\(AppUtils.localizableString(key: LanguageConstant.email))  : \(AppUtils.setEmailID())"
            self.addAccountImage!.image = UIImage(systemName: image)
        }
    }
    
    @objc func loadImageStatusView() {
        imageStatusView = ImageStatusView()
        imageStatusView!.delegate = self
        self.view.addSubview(imageStatusView!)
    }
    
    func backButtonPress() {
        if imageStatusView != nil {
            imageStatusView!.removeFromSuperview()
            imageStatusView!.delegate = nil
            imageStatusView = nil
        }
    }
    
    @objc func didPressedPexelLogo() {
        //let url = URL(string: "https://www.pexels.com/about/")!
        //UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        let url = URL(string: "https://www.pexels.com/become-a-partner/")!
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    
    func updateLangaugeForView() {
        navigationBar?.topItem?.title = AppUtils.localizableString(key: LanguageConstant.settings)
        nickNameLabel!.text = "\(AppUtils.localizableString(key: LanguageConstant.name)) : \(AppUtils.setNickName())"
        emailIdLabel!.text = "\(AppUtils.localizableString(key: LanguageConstant.email))  : \(AppUtils.setEmailID())"
        generalLabel!.text = AppUtils.localizableString(key: LanguageConstant.general)
        descriptionLabel!.text = String(format: AppUtils.localizableString(key: LanguageConstant.appVersion), AppConstants.APP_VERSION)
        tableView!.reloadData()
    }
    
    func loadUserFeedback() {
        let alertController = UIAlertController(title: "We Value Your Feedback", message: "Please let us know your thoughts about \(AppConstants.NAME). Enter your feedback below:", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Your feedback here"
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            if let textField = alertController.textFields?.first,
               let feedback = textField.text, !feedback.isEmpty {
                print("User feedback: \(feedback)")
            } else {
                print("User did not enter any feedback")
            }
        }
        let laterAction = UIAlertAction(title: "Later", style: .destructive) { _ in
            print("Later button tapped")
        }
        alertController.addAction(submitAction)
        alertController.addAction(laterAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

//UserDefaults.standard.set(["ar-SA"], forKey: "AppleLanguages")
//UserDefaults.standard.synchronize()
//print("---> \(UserDefaults.standard.stringArray(forKey: "AppleLanguages") ?? ["-"])")
//UIView.appearance().setNeedsLayout()
//NSLocalizedString("\(LanguageConstant.general)", comment: "\(LanguageConstant.general)")
//guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {return}
//UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
