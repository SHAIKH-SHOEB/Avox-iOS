//
//  NotificationViewController.swift
//  Avox
//
//  Created by Nimap on 26/01/24.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    var navigationBar     : UINavigationBar?
    var deviceManager     : DeviceManager?
    var noRecordFound     : UILabel?
    
    var tableView         : UITableView?
    var notificationArray : [NotificationData] = []
    
    var fontSize          : CGFloat = 0.0
    var constant          : CGFloat = 0.0
    var cellHeight        : CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Helper.Color.bgPrimary
        UINavigationBar.appearance().isTranslucent = false
        fetchNotificationDatabaseInstant()
        loadDeviceManager()
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
    
    func fetchNotificationDatabaseInstant() {
        do {
            guard let result = try DatabaseManager.share.context.fetch(NotificationData.fetchRequest()) as? [NotificationData] else{
                return
            }
            notificationArray = result.reversed()
        }catch let error {
            debugPrint(error)
        }
    }
    
    func loadNavigationBar() {
        navigationBar = UINavigationBar()
        navigationBar?.translatesAutoresizingMaskIntoConstraints = false
        let navigationItem = UINavigationItem()
        navigationItem.title = AppUtils.localizableString(key: LanguageConstant.notification)
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
        unloadNoRecordFound()
        if notificationArray.count > 0 {
            tableView = UITableView()
            tableView!.translatesAutoresizingMaskIntoConstraints = false
            tableView!.backgroundColor = UIColor.clear
            tableView!.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
            tableView!.delegate = self
            tableView!.dataSource = self
            tableView!.showsVerticalScrollIndicator = false
            tableView!.separatorStyle = .none
            self.view.addSubview(tableView!)
            NSLayoutConstraint.activate([
                tableView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: constant),
                tableView!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor),
                tableView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -constant),
                tableView!.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }else {
            noRecordFounds()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.updateNotificationTableViewCell(models: notificationArray[indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight*1.8
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DatabaseManager.share.context.delete(notificationArray[indexPath.row])
            do {
                try DatabaseManager.share.context.save()
                notificationArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch let error {
                debugPrint("Failed to delete notification: \(error)")
            }
            //self.tableView!.deleteRows(at: [indexPath], with: .fade)
        }
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
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func noRecordFounds() {
        noRecordFound = UILabel()
        noRecordFound!.translatesAutoresizingMaskIntoConstraints = false
        noRecordFound!.text = AppUtils.localizableString(key: LanguageConstant.dataNotFound)
        noRecordFound!.font = UIFont.appFontBold(ofSize: fontSize*1.2)
        noRecordFound!.textColor = Helper.Color.textSecondary
        noRecordFound!.textAlignment = .center
        noRecordFound!.isUserInteractionEnabled = true
        self.view.addSubview(noRecordFound!)
        NSLayoutConstraint.activate([
            noRecordFound!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            noRecordFound!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    func unloadNoRecordFound() {
        if noRecordFound != nil {
            noRecordFound!.removeFromSuperview()
            noRecordFound = nil
        }
    }
}
