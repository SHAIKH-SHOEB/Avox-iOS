//
//  AuthenticationUIView.swift
//  Avox
//
//  Created by Nimap on 22/02/24.
//

import UIKit

protocol AuthenticationUIViewDelegate: NSObjectProtocol {
    func cancelButtonPressed()
    func didPressedAvatarImageView()
    func termsServicesButtonPressed()
    func sendOTPButtonPressed(name: String, email: String)
    func verifyButtonPressed(name: String, email: String)
}

class AuthenticationUIView: UIView, UITextFieldDelegate {
    
    var deviceManager        : DeviceManager?
    weak var delegate        : AuthenticationUIViewDelegate?
    
    var containerView        : UIView?
    var backButton           : UIButton?
    
    var stackView            : UIStackView?
    var titleLabel           : UILabel?
    var descriptionLabel     : UILabel?
    
    var userNameView         : UIView?
    var userNameTextField    : UITextField?
    
    var avatarView           : UIView?
    var avatarButton         : UIButton?
    var avatarTextField      : UITextField?
    
    var emailView            : UIView?
    var emailTextField       : UITextField?
    var emailButton          : UIButton?
    
    var otpView              : UIView?
    var otpTextField         : UITextField?
    var otpViewButton        : UIButton?
    
    var verifyButton         : UIButton?
    var termsConditions      : UILabel?
    var alertLabel           : UILabel?
    
    var fontSize             : CGFloat = 0.0
    var constant             : CGFloat = 0.0
    var containerHeight      : CGFloat = 0.0
    
    var timer                : Timer?
    var remainingTime        = 120

    init() {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loadBackButtonPressed)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        loadDeviceManager()
        loadContainerView()
        loadGetStartedView()
        loadSignInView()
        loadAlertMessage()
        loadTermsConditionsView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer?.invalidate()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // Handle keyboard show event
        //userNameTextField!.becomeFirstResponder()
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // Handle keyboard hide event
        //userNameTextField!.resignFirstResponder()
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
//        For Screensort Restrictions Method
//        let secureView = SecureField().secureContainer
//        secureView!.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(secureView!)
//        NSLayoutConstraint.activate([
//            secureView!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            secureView!.topAnchor.constraint(equalTo: self.topAnchor),
//            secureView!.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            secureView!.bottomAnchor.constraint(equalTo: self.bottomAnchor)
//        ])
        
