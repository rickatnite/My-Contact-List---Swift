//
//  LocationDemoViewController.swift
//  My Contact List
//
//  Created by E Roche on 4/24/22.
//

import UIKit
import CoreLocation

class LocationDemoViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblLocationAccuracy: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblHeadingAccuracy: UILabel!
    @IBOutlet weak var lblAltitude: UILabel!
    @IBOutlet weak var lblAltitudeAccuracy: UILabel!
    
    lazy var geoCoder = CLGeocoder()
    var locationManager: CLLocationManager!

    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    //uses the geoCoder object to send a simple string representation of the address to a web service
    //then handles the results of the search asynchronously and displays the best location in the labels on the screen
    @IBAction func addressToCoordinates(_ sender: Any) {
        let address = "\(txtStreet.text!), \(txtCity.text!), \(txtState.text!)"
        geoCoder.geocodeAddressString(address) {(placemarks, error) in self.processAddressResponse(withPlacemarks: placemarks, error:error)}
    } //sends the string to Apple service via internet and results come back in an array of CLPlacemark objects
    
    private func processAddressResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Geocode Error: \(error)") //check for error in geocoding and print to console
        }
        else {
            var bestMatch: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 { //checks for results - allows for only assigning a value to placemarks if the conditions on the right side of the equal sign result in non-nil or true - use loop for multiple results
                bestMatch = placemarks.first?.location //assigns the location of the first placemark to bestMatch
            }
            if let coordinate = bestMatch?.coordinate { //use optional binding to get the coordinate portion of the bestMatch location
                lblLatitude.text = String(format: "%g\u{00B0}", coordinate.latitude) //Unicode for degree symbol
                lblLongitude.text = String(format: "%g\u{00B0}", coordinate.longitude) //placeholder %g formats decimal to six digits
            }
            else {
                print("Didn't find any matching locations")
            }
        }
    }

   
    
    @IBAction func deviceCoordinates(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //location manager setup
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // ask for permission to use location - must match permission req in plist
    }
    
    //called when location permission status changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        //check for what the permission was changed to
        if status == .authorizedWhenInUse {
            print("Permission granted")
        }
        else {
            print("Permission NOT granted")
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






