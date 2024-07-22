//
//  MapViewVC.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 10/07/24.
//

import UIKit
import GoogleMaps
import CoreLocation

//class MapViewVC: UIViewController {
//
//    @IBOutlet weak var mapContainerView: UIView!
//    @IBOutlet weak var searchBarTF: UITextField!
//
//    var mapView: GMSMapView!
//    var locationManager: CLLocationManager!
//    var addressDict = [String: String]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let coordinate = CLLocationCoordinate2D(latitude: 30.7333, longitude: 76.7794)
//        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15.0)
//        mapView = GMSMapView()
//        mapView.camera = camera
//        mapView.isMyLocationEnabled = true
//        mapView.settings.myLocationButton = true
//        mapView.frame = self.mapContainerView.frame
//        mapView.delegate = self
//        mapView.animate(to: camera)
//        addMarker(at: coordinate)
//        self.mapContainerView.addSubview(mapView)
//
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        DispatchQueue.global().async {
//            if CLLocationManager.locationServicesEnabled() {
//                self.locationManager.requestWhenInUseAuthorization()
//            }
//        }
//    }
//

//
//}
//
//extension MapViewVC: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15.0)
//            mapView.animate(to: camera)
//            addMarker(at: location.coordinate)
//            manager.stopUpdatingLocation()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedWhenInUse, .authorizedAlways:
//            manager.startUpdatingLocation()
//        default:
//            break
//        }
//    }
//}
//
extension MapViewVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        let newLocation = marker.position
        print("New marker location: \(newLocation.latitude), \(newLocation.longitude)")
        self.getAddressFromLatLon(pdblLatitude: "\(newLocation.latitude)", withLongitude: "\(newLocation.longitude)")
    }

    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        self.addressDict["name"] = pm.name
                        self.addressDict["locality"] = pm.subLocality
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + " "
                        }
                        
                        self.locationManager(CLLocationManager(), didUpdateLocations: [CLLocation(latitude: center.latitude, longitude: center.longitude)])
                        self.addressDict["address"] = addressString
                        self.searchController?.searchBar.text = addressString
                  }
            })

        }
}



import UIKit
import GoogleMaps
import GooglePlaces




class MapViewVC: UIViewController{
    
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var searchBarTF: UITextField!
    
    var addressDict = [String: String]()
    let marker = GMSMarker()
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 105.0, width: 350.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        //view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        // Initialize the location manager.
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        // A default location to use when location permission is not granted.
        let defaultLocation = CLLocation(latitude: 30.7333, longitude: 76.7794)
        
        // Create a map.
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        addMarker(at: defaultLocation.coordinate)
        mapView.gestureRecognizers?.removeAll()
        
        //mapView.translatesAutoresizingMaskIntoConstraints = false
        
        //mapView.topAnchor.constraint(equalTo: view.topAnchor, constant:100)
        //mapView.heightAnchor.constraint(equalToConstant: 600).isActive = true
        //mapView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        mapView.addSubview(subView)
        self.mapContainerView.addSubview(mapView)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.pop(animated: true)
    }
    
    @IBAction func didTapSubmitBtn(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("updateAddress"), object: nil, userInfo: addressDict)
        self.pop(animated: true)
    }
    
    
    
}


// Delegates to handle events for the location manager.
extension MapViewVC: CLLocationManagerDelegate {


  // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      let location: CLLocation = locations.last!
      print("Locationsssssssssssssss have chaaaaannnngggeeeddd: \(location)")

      let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
      let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude,
                                            zoom: zoomLevel)

      if mapView.isHidden {
        mapView.isHidden = false
        mapView.camera = camera
      } else {
        mapView.animate(to: camera)
      }
        addMarker(at: location.coordinate)

    }
    
        func addMarker(at coordinate: CLLocationCoordinate2D) {
            marker.position = coordinate
            marker.isDraggable = true
            marker.map = mapView
        }

    
    // Populate the array with the list of likely places.

  // Handle authorization for the location manager.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // Check accuracy authorization
    let accuracy = manager.accuracyAuthorization
    switch accuracy {
    case .fullAccuracy:
        print("Location accuracy is precise.")
    case .reducedAccuracy:
        print("Location accuracy is not precise.")
    @unknown default:
      fatalError()
    }

    // Handle authorization status
    switch status {
    case .restricted:
      print("Location access was restricted.")
    case .denied:
      print("User denied access to location.")
      // Display the map using the default location.
      mapView.isHidden = false
    case .notDetermined:
      print("Location status not determined.")
    case .authorizedAlways: fallthrough
    case .authorizedWhenInUse:
      print("Location status is OK.")
    @unknown default:
      fatalError()
    }
  }

  // Handle location manager errors.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    print("Error here: \(error)")
  }
    
    
    
}


extension MapViewVC: GMSAutocompleteResultsViewControllerDelegate {
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didAutocompleteWith place: GMSPlace)   {
    searchController?.isActive = false
    // Do something with the selected place.
    print("Place name: \(place.name)")
    print("Place address: \(place.formattedAddress)")
    print("Place attributions: \(place.attributions)")
      print("Place coord: \(place.placeID)")
      addressDict["name"] = place.name
      addressDict["address"] = place.formattedAddress
      searchController?.searchBar.text = place.formattedAddress
      addressDict["locality"] = place.name
      
      func updateLoc(finished: () -> Void) {
          
          locationManager(CLLocationManager(), didUpdateLocations: [CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)])
          finished()
      }
      updateLoc{
          mapView.translatesAutoresizingMaskIntoConstraints = true
          print("EEEEEEEEENNNNNNDDDDDD")
          
      }
        
      
  }

  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didFailAutocompleteWithError error: Error){
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
}
