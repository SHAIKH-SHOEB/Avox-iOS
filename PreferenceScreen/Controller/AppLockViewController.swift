//
//  AppLockViewController.swift
//  Avox
//
//  Created by Shaikh Shoeb on 25/09/24.
//

import UIKit
import LocalAuthentication

class AppLockViewController: UIViewController {
    
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var oneImageView: UIImageView!
    @IBOutlet weak var twoImageView: UIImageView!
    @IBOutlet weak var threeImageView: UIImageView!
    @IBOutlet weak var fourImageView: UIImageView!
    @IBOutlet weak var validationLabel: UILabel!

    var passCode = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadBaseView()
    }
    
    func loadBaseView() {
        oneButton.addTarget(self, action: #selector(numberDigitButtonPressed(_:)), for: .touchUpInside)
        oneButton.tag = 1
        
        twoButton.addTarget(self, action: #selector(numberDigitButtonPressed(_:)), for: .touchUpInside)
        twoButton.tag = 2
        
        threeButton.addTarget(self, action: #selector(numberDigitButtonPressed(_:)), for: .touchUpInside)
        threeButton.tag = 3
        
        fourButton.addTarget(self, action: #selector(numberDigitButtonPressed(_:)), for: .touchUpInside)
        fourButton.tag = 4
        
        fiveButton.addTarget(self, action: #selector(numberDigitButtonPressed(_:)), for: .touchUpInside)
        fiveButton.tag = 5
        
        sixButton.addTarget(self, action: #selector(numberDigitButtonPressed(_:)), for: .touchUpInside)
        sixButton.tag = 6
        
        sevenButton.addTarget(self, action: #selector(numberDigitButtonPressed(_:)), for: .touchUpInside)
        sevenButton.tag = 7
        
        eightButton.addTarget(self, action: #selector(numberDigitButtonPressed(_:)), for: .touchUpInside)
        eightButton.tag = 8
        
        nineButton.addTarget(self, action: #selector(numberDigitButtonPressed(_:)), for: .touchUpInside)
        nineButton.tag = 9
        
        zeroButton.addTarget(self, action: #selector(numberDigitButtonPressed(_:)), for: .touchUpInside)
        zeroButton.tag = 0
        
        cancelButton.addTarget(self, action: #selector(numberDigitButtonPressed(_:)), for: .touchUpInside)
        cancelButton.tag = -1
        
        okButton.addTarget(self, action: #selector(numberDigitButtonPressed(_:)), for: .touchUpInside)
        okButton.tag = -2
        
    }
    
    @objc func numberDigitButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case -1:
            if !passCode.isEmpty {
                passCode.remove(at: passCode.index(before: passCode.endIndex))
            }
            
            if passCode.count == 3 {
                fourImageView.image = UIImage(systemName: "circle")
            }else if passCode.count == 2 {
                threeImageView.image = UIImage(systemName: "circle")
            }else if passCode.count == 1 {
                twoImageView.image = UIImage(systemName: "circle")
            }else if passCode.count == 0 {
                oneImageView.image = UIImage(systemName: "circle")
            }
        case -2:
            if Helper.isPassCode == Int(passCode) {
                let viewController = UIApplication.isConnectedToNetwork() ? HomeViewController() : NoConnectionViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }else {
                showAlertMessage(message: "Please enter a valid 4-digit passcode or used faceId")
            }
        default:
            if passCode.count != 4 {
                passCode = passCode + "\(sender.tag)"
            }
            
            if passCode.count == 1 {
                oneImageView.image = UIImage(systemName: "circle.fill")
            }else if passCode.count == 2 {
                twoImageView.image = UIImage(systemName: "circle.fill")
            }else if passCode.count == 3 {
                threeImageView.image = UIImage(systemName: "circle.fill")
            }else if passCode.count == 4 {
                fourImageView.image = UIImage(systemName: "circle.fill")
            }
            break
        }
    }
    
    func showAlertMessage(message: String) {
        AppUtils.vibrateDevice()
        validationLabel!.text = message
        validationLabel!.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.validationLabel!.isHidden = true
        }
    }
    
    @IBAction func faceIDButtonPressed(_ sender: Any) {
        let authContext = LAContext ()
        var error : NSError?
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Is It You"){ (success, error) in
                if success == true {
                    DispatchQueue.main.async {
                        let viewController = UIApplication.isConnectedToNetwork() ? HomeViewController() : NoConnectionViewController()
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }else {
                    DispatchQueue.main.async {
                        self.showAlertMessage(message: "Please enter a valid 4-digit passcode or used faceId")
                    }
                }
            }
        }
    }
}
