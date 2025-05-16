//
//  ImageStatusView.swift
//  Avox
//
//  Created by Shaikh Shoeb on 10/04/24.
//

import UIKit

protocol ImageStatusViewDelegate: NSObjectProtocol {
    func backButtonPress()
}

class ImageStatusView: UIView {
    
    var deviceManager    : DeviceManager?
    weak var delegate    : ImageStatusViewDelegate?

    var imageView        : UIImageView?
    var backButton       : UIButton?
    
    var progressView     : UIProgressView!
    var timer            : Timer?
    
    var progress         : Float = 0.0
    let duration         : Float = 10.0 //Duration in seconds
    
    var fontSize         : CGFloat = 0.0
    var constant         : CGFloat = 0.0
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = Helper.Color.apple
        loadDeviceManager()
        loadImageView()
        loadProgressView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func loadImageView() {
        imageView = UIImageView()
        imageView!.translatesAutoresizingMaskIntoConstraints = false
        imageView!.downloadImage(from: URL(string: "https://images.pexels.com/photos/27978911/pexels-photo-27978911.jpeg")!, placeholder: UIImage(named: "Placeholder"))
        //imageView!.contentMode = UIView.ContentMode.center
        imageView!.isUserInteractionEnabled = true
        imageView!.layer.cornerRadius = constant*2
        imageView!.layer.masksToBounds = true
        imageView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loadBackButtonPressed)))
        self.addSubview(imageView!)
        NSLayoutConstraint.activate([
            imageView!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView!.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            imageView!.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView!.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func loadProgressView() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView!.translatesAutoresizingMaskIntoConstraints = false
        //progressView!.tintColor = UIColor.systemGreen
        progressView!.trackTintColor = UIColor.systemGray
        progressView!.progressTintColor = Helper.Color.appPrimary
        imageView!.addSubview(progressView!)
        NSLayoutConstraint.activate([
            progressView!.leadingAnchor.constraint(equalTo: imageView!.leadingAnchor, constant: constant*0.5),
            progressView!.topAnchor.constraint(equalTo: imageView!.topAnchor, constant: constant*0.5),
            progressView!.trailingAnchor.constraint(equalTo: imageView!.trailingAnchor, constant: -constant*0.5),
            progressView!.heightAnchor.constraint(equalToConstant: 3.0)
        ])
        
        backButton = UIButton(type: .system)
        backButton!.translatesAutoresizingMaskIntoConstraints = false
        backButton!.backgroundColor = UIColor.clear
        backButton!.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton!.tintColor = Helper.Color.appPrimary
        backButton!.addTarget(self, action: #selector(loadBackButtonPressed), for: .touchUpInside)
        imageView!.addSubview(backButton!)
        NSLayoutConstraint.activate([
            backButton!.topAnchor.constraint(equalTo: progressView!.bottomAnchor, constant: constant*2),
            backButton!.trailingAnchor.constraint(equalTo: imageView!.trailingAnchor, constant: -constant*2)
        ])
        
        // Start updating progress
        let timeInterval = duration / (1.0 / 0.01) // 0.01 is the progress increment per step
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgress() {
        progress += 0.01
        progressView.setProgress(progress, animated: true)
        
        // Once progress reaches 1.0, stop the timer
        if progress >= 1.0 {
            timer?.invalidate()
            timer = nil
            if delegate != nil {
                delegate!.backButtonPress()
            }
        }
    }

    @objc func loadBackButtonPressed() {
        if delegate != nil {
            delegate!.backButtonPress()
        }
    }
}
