//  Copyright © 2020 Saqib Saud. All rights reserved.

import UIKit
import MapKit
import CoreLocation
import Contacts

protocol HomePresenter: AlertDisplayable{
    func loadRemark(annotations: [Remark])
}

class HomeViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate, HomePresenter {
    @IBOutlet private weak var mapView: MKMapView!
    private var searchController: UISearchController!

    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        return locationManager
    }()
    
    // MARK: - Injected Properties
    
    lazy var viewModel = HomeViewModel(viewController: self)
    var coordinator: HomeCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
                
        locationManager.startUpdatingLocation()
        searchController = UISearchController()
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self, action: #selector(didTapAddRemark))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapLogout))
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "RemarkAnnotation")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.viewWillAppear()
    }
    
    // MARK: - LocationManager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)

            viewModel.didUpdateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(forError: error)
    }
    
    func loadRemark(annotations: [Remark]) {
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
        }
    }
    
    // MARK: - SearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBarDidSearch(text: searchText)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.searchBarDidSearch(text: "")
    }
    
    // MARK: - MapView Delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Remark else { return nil }

        let identifier = "RemarkAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            
        } else {
            annotationView!.annotation = annotation
        }
        
        if let markerAnnotationView = annotationView as? MKMarkerAnnotationView {
            markerAnnotationView.animatesWhenAdded = true
            markerAnnotationView.canShowCallout = true
            markerAnnotationView.markerTintColor = .blue
            let rightButton = UIButton(type: .detailDisclosure)
            markerAnnotationView.rightCalloutAccessoryView = rightButton
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        guard let remark = view.annotation as? Remark else {
            return
        }
        
        coordinator?.presentShowRemark(remark.note)
    }
    
    // MARK: - Actions
    
    @objc func didTapAddRemark() {
        coordinator?.presentAddRemark()
    }
    
    @objc func didTapLogout() {
        coordinator?.logout()
    }
}
