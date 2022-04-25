//
//  MapViewController.swift
//  My Contact List
//
//  Created by E Roche on 4/3/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var locationManager: CLLocationManager!
    
    @IBOutlet weak var mapView: MKMapView!
    
    //use find me button for user tracking - zooms to user location on click
    @IBAction func findUser(_ sender: Any) {
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        var span = MKCoordinateSpan() //span indicates how many degrees are visible on map to specify zoom level
        span.latitudeDelta = 0.2 //lower span numbers allow more zooming in
        span.longitudeDelta = 0.2 //decimals are needed for street level views
        
        let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, span: span) //uses span settings for zoom
        mapView.setRegion(viewRegion, animated: true) //sets region based on location/span in previous line
        
        //sets up MapPoint object with user location and literal strings for title/subtitle
        let mp = MapPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        mp.title = "You"
        mp.subtitle = "are here"
        mapView.addAnnotation(mp) //adds annotations to map
        
        //alternative zoom approach which sets the view region to 5000m on either side of the user location
        //zooms similarly to other appraoch, but you can specify the zoom level of the map
        //disables the ability to zoom and pan the map when the device is being moved bc the method is called anytime the user location changes
        //let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 5000, 5000)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mapView.setUserTrackingMode(.follow, animated: true) //zooms to user location when map is displayed - too simplistic for this app
        
        mapView.delegate = self

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
