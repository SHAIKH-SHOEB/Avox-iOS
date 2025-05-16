//
//  ChangeIconViewController.swift
//  Avox
//
//  Created by Shoeb on 18/04/25.
//

import UIKit

class ChangeIconViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AvoxAlertViewDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var alertView : AvoxAlertView?
    var iconModel : [AppProvider]?
    var cellSize  : CGFloat!
    var index     : Int = -1 //You can also used like # var index : Int32 = -1
    var defaultId = UserDefaults.standard.integer(forKey: "appIconId")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellSize = self.view.frame.size.width / 5.5
        iconModel = AppProvider.getApplicationIconProvider()
        loadNavigationBar()
        loadTableView()
        defaultSelected()
    }
    
    func loadNavigationBar() {
        let navigationItems = UINavigationItem()
        navigationItems.title = "Change App Icon"
        navigationItems.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(saveIconButtonPressed))
        navigationItems.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backButtonPressed))
        navigationBar.items = [navigationItems]
        navigationBar.barTintColor = Helper.Color.bgPrimary
        navigationBar.tintColor = Helper.Color.appPrimary
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar.prefersLargeTitles = true
        let largeTitleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.appFontBold(ofSize: 24) as Any, .foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar.largeTitleTextAttributes = largeTitleAttributes
    }
    
    func loadTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iconModel!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeIconTableViewCell", for: indexPath) as! ChangeIconTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.updateTableViewCellForIcon(model: iconModel![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        unCheckAll()
        index = indexPath.row
        iconModel![indexPath.row].index = 1
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellSize
    }
    
    func unCheckAll() {
        for model in iconModel! {
            model.index = 0
        }
    }
    
    func defaultSelected() {
        for model in iconModel! {
            if defaultId == model.id {
                model.index = 1
            }else {
                model.index = 0
            }
        }
    }
    
    func loadAlertView(title: String, message: String, tag: [String]) {
        unloadAlertView()
        alertView = AvoxAlertView(title: title, message: message, tag: tag, target: self)
        alertView!.delegate = self
    }
    
    func unloadAlertView() {
        if alertView != nil {
            alertView!.removeFromSuperview()
            alertView = nil
        }
    }
    
    func clickOnPositiveButton(tag: String) {
        unloadAlertView()
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveIconButtonPressed() {
        if index == -1 || index == 0 {
            changeAppIcon(to: nil)
            UserDefaults.standard.set(1, forKey: "appIconId")
        }else {
            changeAppIcon(to: iconModel![index].value)
            UserDefaults.standard.set(iconModel![index].id, forKey: "appIconId")
        }
    }
    
    func changeAppIcon(to iconName: String?) {
        guard UIApplication.shared.supportsAlternateIcons else {
            loadAlertView(title: "Alert", message: "Alternate icons not supported", tag: ["error"])
            return
        }
        
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                self.loadAlertView(title: "Alert", message: "Failed to change icon: \(error.localizedDescription)", tag: ["error"])
            } else {
                self.navigationController?.popViewController(animated: true)
                print("Icon changed successfully to \(iconName ?? "primary icon")")
            }
        }
    }

}
