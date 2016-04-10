//
//  MapViewController.swift
//  MappedOut
//
//  Created by Quintin Frerichs on 3/10/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import GoogleMaps
import Parse
import CoreLocation
class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    let marker = GMSMarker()
    let searchBar = UISearchBar()
    var camera = GMSCameraPosition.cameraWithLatitude(38.6480,
                                                      longitude: -90.3050, zoom: 17)
    var markerEvents: [CustomData] = []
    var eventMarkers : [GMSMarker] = []
    var manager: CLLocationManager!
    var placesClient: GMSPlacesClient?
    let currentPositionMarker = GMSMarker()
    var currentPositionMarkers: [GMSMarker] = []
    var locationMarker: GMSMarker!
    var mapEvents: [Event]?
    var isLocation: Bool = false
    var filteredData: [Event] = []
    var users: [User]?
    let user = User()
    var myMapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Event.getNearbyEvents(CLLocation(latitude: 38.6480, longitude: -90.3050), orderBy: "updatedAt") { (events: [Event]) in
            self.mapEvents = events
            self.populate()
        }
//        Event.getEventsbyIDs(user.eventsInvitedTo!, orderBy: "updatedAt") { (events: [Event]) in
//            self.mapEvents = events
//            self.populate()
//        }
       // User.getNearbyUsers(CLLocation(latitude: 38.6480, longitude: -90.3050)) { (users: [User]) in
            //self.users = users
       // }
        var recognizer = UITapGestureRecognizer(target: self, action: Selector("didTap:"))
        self.tableView.addGestureRecognizer(recognizer)
        self.searchBar.delegate = self
        self.searchBar.sizeToFit()
        self.searchBar.frame.size.width = self.view.frame.size.width
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.sizeToFit()
        self.tableView.frame.size.width = self.view.frame.size.width
        manager = CLLocationManager()
        manager.delegate = self
        self.manager.requestAlwaysAuthorization()

        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()

        
        myMapView = GMSMapView()
        myMapView.delegate = self
        
        
        myMapView.camera = camera
        myMapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-30)
        self.view.addSubview(myMapView)
        
        self.view.addSubview(self.searchBar)
        self.view.addSubview(tableView)
        tableView.hidden = true
//        manager = CLLocationManager()
//        manager.delegate = self
//        self.manager.requestWhenInUseAuthorization()
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.startUpdatingLocation()
        let schoolPosition = CLLocationCoordinate2D(latitude: 38.6480, longitude: -90.3050)
        marker.position = schoolPosition
        marker.title = "Washington University in St. Louis"
        marker.snippet = "Click for Event info"
        marker.map = myMapView
        marker.icon = UIImage(named: "marker")
        
        
        myMapView.settings.compassButton = true
        myMapView.settings.myLocationButton = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setLocationTrue", name: "isLocationNotificationTrue" , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setLocationFalse", name: "isLocationNotificationFalse", object: nil)
    }
    func setLocationTrue(){
        isLocation = true
        myMapView.myLocationEnabled = true
    }
    func setLocationFalse(){
        isLocation = false
        myMapView.myLocationEnabled = false
    }
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            myMapView.myLocationEnabled = true
        }
    }
  
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let newLocation = locations.last
        self.view = self.view
        //self.view = self.myMapView
        //        if users != nil{
        //            var i = 0
        //            for (_, user) in users!.enumerate(){
        //                markerEvents.append(CustomData(mapEvent: nil, markerUser: user))
        //                currentPositionMarkers.append( GMSMarker(position: CLLocationCoordinate2DMake(newLocation!.coordinate.latitude, newLocation!.coordinate.longitude)))
        //                currentPositionMarkers[i].title = user.username
        //                currentPositionMarkers[i].icon = UIImage(named: "userdot")
        //                currentPositionMarkers[i].snippet = "Long Press for Info"
        //                currentPositionMarkers[i].map = myMapView
        //                i = i+1
        //            }
        //        }
        //else{
        if myMapView.myLocationEnabled{
        currentPositionMarker.position = CLLocationCoordinate2DMake(newLocation!.coordinate.latitude, newLocation!.coordinate.longitude)
        currentPositionMarker.title = "Quintin Frerichs"
        if user.username != nil{
        currentPositionMarker.userData = user 
        currentPositionMarker.title = "\(user.username)"
        }
        
        currentPositionMarker.icon = UIImage(named: "userdot")
        currentPositionMarker.snippet = "Long Press For Info"
        currentPositionMarker.map = myMapView
        }
        //}
        
        
    }
    func populate(){
        if mapEvents != nil{
            var i = 0
            for (_, event) in mapEvents!.enumerate(){
                markerEvents.append( CustomData(mapEvent: event, markerUser: nil))
                eventMarkers.append(GMSMarker(position: CLLocationCoordinate2DMake(event.location!.coordinate.latitude, event.location!.coordinate.longitude)))
                eventMarkers[i].title = event.name
                eventMarkers[i].userData = markerEvents[i]
                eventMarkers[i].icon = UIImage(named:"marker")
                eventMarkers[i].map = myMapView
                i = i+1
            }
        }
    }
    func didTap(recognizer: UIGestureRecognizer){
        print(recognizer)
        if recognizer.state == UIGestureRecognizerState.Ended{
            let tapLocation = recognizer.locationInView(self.tableView)
            if let tappedIndexPath = tableView.indexPathForRowAtPoint(tapLocation) {
                if let tappedCell = self.tableView.cellForRowAtIndexPath(tappedIndexPath) {
                    
                    let eventOfInterest = filteredData[tappedIndexPath.row]
                    if(eventOfInterest.location != nil){
                        let locationOfEvent = CLLocationCoordinate2DMake(eventOfInterest.location!.coordinate.latitude, eventOfInterest.location!.coordinate.longitude)
                        camera = GMSCameraPosition.cameraWithLatitude(locationOfEvent.latitude, longitude: locationOfEvent.longitude, zoom: 17)
                        myMapView.camera = camera
                        tableView.hidden = true
                        searchBar.showsCancelButton = false
                        searchBar.text = ""
                        searchBar.resignFirstResponder()
                    }
                }
            }
        }
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar){
        
        self.searchBar.showsCancelButton = true
        self.tableView.hidden = false
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        tableView.hidden = true
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredData = mapEvents!
        } else {
            filteredData = mapEvents!.filter({(dataItem: Event) -> Bool in
                if (dataItem.name)!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) as! TableCell
        cell.eventNameLabel.text = filteredData[indexPath.row].name
        
        return cell
    }
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker){
        
        self.performSegueWithIdentifier("EventSegue", sender: marker)
    }
    func mapView(mapView: GMSMapView, didLongPressInfoWindowOfMarker: GMSMarker){
        self.performSegueWithIdentifier("UserSegue", sender: marker)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let marker = sender as? GMSMarker{
            if segue.identifier == "EventSegue"{
                let destination = segue.destinationViewController as! MapDetailsViewController
                if(marker.userData != nil){
                    let e = (marker.userData as! CustomData).mapEvent
                    destination.event = e
                }
            }
            else if segue.identifier == "UserSegue"{
                print("user segue")
                let destination = segue.destinationViewController as! UserDetailsViewController
                if (marker.userData != nil){
                    let u = (marker.userData as! CustomData).markerUser
                    print("\(u!.username)")
                    destination.user  = u
                }
                
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

