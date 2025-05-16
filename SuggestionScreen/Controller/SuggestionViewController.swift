//
//  SuggestionViewController.swift
//  Avox
//
//  Created by Nimap on 03/03/24.
//

import UIKit

class SuggestionViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var deviceManager       : DeviceManager?
    var navigationBar       : UINavigationBar?
    var tableView           : UITableView?
    
    var suggestionModel     : [SuggestionProvider]?
    
    var fontSize            : CGFloat = 0.0
    var constant            : CGFloat = 0.0
    var cellHeight          : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Helper.Color.bgPrimary
        UINavigationBar.appearance().isTranslucent = false
        suggestionModel = SuggestionProvider.getSuggestionProvider()
        loadDeviceManager()
        loadPage()
    }
    
    func loadPage() {
        loadNavigationBar()
        loadTableView()
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
    
    func loadNavigationBar() {
        navigationBar = UINavigationBar()
        navigationBar!.translatesAutoresizingMaskIntoConstraints = false
        let navigationItem = UINavigationItem()
        navigationItem.title = AppUtils.localizableString(key: LanguageConstant.suggestion)
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
    
    func loadTableView() {
        tableView = UITableView()
        tableView!.translatesAutoresizingMaskIntoConstraints = false
        tableView!.backgroundColor = UIColor.clear
        tableView!.register(UINib(nibName: "SuggestionTableViewCell", bundle: nil), forCellReuseIdentifier: "SuggestionTableViewCell")
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.showsVerticalScrollIndicator = false
        tableView!.separatorStyle = .none
        self.view.addSubview(tableView!)
        NSLayoutConstraint.activate([
            tableView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: constant*0.5),
            tableView!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor, constant: constant*0.5),
            tableView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -constant*0.5),
            tableView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestionModel!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SuggestionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SuggestionTableViewCell", for: indexPath) as! SuggestionTableViewCell
        cell.updateTableViewCellForSuggestion(model: suggestionModel![indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight*1.8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ViewLocationViewController()
        vc.suggestionModel = suggestionModel![indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        // Change the title based on the scroll position with animation
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            if yOffset > 100 { // Adjust the threshold as needed
                self.navigationBar?.topItem?.largeTitleDisplayMode = .never
                self.navigationBar?.topItem?.title = AppUtils.localizableString(key: LanguageConstant.location)
            } else {
                self.navigationBar?.topItem?.largeTitleDisplayMode = .always
                self.navigationBar?.topItem?.title = AppUtils.localizableString(key: LanguageConstant.suggestion)
            }
        }
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
