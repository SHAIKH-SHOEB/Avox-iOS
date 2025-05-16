//
//  NavigationBarView.swift
//  Avox
//
//  Created by Shaikh Shoeb on 15/08/24.
//

import UIKit

@objc protocol NavigationBarViewDelegate: NSObjectProtocol {
    @objc optional func leadingButtonPressed()
    @objc optional func leadingMiddleButtonPressed()
    @objc optional func trailingButtonPressed()
    @objc optional func middleButtonPressed()
    @objc optional func locationButtonPressed()
}

class NavigationBarView: UIView {
    
    var target               : UIViewController?
    var delegate             : NavigationBarViewDelegate?
    
    var leadingButton        : UIButton?
    var titleLabel           : UILabel?
    var subTitleLabel        : UILabel?
    
    var titleStackView       : UIStackView?
    var titleButton          : UIButton?
    
    var buttonStackView      : UIStackView?
    var leadingMiddleButton  : UIButton?
    var middleButton         : UIButton?
    var trailingButton       : UIButton?
    
    var title                : String?
    var location             : String?
    
    
    init(target: UIViewController? = nil, delegate: NavigationBarViewDelegate? = nil, title: String? = nil) {
        super.init(frame: .zero)
        self.target = target
        self.delegate = delegate
        self.title = title
        loadNavigationView()
        loadButtonViews()
        loadBaseView()
    }
    
