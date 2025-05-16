//
//  CollectionsDetailViewController.swift
//  Avox
//
//  Created by Shaikh Shoeb on 21/09/24.
//

import UIKit
import AVKit

class CollectionsDetailViewController: UIViewController, UIScrollViewDelegate, CollectionsDetailParserDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var deviceManager           : DeviceManager?
    var collectionsDetailParser : CollectionsDetailParser?
    var collectionsDetailModel  : [Media]?
    
    var noRecordFound           : UILabel?
    var activityIndicator       : AvoxAlertView?
    
    var fontSize                : CGFloat = 0.0
    var cellHeight              : CGFloat = 0.0
    
    var isPagination            = false
    var nextUrl                 = ""
    var id = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Helper.Color.bgPrimary
        UINavigationBar.appearance().isTranslucent = false
        collectionsDetailModel = []
        loadDeviceManager()
        loadNavigationBar()
        loadTableView()
        loadCollectionsDetailsParser()
        NotificationCenter.default.addObserver(self, selector: #selector(self.appEnteredFromBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pausePlayeVideos()
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
        navigationItem.title = AppUtils.localizableString(key: LanguageConstant.details)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backButtonPressed))
        navigationBar.items = [navigationItem]
        navigationBar.barTintColor = Helper.Color.bgPrimary
        navigationBar.tintColor = Helper.Color.appPrimary
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar.prefersLargeTitles = true
        let largeTitleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.appFontBold(ofSize: fontSize*1.8) as Any, .foregroundColor: Helper.Color.textPrimary as Any]
        navigationBar!.largeTitleTextAttributes = largeTitleAttributes
    }
    
    func loadTableView() {
        tableView!.backgroundColor = UIColor.clear
        tableView!.register(UINib(nibName: "VideosTableViewCell", bundle: nil), forCellReuseIdentifier: "VideosTableViewCell")
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.showsVerticalScrollIndicator = false
        tableView!.separatorStyle = .none
        //tableView!.refreshControl = refreshControl
        //refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionsDetailModel!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : VideosTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VideosTableViewCell", for: indexPath) as! VideosTableViewCell
        cell.updateTableViewCellForCollections(model: collectionsDetailModel![indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == collectionsDetailModel!.count - 1 && isPagination == false {
            isPagination = true
            loadNextVideoParser(next: nextUrl)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {pausePlayeVideos()}
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
    
    func pausePlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView!)
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView!, appEnteredFromBackground: true)
    }
    
    func loadCollectionsDetailsParser() {
        loadActivityIndicator()
        if collectionsDetailParser == nil {
            collectionsDetailParser = CollectionsDetailParser()
            collectionsDetailParser!.delegate = self
            collectionsDetailParser!.getCollectionsDetailData(id: id)
        }
    }
    
    func loadNextVideoParser(next: String) {
        loadActivityIndicator()
        if collectionsDetailParser == nil {
            collectionsDetailParser = CollectionsDetailParser()
            collectionsDetailParser!.delegate = self
            collectionsDetailParser!.getCollectionsDetailData(nextUrl: nextUrl)
        }
    }
    
    func didRecievedCollectionsDetailSuccess(model: [Media], nextUrl: String) {
        collectionsDetailParser = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.unloadActivityIndicator()
        }
        if isPagination {
            collectionsDetailModel!.append(contentsOf: model)
            self.nextUrl = nextUrl
            isPagination = false
        }else {
            if model.count > 0 {
                if collectionsDetailModel != nil && collectionsDetailModel!.count > 0 {
                    collectionsDetailModel!.removeAll(keepingCapacity: true)
                }
                
                self.nextUrl = nextUrl
                collectionsDetailModel!.append(contentsOf: model)
            }else{
                noRecordFounds()
            }
        }
        tableView!.reloadData()
    }
    
    func didRecievedCollectionsDetailFailure(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.unloadActivityIndicator()
        }
        noRecordFounds()
    }
    
    func noRecordFounds() {
        noRecordFound = UILabel()
        noRecordFound!.translatesAutoresizingMaskIntoConstraints = false
        noRecordFound!.text = "Data Not Found!"
        noRecordFound!.font = UIFont.appFontBold(ofSize: 16)
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
