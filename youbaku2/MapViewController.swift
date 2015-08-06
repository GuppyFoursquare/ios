//
//  MapViewController.swift
//  Feed Me
//
//  Created by Ron Kliffer on 8/30/14.
//  Copyright (c) 2014 Ron Kliffer. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, TypesTableViewControllerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
    
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
  var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
  var places = [Place]()
  
  let locationManager = CLLocationManager()
  let dataProvider = GoogleDataProvider()
  
  var randomLineColor: UIColor {
    get {
      let randomRed = CGFloat(drand48())
      let randomGreen = CGFloat(drand48())
      let randomBlue = CGFloat(drand48())
      return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
  }
  
  var mapRadius: Double {
    get {
      let region = mapView.projection.visibleRegion()
      let verticalDistance = GMSGeometryDistance(region.farLeft, region.nearLeft)
      let horizontalDistance = GMSGeometryDistance(region.farLeft, region.farRight)
      return max(horizontalDistance, verticalDistance)*0.5
    }
  }

  func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
    mapView.clear()
    request(YouNetworking.Router.NearbyPlaces("\(coordinate.latitude)", "\(coordinate.longitude)")).responseJSON() {
        (_, _, JSON, error) in
        if error == nil {
            // 4
            println(JSON as! NSDictionary)
                // 5, 6, 7
            if let js = (JSON as! NSDictionary).valueForKey("content") as? [NSDictionary]{
                let placeInfos = ((JSON as! NSDictionary).valueForKey("content") as! [NSDictionary]).map { Place( id: $0["plc_id"] as! String, name: $0["plc_name"] as! String, image: $0["plc_header_image"], address: $0["plc_address"] as! String, rating: $0["plc_address"] as! String, lat:$0["plc_latitude"] as! String, long:$0["plc_longitude"] as! String ) }
            
                let lastItem = self.places.count
                self.places = placeInfos
                
                let indexPaths = (lastItem..<self.places.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                
                for place:Place in self.places{
                    let marker = PlaceMarker(place: place)
                    marker.map = self.mapView
                }
            
            }
        }else{
            let alertController = UIAlertController(title: "Error", message:
                NSLocalizedString("empty_result", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }


/*
    // 1
    mapView.clear()
    // 2
    dataProvider.fetchPlacesNearCoordinate(coordinate, radius:mapRadius, types: searchedTypes) { places in
      for place: GooglePlace in places {
        // 3
        let marker = PlaceMarker(place: place)
        // 4
        marker.map = self.mapView
      }
    }
*/
  }
  
  @IBAction func refreshPlaces(sender: AnyObject) {
    //fetchNearbyPlaces(mapView.camera.target)
  }
  
  @IBAction func mapTypeSegmentPressed(sender: AnyObject) {
    let segmentedControl = sender as! UISegmentedControl
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      mapView.mapType = kGMSTypeNormal
    case 1:
      mapView.mapType = kGMSTypeSatellite
    case 2:
      mapView.mapType = kGMSTypeHybrid
    default:
      mapView.mapType = mapView.mapType
    }
    
  }
    
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        let placeMarker = marker as! PlaceMarker
        
        // 2
        if let infoView = UIView.viewFromNibName("MarkerInfoView2") as? MarkerInfoView {
            // 3
            infoView.nameLabel.text = placeMarker.place.plc_name as String
            
            // 4
            var photo = placeMarker.place.plc_header_image
            if(photo != ""){
                infoView.placePhoto.image = UIImage(named: "18.jpg")
            } else {
                infoView.placePhoto.image = UIImage(named: "generic")
            }
            
            return infoView
        } else {
            return nil
        }
    }
  /*
  func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
    // 1
    let placeMarker = marker as! PlaceMarker
    
    // 2
    if let infoView = UIView.viewFromNibName("MarkerInfoView2") as? MarkerInfoView {
      // 3
      infoView.nameLabel.text = placeMarker.place.plc_name as String
      
      // 4
      var photo = placeMarker.place.plc_header_image
      if(photo != ""){
        infoView.placePhoto.image = UIImage(named: "18.jpg")
      } else {
        infoView.placePhoto.image = UIImage(named: "generic")
      }
      
      return infoView
    } else {
      return nil
    }
  }
  */
  // 1
      func updateLocation(){
        locationManager.startUpdatingLocation()
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
  
  func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
    //mapCenterPinImage.fadeOut(0.25)
    return false
  }
  
  // 5
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    if let location = locations.first as? CLLocation {
      // 6
      mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
      
      // 7
      locationManager.stopUpdatingLocation()
      fetchNearbyPlaces(location.coordinate)
    }
  }
    
    

  
  func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
    /*
    let geocoder = GMSGeocoder()
    geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
      
      //Add this line
      self.addressLabel.unlock()
      if let address = response?.firstResult() {
        let lines = address.lines as! [String]
        self.addressLabel.text = join("\n", lines)
        
        let labelHeight = self.addressLabel.intrinsicContentSize().height
        self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
        UIView.animateWithDuration(0.25) {
          self.pinImageVerticalConstraint.constant = ((labelHeight - self.topLayoutGuide.length) * 0.5)
          self.view.layoutIfNeeded()
        }
      }
    }
*/
  }
  
  func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {

    let googleMarker = mapView.selectedMarker as! PlaceMarker
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("RestaurantViewController") as! RestaurantViewController
    vc.restId = String(googleMarker.place.plc_id)
    self.navigationController?.pushViewController(vc, animated: true)
    
    /*
// 1
    let googleMarker = mapView.selectedMarker as! PlaceMarker
    
    // 2
    println(mapView.myLocation)
    dataProvider.fetchDirectionsFrom(mapView.myLocation.coordinate, to: googleMarker.place.coordinate!) {optionalRoute in
      if let encodedRoute = optionalRoute {
        // 3
        let path = GMSPath(fromEncodedPath: encodedRoute)
        let line = GMSPolyline(path: path)
        
        // 4
        line.strokeWidth = 4.0
        line.tappable = true
        line.map = self.mapView
        line.strokeColor = self.randomLineColor
        
        // 5
        mapView.selectedMarker = nil
      }
    }
*/
  }
  
  func mapView(mapView: GMSMapView!, willMove gesture: Bool) {
    //addressLabel.lock()
    if (gesture) {
     // mapCenterPinImage.fadeIn(0.25)
      mapView.selectedMarker = nil
    }
  }
  
  func didTapMyLocationButtonForMapView(mapView: GMSMapView!) -> Bool {
    //mapCenterPinImage.fadeIn(0.25)
    mapView.selectedMarker = nil
    return false
  }
  
  func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
    reverseGeocodeCoordinate(position.target)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.rightBarButtonItem = nil
    navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    mapView.delegate = self
    
    mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: 40.381661, longitude: 49.866281), zoom: 12, bearing: 0, viewingAngle: 0)
  }
    
    override func viewDidAppear(animated: Bool) {
        updateLocation()
    }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "Types Segue" {
      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = segue.destinationViewController.topViewController as! TypesTableViewController
      controller.selectedTypes = searchedTypes
      controller.delegate = self
    }
  }
  
  // MARK: - Types Controller Delegate
  func typesController(controller: TypesTableViewController, didSelectTypes types: [String]) {
    searchedTypes = sorted(controller.selectedTypes)
    dismissViewControllerAnimated(true, completion: nil)
    updateLocation()
    //fetchNearbyPlaces(mapView.camera.target)
  }
}

