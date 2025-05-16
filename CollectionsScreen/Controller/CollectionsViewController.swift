//
//  CollectionsViewController.swift
//  Avox
//
//  Created by Shaikh Shoeb on 17/09/24.
//

import UIKit

class CollectionsViewController: UIViewController, PexelsCollectionsParserDelegate, UITableViewDelegate, UITableViewDataSource, CollectionsSearchViewDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionsTableView: UITableView!
    
    var deviceManager       : DeviceManager?
    let refreshControl      = UIRefreshControl()
    var noRecordFound       : UILabel?
    
    var collectionsParser   : PexelsCollectionsParser?
    var collectionsModel    : [Collections]? = []
    
    var activityIndicator   : AvoxAlertView?
    var collectionsView     : CollectionsSearchView?
    
    var fontSize            : CGFloat = 0.0
    var cellHeight          : CGFloat = 0.0
    
    var isPagination        = false
    var nextUrl             = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadDeviceManager()
        loadPage()
    }
    
    func loadPage() {
        loadNavigationBar()
        loadTableView()
        loadCollectionsParser()
    }
    
    func loadActivityIndicator() {
        activityIndicator = AvoxAlertView(target: self)
        activityIndicator!.activityIndicator.startAnimating()
    }
    
    func unloadActivityIndicator() {
        activityIndicator!.activityIndicator.stopAnimating()
        activityIndicator!.removeFromSuperview()
    }
    
    func loadDeviceManager() {
        deviceManager = DeviceManager.instance
        if deviceManager!.deviceType == deviceManager!.iPhone5 || deviceManager!.deviceType == deviceManager!.iPhone6 {
            fontSize = Helper.DeviceManager.IPHONE_5_6_FONT_SIZE
            cellHeight = Helper.DeviceManager.IPHONE_5_6_CELL_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iPhone6plus || deviceManager!.deviceType == deviceManager!.iPhoneX {
            fontSize = Helper.DeviceManager.IPHONE_6PLUS_X_FONT_SIZE
            cellHeight = Helper.DeviceManager.IPHONE_6PLUS_X_CELL_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iphone12Family || deviceManager!.deviceType == deviceManager!.iphoneProMax {
            fontSize = Helper.DeviceManager.IPHONE_12FAMILY_FONT_SIZE
            cellHeight = Helper.DeviceManager.IPHONE_12FAMILY_CELL_HEIGHT
        }else if deviceManager!.deviceType == deviceManager!.iPhone {
            fontSize = Helper.DeviceManager.IPHONE_FONT_SIZE
            cellHeight = Helper.DeviceManager.IPHONE_CELL_HEIGHT
        }
    }
    
    func loadNavigationBar() {
        let navigationItem = UINavigationItem()
        navigationItem.title = AppUtils.localizableString(key: LanguageConstant.collections)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(collectionsButtonPressed))
        navigationBar.items = [navigationItem]
        navigationBar.barTintColor = Helper.Color.bgPrimary
        navigationBar.tintColor = Helper.Color.appPrimary
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar.prefersLargeTitles = true
        let largeTitleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.appFontBold(ofSize: fontSize*1.8) as Any, .foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar!.largeTitleTextAttributes = largeTitleAttributes
    }
    
    func loadTableView() {
        collectionsTableView!.showsVerticalScrollIndicator = false
        collectionsTableView.separatorStyle = .none
        collectionsTableView.delegate = self
        collectionsTableView.dataSource = self
        collectionsTableView!.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionsModel!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = collectionsTableView.dequeueReusableCell(withIdentifier: "CollectionsTableViewCell", for: indexPath) as! CollectionsTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.updateTableViewCellForCollections(model: collectionsModel![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        collectionsModel![indexPath.row].isExpanded.toggle()
        // Reload the selected row to update the display
        tableView.reloadRows(at: [indexPath], with: .automatic)
        // Optionally, deselect the row after selection
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return collectionsModel![indexPath.row].isExpanded ? cellHeight*1.2 : cellHeight*1.6
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == collectionsModel!.count - 1 && isPagination == false {
            isPagination = true
            loadCollectionsParser(next: nextUrl)
        }
    }
    
    @objc func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.loadCollectionsParser()
            self.refreshControl.endRefreshing()
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
    
    func loadCollectionsParser() {
        loadActivityIndicator()
        collectionsParser = PexelsCollectionsParser()
        collectionsParser!.delegate = self
        collectionsParser!.getCollectionsData()
    }
    
    func loadCollectionsParser(next: String) {
        loadActivityIndicator()
        collectionsParser = PexelsCollectionsParser()
        collectionsParser!.delegate = self
        collectionsParser!.getCollectionsData(nextUrl: next)
    }
    
    //MARK: CollectionsParserDelegate
    func didRecievedPexelsCollectionsSuccess(model: [Collections], nextUrl: String) {
        unloadNoRecordFound()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.unloadActivityIndicator()
        }
        if isPagination {
            collectionsModel!.append(contentsOf: model)
            self.nextUrl = nextUrl
            isPagination = false
        }else {
            if model.count > 0 {
                collectionsModel!.removeAll(keepingCapacity: true)
                self.nextUrl  = nextUrl
                collectionsModel = model
            }else {
                unloadTableView()
                unloadNoRecordFound()
            }
        }
        collectionsTableView.reloadData()
    }
    
    func didRecievedPexelsCollectionsFailure(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.unloadActivityIndicator()
        }
        unloadTableView()
        noRecordFounds()
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func collectionsButtonPressed() {
        collectionsView = CollectionsSearchView()
        collectionsView!.delegate = self
        collectionsView!.alpha = 0.0
        self.view.addSubview(collectionsView!)
        UIView.animate(withDuration: 0.3) {
            self.collectionsView!.alpha = 1.0
        }
    }
    
    //MARK: CollectionsSearchViewDelegate
    func cancelButtonPressed() {
        if collectionsView != nil {
            collectionsView!.removeFromSuperview()
            collectionsView!.delegate = nil
            collectionsView = nil
        }
    }
    
    func searchButtonPressed(pexelId: String) {
        cancelButtonPressed()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CollectionsDetailViewController") as? CollectionsDetailViewController
        vc!.id = pexelId
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func noRecordFounds() {
        noRecordFound = UILabel()
        noRecordFound!.translatesAutoresizingMaskIntoConstraints = false
        noRecordFound!.text = "Data Not Found!"
        noRecordFound!.font = UIFont.appFontBold(ofSize: fontSize*1.5)
        noRecordFound!.textColor = Helper.Color.textPrimary
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
    
    func unloadTableView() {
        if collectionsTableView != nil {
            collectionsTableView!.removeFromSuperview()
            collectionsTableView = nil
        }
    }
}
