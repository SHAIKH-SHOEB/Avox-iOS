//
//  SearchImageViewController.swift
//  Avox
//
//  Created by Nimap on 11/02/24.
//

import UIKit

class SearchImageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PexelsParserDelegate, ImageTableViewCellDelegate {
    
    var navigationBar   : UINavigationBar?
    var tableView       : UITableView?
    let refreshControl  = UIRefreshControl()
    var noRecordFound   : UILabel?
    
    var pexelsParser    : PexelsParser?
    var pexelsModel     : [PexelsModel]? = []
    var queryString     : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Helper.Color.bgPrimary
        UINavigationBar.appearance().isTranslucent = false
        loadNavigationBar()
    }
    
    init(queryString: String) {
        super.init(nibName: nil, bundle: nil)
        self.queryString = queryString
        loadTableView()
        loadQueryParser(query: queryString)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadNavigationBar() {
        navigationBar = UINavigationBar()
        navigationBar!.translatesAutoresizingMaskIntoConstraints = false
        let navigationItem = UINavigationItem()
        navigationItem.title = AppUtils.localizableString(key: LanguageConstant.search)
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
        
        //let searchController = UISearchController(searchResultsController: nil)
        //searchController.loadViewIfNeeded()
        //searchController.searchResultsUpdater = self
        //searchController.obscuresBackgroundDuringPresentation = false
        //searchController.hidesNavigationBarDuringPresentation = false
        //searchController.searchBar.delegate = self
        //searchController.searchBar.placeholder = "Search"
        //navigationItem.searchController = searchController
        //searchController.definesPresentationContext = false
        //navigationItem.hidesSearchBarWhenScrolling = false
        //searchController.searchBar.sizeToFit()
        //searchController.searchBar.searchBarStyle = .prominent
        //searchController.searchBar.scopeButtonTitles = ["All", "Europe", "Asia", "Africa", "America"]
        //tableView!.tableHeaderView = searchController!.searchBar
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
            tableView!.topAnchor.constraint(equalTo: navigationBar!.bottomAnchor, constant: 8),
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
        return 500.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        vc!.imageUrl = pexelsModel![indexPath.row].src!.original!
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.loadQueryParser(query: "Delhi")
            self.refreshControl.endRefreshing()
        }
    }
    
    func didClickOnProfile(url: String) {
        let vc = WebViewViewController()
        vc.urlString = url
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didClickOnOption(index: Int) {
        print(index)
    }
    
    func loadQueryParser(query: String) {
        pexelsParser = PexelsParser()
        pexelsParser!.delegate = self
        pexelsParser!.getQueryData(query: query)
        if pexelsModel!.count > 0 {
            pexelsModel!.removeAll(keepingCapacity: true)
        }
    }
    
    func didRecievedSuccess(model: [PexelsModel], next: String) {
        unloadNoRecordFound()
        if model.count > 0 {
            pexelsModel = model
        }else{
            noRecordFounds()
        }
        tableView!.reloadData()
    }
    
    func didRecievedFailure(message: String) {
        print(message)
        unloadNoRecordFound()
        noRecordFounds()
        tableView!.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        // Change the title based on the scroll position with animation
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            if yOffset > 100 { // Adjust the threshold as needed
                self.navigationBar?.topItem?.largeTitleDisplayMode = .never
                self.navigationBar?.topItem?.title = AppUtils.localizableString(key: LanguageConstant.search)
            } else {
                self.navigationBar?.topItem?.largeTitleDisplayMode = .always
                self.navigationBar?.topItem?.title = AppUtils.localizableString(key: LanguageConstant.search)
            }
        }
    }
    
    @objc func backButtonPressed() {
        //self.navigationController?.popViewController(animated: true)
        if let viewControllers = self.navigationController?.viewControllers {
            for controller in viewControllers {
                if controller.isKind(of: HomeViewController.self) {
                    navigationController?.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
    
    //func updateSearchResults(for searchController: UISearchController) {
    //    if let searchText = searchController.searchBar.text, !searchText.isEmpty {
    //        print("updateSearchResults: \(searchText)")
    //        loadQueryParser(query: searchText)
    //    } else {
    //        loadQueryParser(query: "Kolkata")
    //    }
    //}
    //
    //func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    //    searchBar.setShowsCancelButton(true, animated: true)
    //}
    //
    //func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //    searchBar.setShowsCancelButton(false, animated: true)
    //}
    
    func noRecordFounds() {
        noRecordFound = UILabel()
        noRecordFound!.translatesAutoresizingMaskIntoConstraints = false
        noRecordFound!.text = "Data Not Found!"
        noRecordFound!.font = UIFont.appFontBold(ofSize: 20.0)
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
}