        containerView = UIView()
        containerView!.translatesAutoresizingMaskIntoConstraints = false
        containerView!.backgroundColor = Helper.Color.bgPrimary
        AppUtils.applyBorderOnView(view: containerView!, radius: constant*2)
        containerView!.layer.masksToBounds = true
        containerView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        self.addSubview(containerView!)
        NSLayoutConstraint.activate([
            containerView!.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView!.heightAnchor.constraint(equalToConstant: containerHeight*5.3),
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
    }
    
    func loadGetStartedView() {
        titleLabel = UILabel()
        titleLabel!.text = AppUtils.localizableString(key: LanguageConstant.letGetStarted)
        titleLabel!.font = UIFont.appFontBold(ofSize: fontSize*1.5)
        titleLabel!.textAlignment = .left
        titleLabel!.textColor = Helper.Color.textPrimary
        stackView!.addArrangedSubview(titleLabel!)
        
        descriptionLabel = UILabel()
        descriptionLabel!.text = AppUtils.localizableString(key: LanguageConstant.loginFeature)
        descriptionLabel!.font = UIFont.appFontLight(ofSize: fontSize*0.8)
        descriptionLabel!.textColor = Helper.Color.textSecondary
        descriptionLabel!.textAlignment = NSTextAlignment.left
        descriptionLabel!.numberOfLines = 0
        stackView!.addArrangedSubview(descriptionLabel!)
    }
    
    func loadSignInView() {
        userNameView = UIView()
        AppUtils.applyBorderOnView(view: userNameView!, radius: constant)
        userNameView!.layer.masksToBounds = false
        stackView!.addArrangedSubview(userNameView!)
        
        userNameTextField = UITextField()
        userNameTextField!.translatesAutoresizingMaskIntoConstraints = false
        userNameTextField!.textColor = Helper.Color.textSecondary
        userNameTextField!.backgroundColor = UIColor.clear
        userNameTextField!.font = UIFont.appFontRegular(ofSize: fontSize)
        userNameTextField!.delegate = self
        userNameTextField!.keyboardType = .default
        userNameTextField!.autocapitalizationType = .words
        userNameTextField!.autocorrectionType = .no
        userNameTextField!.attributedPlaceholder = NSAttributedString(string: AppUtils.localizableString(key: LanguageConstant.nickName), attributes: [NSAttributedString.Key.font: UIFont.appFontRegular(ofSize: fontSize) as Any])
        userNameView!.addSubview(userNameTextField!)
        NSLayoutConstraint.activate([
            userNameTextField!.leadingAnchor.constraint(equalTo: userNameView!.leadingAnchor, constant: constant*1.5),
            userNameTextField!.topAnchor.constraint(equalTo: userNameView!.topAnchor, constant: constant),
            userNameTextField!.trailingAnchor.constraint(equalTo: userNameView!.trailingAnchor, constant: -constant*1.5),
            userNameTextField!.bottomAnchor.constraint(equalTo: userNameView!.bottomAnchor, constant: -constant),
        ])
        
        avatarView = UIView()
        AppUtils.applyBorderOnView(view: avatarView!, radius: constant)
        avatarView!.layer.masksToBounds = false
        stackView!.addArrangedSubview(avatarView!)
        
        avatarButton = UIButton(type: .system)
        avatarButton!.translatesAutoresizingMaskIntoConstraints = false
        avatarButton!.setImage(UIImage(systemName: "person.crop.circle.dashed"), for: .normal)
        avatarButton!.backgroundColor = UIColor.clear
        avatarButton!.tintColor = Helper.Color.appPrimary
        avatarButton!.isUserInteractionEnabled = true
        avatarButton!.addTarget(self, action: #selector(didPressedSetAvatar), for: .touchDown)
        avatarView!.addSubview(avatarButton!)
        NSLayoutConstraint.activate([
            avatarButton!.topAnchor.constraint(equalTo: avatarView!.topAnchor),
            avatarButton!.trailingAnchor.constraint(equalTo: avatarView!.trailingAnchor, constant: -constant),
            avatarButton!.bottomAnchor.constraint(equalTo: avatarView!.bottomAnchor),
            avatarButton!.widthAnchor.constraint(equalToConstant: containerHeight*0.5)
        ])
        
        avatarTextField = UITextField()
        avatarTextField!.translatesAutoresizingMaskIntoConstraints = false
        avatarTextField!.textColor = Helper.Color.textSecondary
        avatarTextField!.backgroundColor = UIColor.clear
        avatarTextField!.font = UIFont.appFontRegular(ofSize: fontSize)
        avatarTextField!.delegate = self
        avatarTextField!.keyboardType = .default
        avatarTextField!.autocapitalizationType = .words
        avatarTextField!.autocorrectionType = .no
        avatarTextField!.attributedPlaceholder = NSAttributedString(string: AppUtils.localizableString(key: LanguageConstant.setAvatar), attributes: [NSAttributedString.Key.font: UIFont.appFontRegular(ofSize: fontSize) as Any])
        //avatarTextField!.rightView =
        //avatarTextField!.rightViewMode =
        avatarView!.addSubview(avatarTextField!)
        NSLayoutConstraint.activate([
            avatarTextField!.leadingAnchor.constraint(equalTo: avatarView!.leadingAnchor, constant: constant*1.5),
            avatarTextField!.topAnchor.constraint(equalTo: avatarView!.topAnchor, constant: constant),
            avatarTextField!.trailingAnchor.constraint(equalTo: avatarButton!.leadingAnchor, constant: -constant*0.5),
            avatarTextField!.bottomAnchor.constraint(equalTo: avatarView!.bottomAnchor, constant: -constant),
        ])
        
        emailView = UIView()
        AppUtils.applyBorderOnView(view: emailView!, radius: constant)
        emailView!.layer.masksToBounds = false
        stackView!.addArrangedSubview(emailView!)
        
        emailButton = UIButton(type: .system)
        emailButton!.translatesAutoresizingMaskIntoConstraints = false
        emailButton!.setTitle(AppUtils.localizableString(key: LanguageConstant.sendOTP), for: .normal)
        emailButton!.titleLabel!.font = UIFont.appFontBold(ofSize: fontSize)
        emailButton!.backgroundColor = UIColor.clear
        emailButton!.setTitleColor(Helper.Color.appPrimary, for: .normal)
        emailButton!.addTarget(self, action: #selector(sendOTPButtonPressed), for: .touchDown)
        emailView!.addSubview(emailButton!)
        NSLayoutConstraint.activate([
            emailButton!.topAnchor.constraint(equalTo: emailView!.topAnchor),
            emailButton!.trailingAnchor.constraint(equalTo: emailView!.trailingAnchor, constant: -constant),
            emailButton!.bottomAnchor.constraint(equalTo: emailView!.bottomAnchor),
            emailButton!.widthAnchor.constraint(equalToConstant: containerHeight)
        ])
        
        emailTextField = UITextField()
        emailTextField!.translatesAutoresizingMaskIntoConstraints = false
        emailTextField!.textColor = Helper.Color.textSecondary
        emailTextField!.backgroundColor = UIColor.clear
        emailTextField!.font = UIFont.appFontRegular(ofSize: fontSize)
        emailTextField!.delegate = self
        emailTextField!.keyboardType = .emailAddress
        emailTextField!.autocapitalizationType = .none
        emailTextField!.autocorrectionType = .no
        emailTextField!.attributedPlaceholder = NSAttributedString(string: AppUtils.localizableString(key: LanguageConstant.email), attributes: [NSAttributedString.Key.font: UIFont.appFontRegular(ofSize: fontSize) as Any])
        emailView!.addSubview(emailTextField!)
        NSLayoutConstraint.activate([
            emailTextField!.leadingAnchor.constraint(equalTo: emailView!.leadingAnchor, constant: constant*1.5),
            emailTextField!.topAnchor.constraint(equalTo: emailView!.topAnchor, constant: constant),
            emailTextField!.trailingAnchor.constraint(equalTo: emailButton!.leadingAnchor, constant: -constant*0.5),
            emailTextField!.bottomAnchor.constraint(equalTo: emailView!.bottomAnchor, constant: -constant),
        ])
        
        otpView = UIView()
        AppUtils.applyBorderOnView(view: otpView!, radius: constant)
        otpView!.layer.masksToBounds = false
        stackView!.addArrangedSubview(otpView!)
        
        otpViewButton = UIButton(type: .system)
        otpViewButton!.translatesAutoresizingMaskIntoConstraints = false
        otpViewButton!.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        otpViewButton!.backgroundColor = UIColor.clear
        otpViewButton!.tintColor = Helper.Color.google
        otpViewButton!.addTarget(self, action: #selector(showHiddenButtonPressed), for: .touchDown)
        otpViewButton!.isUserInteractionEnabled = false
        otpView!.addSubview(otpViewButton!)
        NSLayoutConstraint.activate([
            otpViewButton!.topAnchor.constraint(equalTo: otpView!.topAnchor),
            otpViewButton!.trailingAnchor.constraint(equalTo: otpView!.trailingAnchor, constant: -constant),
            otpViewButton!.bottomAnchor.constraint(equalTo: otpView!.bottomAnchor),
            otpViewButton!.widthAnchor.constraint(equalToConstant: containerHeight*0.5)
        ])
        
        otpTextField = UITextField()
        otpTextField!.translatesAutoresizingMaskIntoConstraints = false
        otpTextField!.textColor = Helper.Color.textSecondary
        otpTextField!.backgroundColor = UIColor.clear
        otpTextField!.font = UIFont.appFontRegular(ofSize: fontSize)
        otpTextField!.delegate = self
        otpTextField!.keyboardType = .numberPad
        otpTextField!.isSecureTextEntry = true
        otpTextField!.isUserInteractionEnabled = false
        otpTextField!.attributedPlaceholder = NSAttributedString(string: AppUtils.localizableString(key: LanguageConstant.digitOTP), attributes: [NSAttributedString.Key.font: UIFont.appFontRegular(ofSize: fontSize) as Any])
        otpTextField!.inputAccessoryView = addToolBar(cancelSelector: #selector(cancelButtonTapped), doneSelector: #selector(doneButtonTapped))
        otpView!.addSubview(otpTextField!)
        NSLayoutConstraint.activate([
            otpTextField!.leadingAnchor.constraint(equalTo: otpView!.leadingAnchor, constant: constant*1.5),
            otpTextField!.topAnchor.constraint(equalTo: otpView!.topAnchor, constant: constant),
            otpTextField!.trailingAnchor.constraint(equalTo: otpViewButton!.leadingAnchor, constant: -constant*0.5),
            otpTextField!.bottomAnchor.constraint(equalTo: otpView!.bottomAnchor, constant: -constant),
        ])
    }
    
    func loadTermsConditionsView() {
        verifyButton = UIButton(type: .system)
        verifyButton!.setTitle(AppUtils.localizableString(key: LanguageConstant.verifyOTP), for: .normal)
        verifyButton!.titleLabel!.font = UIFont.appFontBold(ofSize: fontSize)
        verifyButton!.backgroundColor = Helper.Color.google
        verifyButton!.isEnabled = false
        verifyButton!.setTitleColor(Helper.Color.accent, for: .normal)
        verifyButton!.layer.cornerRadius = constant
        verifyButton!.addTarget(self, action: #selector(verifyButtonPressed), for: .touchDown)
        stackView!.addArrangedSubview(verifyButton!)
        
        termsConditions = UILabel()
        termsConditions!.text = AppUtils.localizableString(key: LanguageConstant.termAndServices)
        termsConditions!.isUserInteractionEnabled = true
        termsConditions!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loadTermsServicesButtonPressed)))
        termsConditions!.font = UIFont.appFontMedium(ofSize: fontSize)
        termsConditions!.textAlignment = .center
        termsConditions!.textColor = Helper.Color.textSecondary
        stackView!.addArrangedSubview(termsConditions!)
        
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
    
    @objc func loadBackButtonPressed() {
        if delegate != nil {
            delegate!.cancelButtonPressed()
        }
    }
    
    @objc func loadTermsServicesButtonPressed() {
        if delegate != nil {
            delegate!.termsServicesButtonPressed()
        }
    }
    
    @objc func sendOTPButtonPressed() {
        let message = isValidation()
        if message != "" {
            updateAlertMessage(message: message)
        }else {
            userNameTextField!.isUserInteractionEnabled = false
            emailTextField!.isUserInteractionEnabled = false
            emailButton!.isUserInteractionEnabled = false
            otpTextField!.isUserInteractionEnabled = true
            startTimer()
            if delegate != nil {
                delegate!.sendOTPButtonPressed(name: userNameTextField!.text!, email: emailTextField!.text!)
            }
        }
    }
    
    @objc func showHiddenButtonPressed() {
        otpTextField!.isSecureTextEntry.toggle()
        let image = otpTextField!.isSecureTextEntry ? "eye.slash" : "eye"
        otpViewButton!.setImage(UIImage(systemName: image), for: .normal)
    }
    
    func isValidation() -> String {
        var message = ""
        if userNameTextField!.text!.isEmpty {
            userNameView!.layer.borderColor = UIColor.systemRed.cgColor
            userNameView!.layer.borderWidth = 1
            message = AppUtils.localizableString(key: LanguageConstant.nickNameValidation)
            userNameTextField!.resignFirstResponder()
        }else if avatarTextField!.text!.isEmpty {
            avatarView!.layer.borderColor = UIColor.systemRed.cgColor
            avatarView!.layer.borderWidth = 1
            message = AppUtils.localizableString(key: LanguageConstant.avatarValidation)
        }else if emailTextField!.text!.isEmpty {
            emailView!.layer.borderColor = UIColor.systemRed.cgColor
            emailView!.layer.borderWidth = 1
            message = AppUtils.localizableString(key: LanguageConstant.emailValidation)
            emailTextField!.resignFirstResponder()
        }else if !emailTextField!.text!.isValidateEmailId() {
            emailView!.layer.borderColor = UIColor.systemRed.cgColor
            emailView!.layer.borderWidth = 1
            message = AppUtils.localizableString(key: LanguageConstant.validEmailValidation)
            emailTextField!.resignFirstResponder()
        }
        return message
    }
    
    @objc func verifyButtonPressed() {
        if otpTextField!.text! == UserDefaults.standard.string(forKey: "OTP") {
            if delegate != nil {
                delegate!.verifyButtonPressed(name: userNameTextField!.text!, email: emailTextField!.text!)
            }
        }else {
            updateAlertMessage(message: AppUtils.localizableString(key: LanguageConstant.otpValidation))
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userNameTextField {
            AppUtils.applyBorderOnView(view: userNameView!, radius: constant)
        }
        if textField == avatarTextField {
            AppUtils.applyBorderOnView(view: avatarView!, radius: constant)
        }
        if textField == emailTextField {
            AppUtils.applyBorderOnView(view: emailView!, radius: constant)
        }
        if textField == otpTextField {
            otpViewButton!.tintColor = Helper.Color.appPrimary
            otpViewButton!.isUserInteractionEnabled = true
        }
        if textField == avatarTextField {
            avatarTextField!.resignFirstResponder()
            if delegate != nil {
                delegate!.didPressedAvatarImageView()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == otpTextField {
            // Get the new text after the replacement
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            if newText.count <= 6 && allowedCharacters.isSuperset(of: characterSet) {
                textField.text = newText
                if newText.count >= 6 {
                    verifyButton!.backgroundColor = Helper.Color.appPrimary
                    verifyButton!.isEnabled = true
                } else {
                    verifyButton!.backgroundColor = Helper.Color.google
                    verifyButton!.isEnabled = false
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
        otpTextField!.resignFirstResponder()
    }
    
    @objc func cancelButtonTapped() {
        if otpTextField!.text != "" {
            otpTextField!.text = ""
        }
        otpTextField!.resignFirstResponder()
    }
    
    func loadAlertMessage() {
        alertLabel = UILabel()
        alertLabel!.translatesAutoresizingMaskIntoConstraints = false
        alertLabel!.text = ""
        alertLabel!.textColor = UIColor.systemRed
        alertLabel!.textAlignment = .left
        alertLabel!.font = UIFont.appFontRegular(ofSize: fontSize*0.8)
        alertLabel!.isHidden = true
        stackView!.addArrangedSubview(alertLabel!)
    }
    
    func updateAlertMessage(message: String) {
        alertLabel!.text = message
        alertLabel!.isHidden = false
        alertLabel!.textAlignment = .left
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.alertLabel!.isHidden = true
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            let minutes = remainingTime / 60
            let seconds = remainingTime % 60
            UIView.performWithoutAnimation {
                emailButton!.setTitle(String(format: "%02d:%02d", minutes, seconds), for: .normal)
                emailButton!.layoutIfNeeded()
            }
        } else {
            emailButton!.setTitle(AppUtils.localizableString(key: LanguageConstant.sendOTP), for: .normal)
            emailButton!.isUserInteractionEnabled = true
            timer!.invalidate()
        }
    }
    
    @objc func didPressedSetAvatar() {
        if delegate != nil {
            delegate!.didPressedAvatarImageView()
        }
    }
}

class SecureField : UITextField {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.isSecureTextEntry = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var secureContainer: UIView? {
        let secureView = self.subviews.filter({ subview in type(of: subview).description().contains("CanvasView")}).first
        secureView?.translatesAutoresizingMaskIntoConstraints = false
        secureView?.isUserInteractionEnabled = true
        return secureView
    }
    
    override var canBecomeFirstResponder: Bool {
        false
    }
    
    override func becomeFirstResponder() -> Bool {
        false
    }
}
//emailTextField.hasText