    init(target: UIViewController? = nil, delegate: NavigationBarViewDelegate? = nil){
        super.init(frame: .zero)
        self.target = target
        self.delegate = delegate
        loadNavigationView()
        loadButtonViews()
        loadHomeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadNavigationView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = Helper.Color.bgPrimary
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
        target!.view.addSubview(self)
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: target!.view.leadingAnchor),
            self.topAnchor.constraint(equalTo: target!.view.topAnchor),
            self.trailingAnchor.constraint(equalTo: target!.view.trailingAnchor),
            self.heightAnchor.constraint(equalToConstant: ((self.target?.isNotch) != nil) ? 100 : 60)
        ])
    }
    
    func loadHomeView() {
        leadingButton = UIButton(type: .system)
        leadingButton!.translatesAutoresizingMaskIntoConstraints = false
        leadingButton!.setImage(UIImage(systemName: "person.fill"), for: .normal)
        leadingButton!.tintColor = Helper.Color.appPrimary
        leadingButton!.backgroundColor = UIColor.clear
        leadingButton!.layer.borderColor = Helper.Color.appPrimary?.cgColor
        leadingButton!.layer.borderWidth = 1
        leadingButton!.layer.cornerRadius = 10
        leadingButton!.isUserInteractionEnabled = true
        leadingButton!.addTarget(self, action: #selector(leadingButtonPressed), for: UIControl.Event.touchDown)
        self.addSubview(leadingButton!)
        NSLayoutConstraint.activate([
            leadingButton!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15.0),
            leadingButton!.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10.0),
            leadingButton!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0),
            leadingButton!.widthAnchor.constraint(equalToConstant: 36.0)
        ])
        
        titleStackView = UIStackView()
        titleStackView!.translatesAutoresizingMaskIntoConstraints = false
        titleStackView!.backgroundColor = UIColor.clear
        titleStackView!.axis = NSLayoutConstraint.Axis.vertical
        titleStackView!.spacing = 0
        titleStackView!.distribution = UIStackView.Distribution.fillProportionally
        titleStackView!.alignment = UIStackView.Alignment.leading
        self.addSubview(titleStackView!)
        NSLayoutConstraint.activate([
            titleStackView!.centerYAnchor.constraint(equalTo: leadingButton!.centerYAnchor),
            titleStackView!.leadingAnchor.constraint(equalTo: leadingButton!.trailingAnchor, constant: 10.0)
        ])
        
        titleLabel = UILabel()
        titleLabel!.translatesAutoresizingMaskIntoConstraints = false
        titleLabel!.text = title
        titleLabel!.font = UIFont.appFontBold(ofSize: 17.0)
        titleLabel!.textColor = Helper.Color.textPrimary
        titleLabel!.textAlignment = NSTextAlignment.left
        titleStackView!.addArrangedSubview(titleLabel!)
    }
    
    func loadBaseView() {
        leadingButton = UIButton(type: .system)
        leadingButton!.translatesAutoresizingMaskIntoConstraints = false
        leadingButton!.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        leadingButton!.tintColor = Helper.Color.appPrimary
        leadingButton!.backgroundColor = UIColor.clear
        leadingButton!.isUserInteractionEnabled = true
        leadingButton!.addTarget(self, action: #selector(leadingButtonPressed), for: UIControl.Event.touchDown)
        self.addSubview(leadingButton!)
        NSLayoutConstraint.activate([
            leadingButton!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15.0),
            leadingButton!.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 4.0),
            leadingButton!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4.0)
        ])
        
        titleStackView = UIStackView()
        titleStackView!.translatesAutoresizingMaskIntoConstraints = false
        titleStackView!.backgroundColor = UIColor.clear
        titleStackView!.axis = NSLayoutConstraint.Axis.vertical
        titleStackView!.spacing = 0
        titleStackView!.distribution = UIStackView.Distribution.fillProportionally
        titleStackView!.alignment = UIStackView.Alignment.leading
        self.addSubview(titleStackView!)
        NSLayoutConstraint.activate([
            titleStackView!.centerYAnchor.constraint(equalTo: leadingButton!.centerYAnchor),
            titleStackView!.leadingAnchor.constraint(equalTo: leadingButton!.trailingAnchor, constant: 10.0)
        ])
        
        titleLabel = UILabel()
        titleLabel!.translatesAutoresizingMaskIntoConstraints = false
        titleLabel!.text = title
        titleLabel!.font = UIFont.appFontBold(ofSize: 18.0)
        titleLabel!.textColor = Helper.Color.textPrimary
        titleLabel!.textAlignment = NSTextAlignment.left
        titleStackView!.addArrangedSubview(titleLabel!)
    }
    
    func loadSubTitleView(subTitle: String) {
        subTitleLabel = UILabel()
        subTitleLabel!.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel!.text = subTitle
        subTitleLabel!.font = UIFont.appFontLight(ofSize: 12.0)
        subTitleLabel!.textColor = Helper.Color.appPrimary
        subTitleLabel!.textAlignment = NSTextAlignment.left
        titleStackView!.addArrangedSubview(subTitleLabel!)
//        self.addSubview(subTitleLabel!)
//        NSLayoutConstraint.activate([
//            subTitleLabel!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2.0),
//            subTitleLabel!.leadingAnchor.constraint(equalTo: leadingButton!.trailingAnchor, constant: 10.0)
//        ])
    }
    
    func updateLocationView(location: String) {
        titleLabel!.text = location
    }
    
    func loadButtonViews() {
        buttonStackView = UIStackView()
        buttonStackView!.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView!.backgroundColor = UIColor.clear
        buttonStackView!.axis = .horizontal
        buttonStackView!.spacing = 16
        buttonStackView!.distribution = .fillProportionally
        self.addSubview(buttonStackView!)
        NSLayoutConstraint.activate([
            buttonStackView!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
            buttonStackView!.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 4.0),
            buttonStackView!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4.0)
        ])
    }
    
    func loadTrailingButton(title: String) {
        trailingButton = UIButton(type: .system)
        trailingButton!.setImage(UIImage(systemName: title), for: .normal)
        trailingButton!.tintColor = Helper.Color.appPrimary
        trailingButton!.backgroundColor = UIColor.clear
        trailingButton!.isUserInteractionEnabled = true
        trailingButton!.addTarget(self, action: #selector(trailingButtonPressed), for: UIControl.Event.touchDown)
        buttonStackView!.addArrangedSubview(trailingButton!)
    }
    
    func loadMiddleButton(title: String) {
        middleButton = UIButton(type: .system)
        middleButton!.setImage(UIImage(systemName: title), for: .normal)
        middleButton!.tintColor = Helper.Color.appPrimary
        middleButton!.backgroundColor = UIColor.clear
        middleButton!.isUserInteractionEnabled = true
        middleButton!.addTarget(self, action: #selector(middleButtonPressed), for: UIControl.Event.touchDown)
        buttonStackView!.addArrangedSubview(middleButton!)
    }
    
    func loadLeadingMiddleButton(title: String) {
        leadingMiddleButton = UIButton(type: .system)
        leadingMiddleButton!.setImage(UIImage(systemName: title), for: .normal)
        leadingMiddleButton!.tintColor = Helper.Color.appPrimary
        leadingMiddleButton!.backgroundColor = UIColor.clear
        leadingMiddleButton!.isUserInteractionEnabled = true
        leadingMiddleButton!.addTarget(self, action: #selector(leadingMiddleButtonPressed), for: UIControl.Event.touchDown)
        buttonStackView!.addArrangedSubview(leadingMiddleButton!)
    }
    
    @objc func leadingButtonPressed() {
        if delegate != nil {
            delegate!.leadingButtonPressed?()
        }
    }
    
    @objc func trailingButtonPressed() {
        if delegate != nil {
            delegate!.trailingButtonPressed?()
        }
    }
    
    @objc func middleButtonPressed() {
        if delegate != nil {
            delegate!.middleButtonPressed?()
        }
    }
    
    @objc func leadingMiddleButtonPressed() {
        if delegate != nil {
            delegate!.leadingMiddleButtonPressed?()
        }
    }
    
    @objc func locationButtonPressed() {
        if delegate != nil {
            delegate!.locationButtonPressed?()
        }
    }
}
