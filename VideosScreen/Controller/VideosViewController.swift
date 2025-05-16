//
//  VideosViewController.swift
//  Avox
//
//  Created by Nimap on 26/02/24.
//

import UIKit
import AVKit

class VideosViewController: UIViewController, UIScrollViewDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, PexelsVideoParserDelegate {
    
    var navigationBar     : UINavigationBar?
    var searchBarView     : UISearchBar?
    var tableView         : UITableView?
    
    var noRecordFound     : UILabel?
    var activityIndicator : AvoxAlertView?
    
    var pexelsVideoParser : PexelsVideoParser?
    var pexelsVideoModel  : [Videos]?
    
    var isPagination        = false
    var nextUrl             = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Helper.Color.bgPrimary
        UINavigationBar.appearance().isTranslucent = false
        pexelsVideoModel = []
        loadNavigationBar()
        //loadSearchView()
        loadTableView()
        loadVideoParser()
        NotificationCenter.default.addObserver(self, selector: #selector(self.appEnteredFromBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pausePlayeVideos()
    }
    
    func loadNavigationBar() {
        navigationBar = UINavigationBar()
        navigationBar!.translatesAutoresizingMaskIntoConstraints = false
        let navigationItem = UINavigationItem()
        navigationItem.title = AppUtils.localizableString(key: LanguageConstant.video)
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
    
    func loadSearchView() {
        searchBarView = UISearchBar()
        searchBarView!.translatesAutoresizingMaskIntoConstraints = false
        searchBarView!.delegate = self
        searchBarView!.placeholder = "Search"
        searchBarView!.barTintColor = Helper.Color.textPrimary
        searchBarView!.searchTextField.backgroundColor = Helper.Color.bgSecondary
        searchBarView!.backgroundImage = UIImage()
        searchBarView!.showsCancelButton = false
        self.view.addSubview(searchBarView!)
        NSLayoutConstraint.activate([
            searchBarView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchBarView!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor, constant: 4.0),
            searchBarView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func loadTableView() {
        //UIDevice.current.systemName
        if tableView == nil {
            tableView = UITableView()
            tableView!.translatesAutoresizingMaskIntoConstraints = false
            tableView!.backgroundColor = UIColor.clear
            tableView!.register(UINib(nibName: "VideosTableViewCell", bundle: nil), forCellReuseIdentifier: "VideosTableViewCell")
            tableView!.delegate = self
            tableView!.dataSource = self
            tableView!.showsVerticalScrollIndicator = false
            //tableView!.isScrollEnabled = false
            tableView!.separatorStyle = .none
            self.view.addSubview(tableView!)
            NSLayoutConstraint.activate([
                tableView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                tableView!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor, constant: 8),
                tableView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                tableView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8)
            ])
        }else {
            tableView!.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pexelsVideoModel!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : VideosTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VideosTableViewCell", for: indexPath) as! VideosTableViewCell
        cell.updateTableViewCellForVideo(model: pexelsVideoModel![indexPath.row])
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
        if indexPath.row == pexelsVideoModel!.count - 1 && isPagination == false {
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
    
    func pausePlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView!)
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView!, appEnteredFromBackground: true)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y

        // Change the title based on the scroll position with animation
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            if yOffset > 100 { // Adjust the threshold as needed
                self.navigationBar?.topItem?.largeTitleDisplayMode = .never
                self.navigationBar?.topItem?.title = AppUtils.localizableString(key: LanguageConstant.video)
            } else {
                self.navigationBar?.topItem?.largeTitleDisplayMode = .always
                self.navigationBar?.topItem?.title = AppUtils.localizableString(key: LanguageConstant.video)
            }
        }
    }
    
    func loadVideoParser() {
        loadActivityIndicator()
        pexelsVideoParser = PexelsVideoParser()
        pexelsVideoParser!.delegate = self
        pexelsVideoParser!.getVideoData()
    }
    
    func loadNextVideoParser(next: String) {
        loadActivityIndicator()
        pexelsVideoParser = PexelsVideoParser()
        pexelsVideoParser!.delegate = self
        pexelsVideoParser!.getNextUrlData(nextUrl: nextUrl)
    }
    
    func didRecievedPexelsVideoSuccess(model: [Videos], nextUrl: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.unloadActivityIndicator()
        }
        if isPagination {
            pexelsVideoModel!.append(contentsOf: model)
            self.nextUrl = nextUrl
            isPagination = false
        }else {
            if model.count > 0 {
                pexelsVideoModel!.removeAll(keepingCapacity: true)
                self.nextUrl = nextUrl
                pexelsVideoModel!.append(contentsOf: model)
            }else{
                unloadTableView()
                noRecordFounds()
            }
        }
        loadTableView()
    }
    
    func didRecievedPexelsVideoFailure(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.unloadActivityIndicator()
        }
        print("Hello World")
        unloadTableView()
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
    
    func unloadTableView() {
        if tableView != nil {
            tableView!.removeFromSuperview()
            tableView = nil
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
}
