//
//  SetPasscodeViewController.swift
//  Avox
//
//  Created by Shaikh Shoeb on 26/09/24.
//

import UIKit

class SetPasscodeViewController: UIViewController {
    
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
    @IBOutlet weak var setPasscodeLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var oneTextField: UITextField!
    @IBOutlet weak var twoTextField: UITextField!
    @IBOutlet weak var threeTextField: UITextField!
    @IBOutlet weak var fourTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    
    var isComingFrom = false
    var passCode     = ""
    

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
        
        if isComingFrom {
            setPasscodeLabel.text = "Confirm Avox Passcode"
            discriptionLabel.text = "Please re-enter your new password to confirm. Ensure it matches the password above."
        }
    }

    @objc func numberDigitButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case -1:
            if !passCode.isEmpty {
                passCode.remove(at: passCode.index(before: passCode.endIndex))
            }
            
            if !fourTextField.text!.isEmpty {
                fourTextField.text = ""
            }else if !threeTextField.text!.isEmpty {
                threeTextField.text = ""
            }else if !twoTextField.text!.isEmpty {
                twoTextField.text = ""
            }else if !oneTextField.text!.isEmpty {
                oneTextField.text = ""
            }
        case -2:
            if isComingFrom && isPassCodeValidation() {
                if UserDefaults.standard.string(forKey: AppConstants.PASS_CODE) == passCode {
                    UserDefaults.standard.setValue(true, forKey: AppConstants.APP_LOCK)
                    self.navigationController?.popViewController(animated: true)
                }else {
                    showAlertMessage(message: "Mismatch passcode. Please try again.")
                }
            }else if isPassCodeValidation() {
                UserDefaults.standard.setValue(passCode, forKey: AppConstants.PASS_CODE)
                self.navigationController?.popViewController(animated: true)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SetPasscodeViewController") as? SetPasscodeViewController
                vc?.isComingFrom = true
                self.navigationController?.pushViewController(vc!, animated: true)
            }else {
                showAlertMessage(message: "Passcode must be 4 digits.")
            }
        default:
            if passCode.count != 4 {
                passCode = passCode + "\(sender.tag)"
            }
            
            if oneTextField.text!.isEmpty {
                oneTextField.text = "\(sender.tag)"
            }else if twoTextField.text!.isEmpty {
                twoTextField.text = "\(sender.tag)"
            }else if threeTextField.text!.isEmpty {
                threeTextField.text = "\(sender.tag)"
            }else if fourTextField.text!.isEmpty {
                fourTextField.text = "\(sender.tag)"
            }
            break
        }
    }
    
    //MARK: Fom Passcode Validation
    func isPassCodeValidation() -> Bool {
        if oneTextField.text!.isEmpty || twoTextField.text!.isEmpty || threeTextField.text!.isEmpty || fourTextField.text!.isEmpty {
            return false
        }
        return true
    }
    
    func showAlertMessage(message: String) {
        AppUtils.vibrateDevice()
        validationLabel!.text = message
        validationLabel!.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.validationLabel!.isHidden = true
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
