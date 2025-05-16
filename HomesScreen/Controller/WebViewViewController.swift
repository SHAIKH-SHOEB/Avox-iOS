//
//  WebViewViewController.swift
//  Avox
//
//  Created by Nimap on 28/01/24.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController & WKNavigationDelegate {
    
    var navigationBar     : UINavigationBar?
    var wkWebView         : WKWebView?
    var activityIndicator : AvoxAlertView?
    var urlString         : String? = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Helper.Color.bgPrimary
        loadNavigationBar()
        loadWebView()
        loadActivityIndicator()
        self.wkWebView!.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
    }
    
    func loadNavigationBar() {
        navigationBar = UINavigationBar()
        navigationBar!.translatesAutoresizingMaskIntoConstraints = false
        let navigationItem = UINavigationItem()
        navigationItem.title = AppUtils.localizableString(key: LanguageConstant.profileView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backButtonPressed))
        navigationBar!.items = [navigationItem]
        navigationBar!.barTintColor = Helper.Color.bgPrimary
        navigationBar!.tintColor = Helper.Color.appPrimary
        navigationBar!.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar!.prefersLargeTitles = true
        let largeTitleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.appFontBold(ofSize: 27.0) as Any, .foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar!.largeTitleTextAttributes = largeTitleAttributes
        self.view.addSubview(navigationBar!)
        NSLayoutConstraint.activate([
            navigationBar!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            navigationBar!.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func loadWebView() {
        wkWebView = WKWebView()
        wkWebView!.translatesAutoresizingMaskIntoConstraints = false
        wkWebView!.navigationDelegate = self
        self.view.addSubview(wkWebView!)
        NSLayoutConstraint.activate([
            wkWebView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            wkWebView!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor, constant: 8),
            wkWebView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            wkWebView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8)
        ])
        
        if let url = URL(string: urlString!) {
            let request = URLRequest(url: url)
            wkWebView!.load(request)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            if wkWebView!.isLoading {
                loadActivityIndicator()
            } else {
                unloadActivityIndicator()
            }
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
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}
