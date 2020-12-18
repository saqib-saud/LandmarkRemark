//  Copyright © 2020 Saqib Saud. All rights reserved.

import UIKit
import MapKit
import CoreLocation
import Contacts

class HomeViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate {
    @IBOutlet private weak var mapView: MKMapView!
    private var searchController: UISearchController!

//    private var locationManager: CLLocationManager?
    
    // MARK: - Injected Properties
    
    lazy var viewModel = HomeViewModel(viewController: self)
    var coordinator: HomeCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewDidLoad()
        
        searchController = UISearchController()
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self, action: #selector(didTapAddRemark))
        
//        let initialLocation = CLLocation(latitude: 21.4765, longitude: -157.9647)
//        centerToLocation(initialLocation)
        
        let oahuCenter = CLLocation(latitude: 21.4765, longitude: -157.9647)
        let region = MKCoordinateRegion(
          center: oahuCenter.coordinate,
          latitudinalMeters: 50000,
          longitudinalMeters: 60000)
//        mapView.setCameraBoundary(
//          MKMapView.CameraBoundary(coordinateRegion: region),
//          animated: true)
        
//        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
//        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        mapView.delegate = self

        mapView.register(RemarkView.self, forAnnotationViewWithReuseIdentifier: "RemarkAnnotation")
        
        let artwork = Remark(
          userName: "King David Kalakaua",
          remark: "Waikiki Gateway Park",
          coordinate: CLLocationCoordinate2D(latitude: 21.4765, longitude: -157.9647))
        mapView.addAnnotation(artwork)
        
        
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        locationManager?.requestAlwaysAuthorization()
        

    }
    
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
      let coordinateRegion = MKCoordinateRegion(
        center: location.coordinate,
        latitudinalMeters: regionRadius,
        longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - LocationManager Delegate
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last{
//            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//            self.mapView.setRegion(region, animated: true)
//        }
//    }
    func loadRemark(annotations: [Remark]) {
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
//            self.centerToLocation(CLLocation(latitude: annotations[0].coordinate.latitude, longitude: annotations[0].coordinate.longitude))
        }
    }
    
    // MARK: - SearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBarDidSearch(text: searchText)
//      searchFor(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//      resultsTableViewController.countries = nil
    }
    
    // MARK: - MapView Delegate
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//      guard let annotation = annotation as? Remark else {
//        return nil
//      }
//
//      let identifier = "RemarkAnnotation"
//      var view: MKAnnotationView
//
//      if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? RemarkView {
//        dequeuedView.annotation = annotation
//        view = dequeuedView
//      } else {
//        view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//        view.canShowCallout = true
//        view.calloutOffset = CGPoint(x: -5, y: 5)
//        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//      }
//      return view
//    }
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        guard let artwork = view.annotation as? Remark else {
            return
        }
        
        //      let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        //      artwork.mapItem?.openInMaps(launchOptions: launchOptions)
    }
    
    // MARK: - Action
    
    @objc func didTapAddRemark() {
        coordinator?.presentAddRemark()
    }
}
