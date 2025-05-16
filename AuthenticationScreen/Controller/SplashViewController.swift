//
//  SplashViewController.swift
//  Avox
//
//  Created by Shaikh Shoeb on 12/07/24.
//

import UIKit
import AVFoundation

class SplashViewController: UIViewController {
    
    @IBOutlet weak var appLogoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().isTranslucent = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.navigateSplashIntoHomeScreen()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func navigateSplashIntoHomeScreen() {
        if !UserDefaults.standard.bool(forKey: "onBoarding") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OnBoardingViewController") as? OnBoardingViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        } else if Helper.isAppLock {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AppLockViewController") as? AppLockViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        } else if UIApplication.isConnectedToNetwork() {
            print("Connected to the internet")
            let viewController = HomeViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            print("No internet connection")
            let viewController = NoConnectionViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

class TextToSpeechManager {
    private let speechSynthesizer = AVSpeechSynthesizer()

    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Set the language
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate // Set the speech rate
                
        // Adjust the pitch for a softer tone
        //utterance.pitchMultiplier = 1.2 // Slightly higher pitch for warmth
        //speechSynthesizer.delegate = self
        speechSynthesizer.speak(utterance)
    }
}
