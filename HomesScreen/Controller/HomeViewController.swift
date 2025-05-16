//
//  HomeViewController.swift
//  Avox
//
//  Created by Nimap on 17/02/24.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout & PexelsParserDelegate, ImageTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource, SearchViewControllerDelegate, OptionBottomSheetViewDelegate {
    
    var deviceManager       : DeviceManager?
    var navigationBar       : UINavigationBar?
    let refreshControl      = UIRefreshControl()
    
    var scrollView          : UIScrollView?
    var stackView           : UIStackView?
    
    var collectionView      : UICollectionView?
    var tableView           : UITableView?
    var noRecordFound       : UILabel?
    
    var floatingButton      : UIButton?
    
    var titleModel          : [AppProvider]?
    var pexelsParser        : PexelsParser?
    var pexelsModel         : [PexelsModel]? = []
    
    var activityIndicator   : AvoxAlertView?
    var bottomSheetView     : OptionBottomSheetView?
    
    var fontSize            : CGFloat = 0.0
    var constant            : CGFloat = 0.0
    var cellHeight          : CGFloat = 0.0
    var containerHeight     : CGFloat = 0.0
    
    
    
    var isPagination        = false
    var nextUrl             = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        self.view.backgroundColor = Helper.Color.bgPrimary
        UINavigationBar.appearance().isTranslucent = false
        NotificationCenter.default.addObserver(self, selector: #selector(loadAppVersion), name: UIApplication.didBecomeActiveNotification, object: nil)
        titleModel = AppProvider.getImageTypeTitleProvider()
        loadDeviceManager()
        loadPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // This is where you perform tasks that need to occur every time the view appears.
        print("View will appear")
        //updateLangaugeForView()
        loadFloatingButton()
        loadAppVersion()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // This is where you start animations or tasks that require the view to be visible.
        print("View did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // This is where you clean up or save data before the view disappears.
        print("View will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // This is where you finalize any tasks that need to occur after the view disappears.
        print("View did disappear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc., that aren't in use.
        print("Memory warning received")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Adjust view layout before subviews are laid out.
        print("View will layout subviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Adjust view layout after subviews have been laid out.
        print("View did layout subviews")
    }
    
    func loadPage() {
        loadNavigationBar()
        //loadScrollView()
        //loadStackView()
        loadcollectionView()
        loadTableView()
        loadFloatingButton()
        loadActivityIndicator()
        loadImageParser()
        loadAppVersion()
    }
    
    func loadActivityIndicator() {
        activityIndicator = AvoxAlertView(target: self)
        activityIndicator!.activityIndicator.startAnimating()
    }
    
    func unloadActivityIndicator() {
        activityIndicator!.activityIndicator.stopAnimating()
        activityIndicator!.removeFromSuperview()
    }
    
    @objc func tap(sender: UITapGestureRecognizer){
        print("tapped")
        view.endEditing(true)
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
    
    func loadNavigationBar() {
        navigationBar = UINavigationBar()
        navigationBar!.translatesAutoresizingMaskIntoConstraints = false
        let navigationItem = UINavigationItem()
        navigationItem.title = AppUtils.localizableString(key: LanguageConstant.latest)
        let settingBTN = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .done, target: self, action: #selector(settingButtonPressed))
        let searchImageBTN = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(searchButtonPressed))
        navigationItem.rightBarButtonItems = [settingBTN, searchImageBTN]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell.badge"), style: .done, target: self, action: #selector(notificationButtonPressed))
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
    
    func loadScrollView() {
        scrollView = UIScrollView()
        scrollView!.translatesAutoresizingMaskIntoConstraints = false
        scrollView!.showsVerticalScrollIndicator = false
        scrollView!.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView!)
        NSLayoutConstraint.activate([
            scrollView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor),
            scrollView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func loadStackView() {
        stackView = UIStackView()
        stackView!.translatesAutoresizingMaskIntoConstraints = false
        stackView!.axis = NSLayoutConstraint.Axis.vertical
        stackView!.distribution = .fillProportionally
        scrollView!.addSubview(stackView!)
        NSLayoutConstraint.activate([
            stackView!.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor),
            stackView!.topAnchor.constraint(equalTo: scrollView!.topAnchor),
            stackView!.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor),
            stackView!.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor),
            stackView!.widthAnchor.constraint(equalTo: scrollView!.widthAnchor)
        ])
    }
    
    func loadFloatingButton() {
        if floatingButton == nil {
            floatingButton = UIButton(type: .system)
            floatingButton!.translatesAutoresizingMaskIntoConstraints = false
            floatingButton!.setImage(UIImage(systemName: "play.fill"), for: .normal)
            floatingButton!.backgroundColor = Helper.Color.appPrimary
            floatingButton!.tintColor = Helper.Color.accent
            floatingButton!.layer.cornerRadius = constant*4
            floatingButton!.clipsToBounds = true
            floatingButton!.addTarget(self, action: #selector(videoButtonPressed), for: .touchUpInside)
            self.view.addSubview(floatingButton!)
            NSLayoutConstraint.activate([
                floatingButton!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -constant*3),
                floatingButton!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -constant*3),
                floatingButton!.heightAnchor.constraint(equalToConstant: constant*8),
                floatingButton!.widthAnchor.constraint(equalToConstant: constant*8)
            ])
        }
        floatingButton!.isHidden = !Helper.isRegistration
    }
    
    func loadcollectionView() {
        if collectionView == nil {
            let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
            collectionView!.translatesAutoresizingMaskIntoConstraints = false
            collectionView!.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "TitleCollectionViewCell")
            collectionView!.backgroundColor = UIColor.clear
            collectionView!.delegate =  self
            collectionView!.dataSource = self
            collectionView!.showsHorizontalScrollIndicator =  false
            collectionView!.showsVerticalScrollIndicator =  false
            collectionView!.alwaysBounceHorizontal = true
            self.view.addSubview(collectionView!)
            NSLayoutConstraint.activate([
                collectionView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8.0),
                collectionView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8.0),
                collectionView!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor),
                collectionView!.heightAnchor.constraint(equalToConstant: cellHeight)
            ])
        }else{
            collectionView!.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleModel!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : TitleCollectionViewCell?
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as? TitleCollectionViewCell
        cell!.updateTitleCollectionViewCell(model: titleModel![indexPath.row])
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        unSelectAllModels()
        titleModel![indexPath.row].index = 1
        collectionView.reloadData()
        loadQueryParser(query: titleModel![indexPath.row].title!)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView!.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: titleModel![indexPath.row].cellWidth!+cellHeight*0.8, height: cellHeight*0.8)
    }
    
    func unSelectAllModels() {
        for each in titleModel! {
            each.index = 0
        }
    }
    
    func loadTableView() {
        tableView = UITableView()
        tableView!.translatesAutoresizingMaskIntoConstraints = false
        tableView!.backgroundColor = UIColor.clear
        tableView!.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.showsVerticalScrollIndicator = false
        tableView!.separatorStyle = .none
        tableView!.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.view.addSubview(tableView!)
        NSLayoutConstraint.activate([
            tableView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView!.topAnchor.constraint(equalTo: collectionView!.bottomAnchor, constant: 4),
            tableView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pexelsModel!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
        cell.updateTableViewCellForImageView(model: pexelsModel![indexPath.row], index: indexPath.row)
        cell.delegate = self
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight*8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        vc!.imageUrl = pexelsModel![indexPath.row].src!.original!
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == pexelsModel!.count - 1 && isPagination == false {
            isPagination = true
            loadNextImageParser(next: nextUrl)
        }
    }
    
    @objc func refreshData() {
        unSelectAllModels()
        collectionView!.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.loadImageParser()
            self.refreshControl.endRefreshing()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        // Change the title based on the scroll position with animation
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            if yOffset > 100 { // Adjust the threshold as needed
                self.navigationBar?.topItem?.largeTitleDisplayMode = .never
                self.navigationBar?.topItem?.title = AppUtils.localizableString(key: LanguageConstant.explore)
                UIView.animate(withDuration: 0.3) {
                    self.floatingButton?.alpha = 0.0
                }
            } else {
                self.navigationBar?.topItem?.largeTitleDisplayMode = .always
                self.navigationBar?.topItem?.title = AppUtils.localizableString(key: LanguageConstant.latest)
                UIView.animate(withDuration: 0.3) {
                    self.floatingButton?.alpha = 1.0
                }
            }
        }
    }
    
    func loadImageParser() {
        pexelsParser = PexelsParser()
        pexelsParser!.delegate = self
        pexelsParser!.getImageData()
    }
    
    func loadQueryParser(query: String) {
        loadActivityIndicator()
        pexelsParser = PexelsParser()
        pexelsParser!.delegate = self
        pexelsParser!.getQueryData(query: query)
    }
    
    func loadNextImageParser(next: String) {
        loadActivityIndicator()
        pexelsParser = PexelsParser()
        pexelsParser!.delegate = self
        pexelsParser!.getNextUrlData(nextUrl: next)
    }
    
    func didRecievedSuccess(model: [PexelsModel], next: String) {
        unloadNoRecordFound()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.unloadActivityIndicator()
        }
        if isPagination {
            pexelsModel!.append(contentsOf: model)
            nextUrl = next
            isPagination = false
        }else {
            if model.count > 0 {
                pexelsModel!.removeAll(keepingCapacity: true)
                nextUrl = next
                pexelsModel = model
            }else{
                unloadTableView()
                noRecordFounds()
            }
        }
        tableView!.reloadData()
    }
    
    func didRecievedFailure(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.unloadActivityIndicator()
        }
        unloadFloatingButton()
        unloadTableView()
        unloadCollectionView()
        noRecordFounds()
        print(message)
    }
    
    //MARK: TableView Delegate
    func didClickOnProfile(url: String) {
        let vc = WebViewViewController()
        vc.urlString = url
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didClickOnOption(index: Int) {
        bottomSheetView = OptionBottomSheetView()
        bottomSheetView!.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetView!.delegate = self
        bottomSheetView!.index = index
        bottomSheetView!.alpha = 0.0
        self.view.addSubview(bottomSheetView!)
        NSLayoutConstraint.activate([
            bottomSheetView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomSheetView!.topAnchor.constraint(equalTo: self.view.topAnchor),
            bottomSheetView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomSheetView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        UIView.animate(withDuration: 0.3) {
            self.bottomSheetView!.alpha = 1.0
        }
    }
    
    func backButtonPressed() {
        if bottomSheetView != nil {
            bottomSheetView!.removeFromSuperview()
            bottomSheetView!.delegate = nil
            bottomSheetView = nil
        }
    }
    
    func didOptionButtonPressed(id: Int, index: Int) {
        backButtonPressed()
        switch id {
        case 1 :
            print("Profile Info")
            let vc = WebViewViewController()
            vc.urlString = pexelsModel![index].photographer_url
            self.navigationController?.pushViewController(vc, animated: true)
        case 2 :
            print("Download Image")
        case 3 :
            print("Open Full Image View")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
            vc!.imageUrl = self.pexelsModel![index].src!.original!
            self.navigationController?.pushViewController(vc!, animated: true)
        default:
            return
        }
    }
    
    //MARK: SearchViewController Delegate
    func didPressedTableViewCell(searchText: String) {
        let vc = SearchImageViewController(queryString: searchText)
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    func unloadCollectionView() {
        if collectionView != nil {
            collectionView!.removeFromSuperview()
            collectionView = nil
        }
    }
    
    func unloadTableView() {
        if tableView != nil {
            tableView!.removeFromSuperview()
            tableView = nil
        }
    }
    
    func unloadFloatingButton() {
        if floatingButton != nil {
            floatingButton!.removeFromSuperview()
            floatingButton = nil
        }
    }
    
    @objc func settingButtonPressed() {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func searchButtonPressed() {
        let vc = SearchViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func notificationButtonPressed() {
        let vc = NotificationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func videoButtonPressed() {
        let vc = VideosViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Check App Version
    @objc func loadAppVersion() {
        if AppUtils.checkAppVersion() {
            let alertController = UIAlertController(title: "Update Required", message: "A new version of the app is available. Please update to continue using the app.", preferredStyle: .alert)
            let updateAction = UIAlertAction(title: "Update", style: .default) { update in
                if let url = URL(string: "https://www.apple.com/app-store/") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    print("Invalid URL")
                }
            }
            let laterAction = UIAlertAction(title: "Later", style: .destructive) { later in
                exit(0)
            }
            alertController.addAction(updateAction)
            alertController.addAction(laterAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func updateLangaugeForView() {
        collectionView!.reloadData()
        navigationBar?.topItem?.title = AppUtils.localizableString(key: LanguageConstant.latest)
    }
}

//var contactCallback : ((_ name: String, _ phone: String)-> Void)!
//self.view.insertSubview(crmOrderTableView!, belowSubview: searchBarView!)
