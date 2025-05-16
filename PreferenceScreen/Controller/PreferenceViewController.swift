//
//  PreferenceSettingViewController.swift
//  Avox
//
//  Created by Shaikh Shoeb on 22/09/24.
//

import UIKit

class PreferenceViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var lockSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var whatsView: UIView!
    @IBOutlet weak var whatsHeaderLabel: UILabel!
    @IBOutlet weak var whatsTitleLabel: UILabel!
    @IBOutlet weak var whatsValueLabel: UILabel!
    @IBOutlet weak var changeView: UIView!
    @IBOutlet weak var changeIconView: UIView!
    @IBOutlet weak var changeIconButton: UIButton!
    
    var deviceManager       : DeviceManager?
    var fontSize            : CGFloat = 0.0
    var constant            : CGFloat = 0.0
    var toggleButton        : UIButton?
    var isExpanded          = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadDeviceManager()
        loadNavigationBar()
        loadBaseView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lockSwitch.isOn = Helper.isAppLock
        changeButton.tintColor = Helper.isAppLock ? Helper.Color.appPrimary : Helper.Color.appPrimary?.withAlphaComponent(0.5)
        changeButton.isUserInteractionEnabled = Helper.isAppLock
    }
    
    func loadDeviceManager() {
        deviceManager = DeviceManager.instance
        if deviceManager!.deviceType == deviceManager!.iPhone5 || deviceManager!.deviceType == deviceManager!.iPhone6 {
            fontSize = Helper.DeviceManager.IPHONE_5_6_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_5_6_CONSTANT
        }else if deviceManager!.deviceType == deviceManager!.iPhone6plus || deviceManager!.deviceType == deviceManager!.iPhoneX {
            fontSize = Helper.DeviceManager.IPHONE_6PLUS_X_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_6PLUS_X_CONSTANT
        }else if deviceManager!.deviceType == deviceManager!.iphone12Family || deviceManager!.deviceType == deviceManager!.iphoneProMax {
            fontSize = Helper.DeviceManager.IPHONE_12FAMILY_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_12FAMILY_CONSTANT
        }else if deviceManager!.deviceType == deviceManager!.iPhone {
            fontSize = Helper.DeviceManager.IPHONE_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_CONSTANT
        }
    }

    func loadNavigationBar() {
        let navigationItem = UINavigationItem()
        navigationItem.title = AppUtils.localizableString(key: LanguageConstant.preference)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backButtonPressed))
        if Helper.isRegistration {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar.badge.plus"), style: .plain, target: self, action: #selector(calenderButtonPressed))
        }
        navigationBar.items = [navigationItem]
        navigationBar.barTintColor = Helper.Color.bgPrimary
        navigationBar.tintColor = Helper.Color.appPrimary
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar.prefersLargeTitles = true
        let largeTitleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.appFontBold(ofSize: fontSize*1.8) as Any, .foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar!.largeTitleTextAttributes = largeTitleAttributes
    }
    
    func loadBaseView() {
        headerLabel.text = AppUtils.localizableString(key: LanguageConstant.enableLock)
        headerLabel.font = UIFont.appFontBold(ofSize: fontSize*1.2)
        
        titleLabel.text = AppUtils.localizableString(key: LanguageConstant.applicationLockTitle)
        titleLabel.font = UIFont.appFontMedium(ofSize: fontSize)
        
        valueLabel.text = AppUtils.localizableString(key: LanguageConstant.applicationLockValue)
        valueLabel.font = UIFont.appFontRegular(ofSize: fontSize*0.8)
        
        changeButton.setTitle(AppUtils.localizableString(key: LanguageConstant.changePassCode), for: UIControl.State.normal)
        changeButton.titleLabel?.font = UIFont.appFontMedium(ofSize: fontSize)
        changeButton.isUserInteractionEnabled = Helper.isAppLock
        changeButton.tintColor = Helper.isAppLock ? Helper.Color.appPrimary : Helper.Color.appPrimary?.withAlphaComponent(0.5)
        
        changeIconButton.setTitle(AppUtils.localizableString(key: "Change App Icon"), for: UIControl.State.normal)
        changeIconButton.titleLabel?.font = UIFont.appFontMedium(ofSize: fontSize)
        changeIconButton.isEnabled = AppConstants.isAvoxBuild()
        
        lockSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        lockSwitch.isOn = Helper.isAppLock
        
        whatsHeaderLabel.text = AppUtils.localizableString(key: LanguageConstant.whatsNew)
        whatsHeaderLabel.font = UIFont.appFontBold(ofSize: fontSize*1.2)
        
        whatsTitleLabel.text = String(format: AppUtils.localizableString(key: LanguageConstant.applicationVersion), AppConstants.APP_VERSION)
        whatsTitleLabel.font = UIFont.appFontMedium(ofSize: fontSize)
        
        whatsValueLabel.text = AppUtils.localizableString(key: LanguageConstant.whatsNewTitle)
        whatsValueLabel.font = UIFont.appFontRegular(ofSize: fontSize*0.8)
        whatsValueLabel.numberOfLines = isExpanded ? 0 : 2
        
        AppUtils.applyBorderOnView(view: whatsView, radius: constant)
        AppUtils.applyBorderOnView(view: baseView, radius: constant)
        AppUtils.applyBorderOnView(view: changeView, radius: constant)
        AppUtils.applyBorderOnView(view: changeIconView, radius: constant)
        
        toggleButton = UIButton()
        toggleButton!.setTitle(AppUtils.localizableString(key: LanguageConstant.readMore), for: .normal)
        toggleButton!.setTitleColor(Helper.Color.appPrimary, for: .normal)
        toggleButton!.titleLabel?.font = UIFont.appFontMedium(ofSize: fontSize*0.8)
        toggleButton!.addTarget(self, action: #selector(toggleText), for: .touchUpInside)
        toggleButton!.translatesAutoresizingMaskIntoConstraints = false
        whatsView!.addSubview(toggleButton!)
        NSLayoutConstraint.activate([
            toggleButton!.topAnchor.constraint(equalTo: whatsView.topAnchor, constant: 5),
            toggleButton!.trailingAnchor.constraint(equalTo: whatsView.trailingAnchor, constant: -15)
        ])
    }
   
    @objc private func toggleText() {
        isExpanded.toggle()
        whatsValueLabel.numberOfLines = isExpanded ? 0 : 2
        toggleButton!.setTitle(isExpanded ? AppUtils.localizableString(key: LanguageConstant.readLess) : AppUtils.localizableString(key: LanguageConstant.readMore), for: .normal)
        whatsValueLabel.layoutIfNeeded()
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SetPasscodeViewController") as? SetPasscodeViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }else {
            changeButton.isUserInteractionEnabled = false
            changeButton.tintColor = Helper.Color.appPrimary?.withAlphaComponent(0.5)
            lockSwitch.isOn = false
            UserDefaults.standard.setValue(false, forKey: AppConstants.APP_LOCK)
            UserDefaults.standard.setValue("", forKey: AppConstants.PASS_CODE)
            UserDefaults.standard.synchronize()
        }
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func calenderButtonPressed() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func didPressedChangePasscodeButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SetPasscodeViewController") as? SetPasscodeViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func didPressedChangeIconButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChangeIconViewController") as? ChangeIconViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        // Change the title based on the scroll position with animation
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            if yOffset > 100 { // Adjust the threshold as needed
                self.navigationBar?.topItem?.largeTitleDisplayMode = .never
            } else {
                self.navigationBar?.topItem?.largeTitleDisplayMode = .always
            }
        }
    }
}
