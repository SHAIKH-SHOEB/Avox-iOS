//
//  LocationViewController.swift
//  Avox
//
//  Created by Shoeb on 20/04/25.
//

import UIKit
import MapKit

protocol LocationViewControllerDelegate: NSObjectProtocol {
    func didPickLocationAsString(location: String)
}

class LocationViewController: UIViewController, CLLocationManagerDelegate, LocationSearchViewControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    weak var delegate   : LocationViewControllerDelegate?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLocationManager()
        openBotttomSheet()
    }
    
    func loadLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressedOnMap(_:)))
        longPressGesture.minimumPressDuration = 1 // 1 seconds press
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func longPressedOnMap(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            // Get the CGPoint on screen
            let touchPoint = gestureRecognizer.location(in: mapView)
            // Convert CGPoint to CLLocationCoordinate2D
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            convertAddressFromCoordinate(coordinate: coordinate)
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation() // Optional: stop after getting current
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error)")
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss keyboard
        if let searchText = searchBar.text {
            searchForLocation(named: searchText)
        }
    }

    func searchForLocation(named name: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = name
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] (response, error) in
            guard let self = self else { return }

            if let coordinate = response?.mapItems.first?.placemark.coordinate {
                // Move map to the location
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                self.mapView.setRegion(region, animated: true)
                
                // Add pin
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = name
                self.mapView.addAnnotation(annotation)
            } else {
                print("Location not found")
            }
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func openBotttomSheet() {
        if presentedViewController == nil {
            let vc = LocationSearchViewController()
            vc.delegate = self
            if let sheet = vc.sheetPresentationController {
                // Custom detent at 200 points
                if #available(iOS 16.0, *) {
                    let customDetent = UISheetPresentationController.Detent.custom(identifier: .init("custom100")) { context in
                        return 100
                    }
                    sheet.detents = [customDetent ,.medium()]
                } else {
                    // Fallback on earlier versions
                }
                
                sheet.selectedDetentIdentifier = .init("custom100")
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 20
                
                // Prevent dismissal
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.largestUndimmedDetentIdentifier = .init("custom100")
                //sheet.largestUndimmedDetentIdentifier = .medium
            }
            
            // Prevent swipe down and tap outside to dismiss
            vc.isModalInPresentation = true
            
            self.present(vc, animated: true)
        }
    }
    
    //MARK: LocationSearchViewControllerDelegate
    func didSelectSearchableLocation(coordinate: CLLocationCoordinate2D) {
        convertAddressFromCoordinate(coordinate: coordinate)
        self.navigationController?.dismiss(animated: true)
    }
    
    func convertAddressFromCoordinate(coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
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
            if self.delegate != nil {
                self.delegate?.didPickLocationAsString(location: address)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
