//
//  MapViewController.swift
//  My Contact List
//
//  Created by E Roche on 4/3/22.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    var locationManager: CLLocationManager!
    var contacts:[Contact] = []

    //use find me button for user tracking - zooms to user locations on click
    @IBAction func findUser(_ sender: Any) {
        mapView.showAnnotations(mapView.annotations, animated: true) //cant use in viewWillAppear because it is called before geocoding is completed
        //mapView.showsUserLocation = true
        //mapView.setUserTrackingMode(.follow, animated: true)
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        //get contacts from core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        var fetchedObjects: [NSManagedObject] = []
        
        do {
            fetchedObjects = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        contacts = fetchedObjects as! [Contact] //converts from NSManagedObject array to Contact object array
        
        //remove all annotations - ensures that if a contact has been removed or changed the annotation is placed correctly
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        //removes all but the last annotation added - include or no?
//        if let mp = self.mapView.annotations.last {
//        mapView.removeAnnotations(self.mapView.annotations)
//        mapView.addAnnotation(mp)
//        }
        
        //loop to go through all contacts
        for contact in contacts {
            let address = "\(contact.streetAddress!), \(contact.city!), \(contact.state!)"
            
            //geocodes address and passes handling to processAddressResponse
            let geoCoder = CLGeocoder() //must be inside loop or it will only look up first contact - ok that new object is created each time through the loop
            geoCoder.geocodeAddressString(address) { (placemarks, error) in self.processAddressResponse(contact, withPlacemarks: placemarks, error: error) }
            
        }
    }
    
    //processes results of geocoding - includes original contact and geocoding results
    private func processAddressResponse(_ contact: Contact, withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Geocode Error: \(error)")
        }
        else {
            var bestMatch: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                bestMatch = placemarks.first?.location
            }
            
            //adds annotations to the map with name and address of each contact
            if let coordinate = bestMatch?.coordinate {
                let mp = MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
                mp.title = contact.contactName
                mp.subtitle = contact.streetAddress
                mapView.addAnnotation(mp)
            }
            else {
                print("Didn't find any matching locations")
            }
        }
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
