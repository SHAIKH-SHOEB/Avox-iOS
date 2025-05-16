//
//  ViewLocationViewController.swift
//  Avox
//
//  Created by Nimap on 03/03/24.
//

import UIKit
import MapKit
import CoreLocation

class ViewLocationViewController: UIViewController, MKMapViewDelegate {
    
    var mapView             : MKMapView?
    var cancelButton        : UIButton?
    var baseView            : UIView?
    
    var stackView           : UIStackView?
    var nameLabel           : UILabel?
    var placeLabel          : UILabel?
    
    var imageView           : UIImageView?
    var aboutStackView      : UIStackView?
    
    var airportView         : UIView?
    var airportLabel        : UILabel?
    
    var railwayView         : UIView?
    var railwayLabel        : UILabel?
    
    var cityView            : UIView?
    var cityLabel           : UILabel?
    
    var aboutTileLabel      : UILabel?
    var aboutValueLabel     : UILabel?
    
    var deviceManager       : DeviceManager?
    var suggestionModel     : SuggestionProvider?
    
    var fontSize            : CGFloat = 0.0
    var constant            : CGFloat = 0.0
    var cellHeight          : CGFloat = 0.0
    
    lazy var rightSwipeGestureRecognizer: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe(_:)))
        gesture.direction = .right
        return gesture
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(rightSwipeGestureRecognizer)
        loadDeviceManager()
        loadMap()
        loadBaseView()
        //getAddressFromCoordinates(latitude: 19.30004692992087, longitude: 73.06122406123319)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
    
    func loadMap() {
        mapView = MKMapView()
        mapView!.translatesAutoresizingMaskIntoConstraints = false
        mapView!.delegate = self
        //mapView!.mapType = .satellite
        self.view.addSubview(mapView!)
        NSLayoutConstraint.activate([
            mapView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView!.topAnchor.constraint(equalTo: view.topAnchor),
            mapView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView!.heightAnchor.constraint(equalToConstant: self.view.frame.size.height*0.5)
        ])
        
        cancelButton = UIButton(type: .system)
        cancelButton!.translatesAutoresizingMaskIntoConstraints = false
        cancelButton!.backgroundColor = UIColor.clear
        cancelButton!.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        cancelButton!.tintColor = Helper.Color.appPrimary
        cancelButton!.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        mapView!.addSubview(cancelButton!)
        NSLayoutConstraint.activate([
            cancelButton!.leadingAnchor.constraint(equalTo: mapView!.leadingAnchor, constant: constant*3),
            cancelButton!.topAnchor.constraint(equalTo: mapView!.topAnchor, constant: constant*3)
        ])
        
        // Set initial map region
        let initialLocation = CLLocation(latitude: CLLocationDegrees("\(suggestionModel!.latitude!)")!, longitude: CLLocationDegrees("\(suggestionModel!.longitude!)")!)
        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView!.setRegion(coordinateRegion, animated: true)
        
        // Add an annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees("\(suggestionModel!.latitude!)")!, longitude: CLLocationDegrees("\(suggestionModel!.longitude!)")!)
        annotation.title = AppUtils.localizableString(key: suggestionModel!.title!)
        annotation.subtitle = AppUtils.localizableString(key: suggestionModel!.subTitle!)
        mapView!.addAnnotation(annotation)
    }
    
    // Customize the annotation view if needed
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func loadBaseView() {
        baseView = UIView()
        baseView!.translatesAutoresizingMaskIntoConstraints = false
        baseView!.backgroundColor = Helper.Color.bgPrimary
        applyTopCorners(view: baseView!, cornerRadius: constant*2.5)
        self.view.addSubview(baseView!)
        NSLayoutConstraint.activate([
            baseView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            baseView!.topAnchor.constraint(equalTo: mapView!.bottomAnchor, constant: -constant*3),
            baseView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            baseView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        imageView = UIImageView()
        imageView!.translatesAutoresizingMaskIntoConstraints = false
        imageView!.downloadImage(from: URL(string: "\(suggestionModel!.image!)")!, placeholder: UIImage(named: "Placeholder"))
        imageView!.layer.cornerRadius = constant
        imageView!.layer.masksToBounds = true
        imageView!.contentMode = UIView.ContentMode.scaleAspectFill
        baseView!.addSubview(imageView!)
        NSLayoutConstraint.activate([
            imageView!.topAnchor.constraint(equalTo: baseView!.topAnchor, constant: constant*2),
            imageView!.trailingAnchor.constraint(equalTo: baseView!.trailingAnchor, constant: -constant*2),
            imageView!.heightAnchor.constraint(equalToConstant: cellHeight*1.4),
            imageView!.widthAnchor.constraint(equalToConstant: cellHeight*1.4)
        ])
        
        stackView = UIStackView()
        stackView!.translatesAutoresizingMaskIntoConstraints = false
        stackView!.axis = NSLayoutConstraint.Axis.vertical
        stackView!.distribution = .fillProportionally
        stackView!.spacing = constant
        stackView!.backgroundColor = UIColor.clear
        baseView!.addSubview(stackView!)
        NSLayoutConstraint.activate([
            stackView!.leadingAnchor.constraint(equalTo: baseView!.leadingAnchor, constant: constant*2),
            stackView!.centerYAnchor.constraint(equalTo: imageView!.centerYAnchor),
            stackView!.trailingAnchor.constraint(equalTo: imageView!.leadingAnchor, constant: -constant*0.5)
        ])
        
        nameLabel = UILabel()
        nameLabel!.text = AppUtils.localizableString(key: suggestionModel!.title!)
        nameLabel!.font = UIFont.appFontBold(ofSize: fontSize*1.3)
        nameLabel!.textColor = Helper.Color.textPrimary
        nameLabel!.textAlignment = .left
        stackView!.addArrangedSubview(nameLabel!)
        
        placeLabel = UILabel()
        placeLabel!.text = AppUtils.localizableString(key: suggestionModel!.subTitle!)
        placeLabel!.font = UIFont.appFontLight(ofSize: fontSize)
        placeLabel!.numberOfLines = 0
        placeLabel!.textColor = Helper.Color.textSecondary
        placeLabel!.textAlignment = .left
        stackView!.addArrangedSubview(placeLabel!)
        
        aboutStackView = UIStackView()
        aboutStackView!.translatesAutoresizingMaskIntoConstraints = false
        aboutStackView!.axis = NSLayoutConstraint.Axis.vertical
        aboutStackView!.distribution = .fillProportionally
        aboutStackView!.spacing = constant
        aboutStackView!.backgroundColor = UIColor.clear
        baseView!.addSubview(aboutStackView!)
        NSLayoutConstraint.activate([
            aboutStackView!.leadingAnchor.constraint(equalTo: baseView!.leadingAnchor, constant: constant*2),
            aboutStackView!.topAnchor.constraint(equalTo: imageView!.bottomAnchor, constant: constant*2),
            aboutStackView!.trailingAnchor.constraint(equalTo: baseView!.trailingAnchor, constant: -constant*2)
        ])
        
        airportView = UIView()
        airportView!.translatesAutoresizingMaskIntoConstraints = false
        airportView!.backgroundColor = UIColor.systemRed
        airportView!.layer.cornerRadius = constant
        aboutStackView!.addArrangedSubview(airportView!)
        NSLayoutConstraint.activate([
            airportView!.heightAnchor.constraint(equalToConstant: cellHeight*0.8)
        ])
        
        airportLabel = UILabel()
        airportLabel!.translatesAutoresizingMaskIntoConstraints = false
        airportLabel!.text = AppUtils.localizableString(key: suggestionModel!.airport!)
        airportLabel!.font = UIFont.appFontMedium(ofSize: fontSize*1.1)
        airportLabel!.textColor = Helper.Color.textSecondary
        airportLabel!.textAlignment = .left
        airportView!.addSubview(airportLabel!)
        NSLayoutConstraint.activate([
            airportLabel!.leadingAnchor.constraint(equalTo: airportView!.leadingAnchor, constant: constant),
            airportLabel!.topAnchor.constraint(equalTo: airportView!.topAnchor),
            airportLabel!.trailingAnchor.constraint(equalTo: airportView!.trailingAnchor, constant: -constant),
            airportLabel!.bottomAnchor.constraint(equalTo: airportView!.bottomAnchor)
        ])
        
        railwayView = UIView()
        railwayView!.translatesAutoresizingMaskIntoConstraints = false
        railwayView!.backgroundColor = UIColor.systemOrange
        railwayView!.layer.cornerRadius = constant
        aboutStackView!.addArrangedSubview(railwayView!)
        NSLayoutConstraint.activate([
            railwayView!.heightAnchor.constraint(equalToConstant: cellHeight*0.8)
        ])
        
        railwayLabel = UILabel()
        railwayLabel!.translatesAutoresizingMaskIntoConstraints = false
        railwayLabel!.text = AppUtils.localizableString(key: suggestionModel!.railway!)
        railwayLabel!.font = UIFont.appFontMedium(ofSize: fontSize*1.1)
        railwayLabel!.textColor = Helper.Color.textSecondary
        railwayLabel!.textAlignment = .left
        railwayView!.addSubview(railwayLabel!)
        NSLayoutConstraint.activate([
            railwayLabel!.leadingAnchor.constraint(equalTo: railwayView!.leadingAnchor, constant: constant),
            railwayLabel!.topAnchor.constraint(equalTo: railwayView!.topAnchor),
            railwayLabel!.trailingAnchor.constraint(equalTo: railwayView!.trailingAnchor, constant: -constant),
            railwayLabel!.bottomAnchor.constraint(equalTo: railwayView!.bottomAnchor)
        ])
        
        cityView = UIView()
        cityView!.translatesAutoresizingMaskIntoConstraints = false
        cityView!.backgroundColor = UIColor.systemBlue
        cityView!.layer.cornerRadius = constant
        aboutStackView!.addArrangedSubview(cityView!)
        NSLayoutConstraint.activate([
            cityView!.heightAnchor.constraint(equalToConstant: cellHeight*0.8)
        ])
        
        cityLabel = UILabel()
        cityLabel!.translatesAutoresizingMaskIntoConstraints = false
        cityLabel!.text = AppUtils.localizableString(key: suggestionModel!.city!)
        cityLabel!.font = UIFont.appFontMedium(ofSize: fontSize*1.1)
        cityLabel!.textColor = Helper.Color.textSecondary
        cityLabel!.textAlignment = .left
        cityView!.addSubview(cityLabel!)
        NSLayoutConstraint.activate([
            cityLabel!.leadingAnchor.constraint(equalTo: cityView!.leadingAnchor, constant: constant),
            cityLabel!.topAnchor.constraint(equalTo: cityView!.topAnchor),
            cityLabel!.trailingAnchor.constraint(equalTo: cityView!.trailingAnchor, constant: -constant),
            cityLabel!.bottomAnchor.constraint(equalTo: cityView!.bottomAnchor)
        ])
        
        aboutTileLabel = UILabel()
        aboutTileLabel!.text = AppUtils.localizableString(key: LanguageConstant.about)
        aboutTileLabel!.font = UIFont.appFontBold(ofSize: fontSize*1.3)
        aboutTileLabel!.textColor = Helper.Color.textPrimary
        aboutTileLabel!.textAlignment = .left
        aboutStackView!.addArrangedSubview(aboutTileLabel!)
        
        aboutValueLabel = UILabel()
        aboutValueLabel!.text = AppUtils.localizableString(key: suggestionModel!.about!)
        aboutValueLabel!.numberOfLines = 0
        aboutValueLabel!.font = UIFont.appFontLight(ofSize: fontSize)
        aboutValueLabel!.textColor = Helper.Color.textSecondary
        aboutValueLabel!.textAlignment = .left
        aboutStackView!.addArrangedSubview(aboutValueLabel!)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Apply Corners To View
    func applyTopCorners(view:UIView, cornerRadius: Double = 20.0) {
        let path = UIBezierPath(roundedRect: self.view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.view.bounds
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
    }
    
    @objc func handleRightSwipe(_ gesture: UISwipeGestureRecognizer) {
        // Handle the right swipe here
        if gesture.state == .ended {
            // Perform the pop action or any other action you want
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //For Using This Need To Add This Permission On Info.P File
    //<key>NSLocationWhenInUseUsageDescription</key>
    //<string>We need your location to show relevant information.</string>
    func getAddressFromCoordinates(latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error occurred during reverse geocoding: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemark found")
                return
            }

            // Extract address details
            let addressLines = [
                placemark.name,
                placemark.subLocality,
                placemark.locality,
                placemark.subAdministrativeArea,
                placemark.administrativeArea,
                placemark.postalCode,
                placemark.country
            ].compactMap { $0 }

            let address = addressLines.joined(separator: ", ")
            print("Address: \(address)")
        }
    }
}
