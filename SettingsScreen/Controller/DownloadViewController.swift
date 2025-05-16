//
//  DownloadViewController.swift
//  Avox
//
//  Created by Nimap on 26/01/24.
//

import UIKit

class DownloadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    var deviceManager     : DeviceManager?
    var navigationBar     : UINavigationBar?
    let refreshControl    = UIRefreshControl()
    
    var tableView         : UITableView?
    var imageDataModel    : [ImageData]?
    var noRecordFound     : UILabel?
    
    var fontSize          : CGFloat = 0.0
    var constant          : CGFloat = 0.0
    var cellHeight        : CGFloat = 0.0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Helper.Color.bgPrimary
        UINavigationBar.appearance().isTranslucent = false
        loadDeviceManager()
        loadPage()
    }
    
    func loadPage() {
        loadNavigationBar()
        loadHistoryData()
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
    
    func loadHistoryData() {
        //let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        imageDataModel = []
        do {
            let result = try DatabaseManager.share.context.fetch(ImageData.fetchRequest()) as [ImageData]
            imageDataModel = result.reversed()
        }catch {
            debugPrint(error)
        }
        loadTableView()
    }
    
    func loadNavigationBar() {
        navigationBar = UINavigationBar()
        navigationBar?.translatesAutoresizingMaskIntoConstraints = false
        let navigationItem = UINavigationItem()
        navigationItem.title = AppUtils.localizableString(key: LanguageConstant.history)
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
    
    func loadTableView() {
        if imageDataModel!.count > 0 {
            tableView = UITableView()
            tableView!.translatesAutoresizingMaskIntoConstraints = false
            tableView!.backgroundColor = UIColor.clear
            tableView!.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
            tableView!.delegate = self
            tableView!.dataSource = self
            tableView!.showsVerticalScrollIndicator = false
            tableView!.separatorStyle = .none
            tableView!.refreshControl = refreshControl
            refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
            self.view.addSubview(tableView!)
            NSLayoutConstraint.activate([
                tableView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                tableView!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor, constant: 4),
                tableView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                tableView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        }else {
            noRecordFounds()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageDataModel!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        cell.updateTableViewCellForHistory(model: imageDataModel![indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(imageDataModel![indexPath.row])")
    }
    
    @objc func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.refreshControl.endRefreshing()
        }
        loadHistoryData()
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
        noRecordFound!.font = UIFont.appFontBold(ofSize: 18.0)
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

//class TableViewWithHeaderFooterVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    
//    let tableView = UITableView()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        
//        setupTableView()
//        setupTableHeader()
//        setupTableFooter()
//    }
//    
//    func setupTableView() {
//        view.addSubview(tableView)
//        
//        // Setup constraints
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
//        ])
//        
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//    }
//    
//    func setupTableHeader() {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
//        headerView.backgroundColor = .systemBlue
//        
//        let headerLabel = UILabel()
//        headerLabel.text = "Table Header"
//        headerLabel.textColor = .white
//        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
//        headerLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        headerView.addSubview(headerLabel)
//        NSLayoutConstraint.activate([
//            headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
//            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
//        ])
//        
//        tableView.tableHeaderView = headerView
//    }
//    
//    func setupTableFooter() {
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
//        footerView.backgroundColor = .systemGray
//        
//        let footerLabel = UILabel()
//        footerLabel.text = "Table Footer"
//        footerLabel.textColor = .white
//        footerLabel.font = UIFont.systemFont(ofSize: 16)
//        footerLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        footerView.addSubview(footerLabel)
//        NSLayoutConstraint.activate([
//            footerLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
//            footerLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
//        ])
//        
//        tableView.tableFooterView = footerView
//    }
//    
//    // MARK: - UITableViewDataSource
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 20 // Example data
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = "Row \(indexPath.row + 1)"
//        return cell
//    }
//}
//
//class SectionHeaderTableViewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    let tableView = UITableView()
//    let data = [
//        ["Apple", "Banana", "Cherry"],
//        ["Carrot", "Tomato", "Spinach"]
//    ]
//    
//    let sectionTitles = ["Fruits", "Vegetables"]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupTableView()
//    }
//    
//    func setupTableView() {
//        view.addSubview(tableView)
//        
//        // Auto Layout
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
//        ])
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//    }
//    
//    // MARK: - Data Source
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return data.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data[section].count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = data[indexPath.section][indexPath.row]
//        return cell
//    }
//    
//    // MARK: - Section Header (Custom View)
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = .lightGray
//        
//        let label = UILabel()
//        label.text = sectionTitles[section]
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//        label.textColor = .black
//        label.translatesAutoresizingMaskIntoConstraints = false
//        
//        headerView.addSubview(label)
//        
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
//            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
//        ])
//        
//        return headerView
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50 // Customize header height
//    }
//}
//
//
//class ExpandableSectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    let tableView = UITableView()
//    
//    let data = [
//        ["Apple", "Banana", "Cherry"],
//        ["Carrot", "Tomato", "Spinach"]
//    ]
//    
//    let sectionTitles = ["Fruits", "Vegetables"]
//    
//    // Track expanded state
//    var expandedSections: Set<Int> = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupTableView()
//    }
//
//    func setupTableView() {
//        view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        if #available(iOS 15.0, *) {
//            tableView.sectionHeaderTopPadding = 0.0
//        }
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
//        ])
//
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//    }
//
//    // MARK: - Data Source
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return data.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return expandedSections.contains(section) ? data[section].count : 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = data[indexPath.section][indexPath.row]
//        return cell
//    }
//
//    // MARK: - Header View with Tap Gesture
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let headerView = UIView()
//        headerView.backgroundColor = .systemGray5
//        headerView.tag = section
//
//        let label = UILabel()
//        label.text = sectionTitles[section]
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        headerView.addSubview(label)
//
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
//            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
//        ])
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeaderTap(_:)))
//        headerView.addGestureRecognizer(tapGesture)
//
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
//
//    // MARK: - Header Tap Handler
//
//    @objc func handleHeaderTap(_ gesture: UITapGestureRecognizer) {
//        guard let section = gesture.view?.tag else { return }
//
//        if expandedSections.contains(section) {
//            expandedSections.remove(section)
//        } else {
//            expandedSections.insert(section)
//        }
//
//        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
//    }
//}
