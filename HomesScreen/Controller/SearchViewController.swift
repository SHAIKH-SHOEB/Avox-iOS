//
//  SearchViewController.swift
//  Avox
//
//  Created by Nimap on 16/03/24.
//

import UIKit

protocol SearchViewControllerDelegate: NSObjectProtocol {
    func didPressedTableViewCell(searchText: String)
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SearchBarViewDelegate {
    
    var deviceManager     : DeviceManager?
    weak var delegate     : SearchViewControllerDelegate?
    
    var searchBarView     : SearchBarView?
    var tableView         : UITableView?
    
    var fontSize          : CGFloat = 0.0
    var constant          : CGFloat = 0.0
    var cellHeight        : CGFloat = 0.0
    var containerHeight   : CGFloat = 0.0
    
    var suggestionModel   = AppConstants.searchSuggestionModel.sorted()
    var searchModel       : [String] = []
    var suggestionArray   : [String] = []
    var isSearch          : Bool?
    var isSuggestion      : Bool? = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Helper.Color.bgPrimary
        UINavigationBar.appearance().isTranslucent = false
        loadDeviceManager()
        loadSearchView()
        loadTableView()
        isSearch = false
    }
    
    func loadDeviceManager() {
        deviceManager = DeviceManager.instance
        if deviceManager!.deviceType == deviceManager!.iPhone5 || deviceManager!.deviceType == deviceManager!.iPhone6 {
            fontSize = Helper.DeviceManager.IPHONE_5_6_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_5_6_CONSTANT
            cellHeight = Helper.DeviceManager.IPHONE_5_6_CELL_HEIGHT
            containerHeight = Helper.DeviceManager.IPHONE_5_6_CONTAINER_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iPhone6plus || deviceManager!.deviceType == deviceManager!.iPhoneX {
            fontSize = Helper.DeviceManager.IPHONE_6PLUS_X_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_6PLUS_X_CONSTANT
            cellHeight = Helper.DeviceManager.IPHONE_6PLUS_X_CELL_HEIGHT
            containerHeight = Helper.DeviceManager.IPHONE_6PLUS_X_CONTAINER_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iphone12Family || deviceManager!.deviceType == deviceManager!.iphoneProMax {
            fontSize = Helper.DeviceManager.IPHONE_12FAMILY_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_12FAMILY_CONSTANT
            cellHeight = Helper.DeviceManager.IPHONE_12FAMILY_CELL_HEIGHT
            containerHeight = Helper.DeviceManager.IPHONE_12FAMILY_CONTAINER_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iPhone {
            fontSize = Helper.DeviceManager.IPHONE_FONT_SIZE
            constant = Helper.DeviceManager.IPHONE_CONSTANT
            cellHeight = Helper.DeviceManager.IPHONE_CELL_HEIGHT
            containerHeight = Helper.DeviceManager.IPHONE_CONTAINER_HEIGHT
        }
    }
    
    func loadSearchView() {
        searchBarView = SearchBarView(searchHint: LanguageConstant.searchAmazing, leftIcon:  UIImage(systemName: "arrow.backward")!)
        searchBarView!.translatesAutoresizingMaskIntoConstraints = false
        searchBarView!.delegate = self
        self.view.addSubview(searchBarView!)
        NSLayoutConstraint.activate([
            searchBarView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: constant),
            searchBarView!.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: constant),
            searchBarView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -constant)
        ])
    }
    
    func loadTableView() {
        tableView = UITableView()
        tableView!.translatesAutoresizingMaskIntoConstraints = false
        tableView!.backgroundColor = UIColor.clear
        tableView!.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.showsVerticalScrollIndicator = false
        tableView!.separatorStyle = .none
        self.view.addSubview(tableView!)
        NSLayoutConstraint.activate([
            tableView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: constant),
            tableView!.topAnchor.constraint(equalTo: searchBarView!.bottomAnchor, constant: constant),
            tableView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -constant),
            tableView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -constant)
        ])
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch! {
            if isSuggestion! {
                return suggestionArray.count
            }else {
                return searchModel.count
            }
        }else{
            return suggestionModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SettingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! SettingTableViewCell
        cell.IconView.image = UIImage(systemName: "magnifyingglass")
        cell.optionSwitch.isHidden = true
        if isSearch! {
            if isSuggestion! {
                cell.IconView.image = UIImage(systemName: "clock.arrow.circlepath")
                cell.titleLabel.text = suggestionArray[indexPath.row]
            }else {
                cell.titleLabel.text = searchModel[indexPath.row]
            }
        }else{
            cell.titleLabel.text = suggestionModel[indexPath.row]
        }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var searchText : String = ""
        if delegate != nil {
            if isSearch! {
                if isSuggestion! {
                    searchText = suggestionArray[indexPath.row]
                }else {
                    searchText = searchModel[indexPath.row]
                }
            }else{
                searchText = suggestionModel[indexPath.row]
            }
        }
        
        let vc = SearchImageViewController(queryString: searchText)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func textDidChange(searchText: String) {
        print(searchText)
        isSearch = true
        if searchText.isEmpty {
            searchModel = suggestionModel
        } else {
            searchModel = suggestionModel.filter { (suggestion) -> Bool in
                return suggestion.range(of: searchText, options: .caseInsensitive) != nil
            }
        }
        if searchModel.count <= 0 {
            suggestionArray.removeAll()
            suggestionArray.append(searchText)
            isSuggestion = true
        }else {
            isSuggestion = false
        }
        tableView!.reloadData()
    }
    
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}
