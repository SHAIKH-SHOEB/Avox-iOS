//
//  LocationSearchViewController.swift
//  Avox
//
//  Created by Shoeb on 30/04/25.
//

import UIKit
import MapKit

protocol LocationSearchViewControllerDelegate: NSObjectProtocol {
    func didSelectSearchableLocation(coordinate: CLLocationCoordinate2D)
}

class LocationSearchViewController: UIViewController, SearchBarViewDelegate, UITableViewDelegate, UITableViewDataSource, MKLocalSearchCompleterDelegate {
    
    var deviceManager     : DeviceManager?
    weak var delegate     : LocationSearchViewControllerDelegate?
    
    var searchBarView     : SearchBarView?
    var tableView         : UITableView?
    
    var fontSize          : CGFloat = 0.0
    var constant          : CGFloat = 0.0
    
    var searchModel       = [MKLocalSearchCompletion]()
    var searchCompleter   = MKLocalSearchCompleter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Helper.Color.bgPrimary
        UINavigationBar.appearance().isTranslucent = false
        loadDeviceManager()
        loadSearchView()
        loadTableView()
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
    
    func loadSearchView() {
        searchBarView = SearchBarView(searchHint: "Location...")
        searchBarView!.translatesAutoresizingMaskIntoConstraints = false
        searchBarView!.delegate = self
        self.view.addSubview(searchBarView!)
        NSLayoutConstraint.activate([
            searchBarView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: constant),
            searchBarView!.topAnchor.constraint(equalTo: self.view.topAnchor,constant: constant*3),
            searchBarView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -constant)
        ])
    }
    
    func loadTableView() {
        tableView = UITableView()
        tableView!.translatesAutoresizingMaskIntoConstraints = false
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.separatorStyle = .singleLine
        tableView!.backgroundColor = Helper.Color.bgPrimary
        self.view.addSubview(tableView!)
        NSLayoutConstraint.activate([
            tableView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: constant),
            tableView!.topAnchor.constraint(equalTo: searchBarView!.bottomAnchor, constant: constant),
            tableView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -constant),
            tableView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = searchModel[indexPath.row].title
        cell.detailTextLabel?.text = searchModel[indexPath.row].subtitle
        cell.backgroundColor = Helper.Color.bgPrimary
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchLocarion(completion: searchModel[indexPath.row])
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchModel = completer.results
        tableView!.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error fetching suggestions: \(error.localizedDescription)")
    }
    
    //MARK: SearchBarViewDelegate
    func textDidChange(searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func searchLocarion(completion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else {
                print("No result found.")
                return
            }

            if self.delegate != nil {
                self.delegate?.didSelectSearchableLocation(coordinate: coordinate)
            }
        }
    }
    
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}
