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

   
    //location manager started when user presses device coordinates button
    @IBAction func deviceCoordinates(_ sender: Any) {
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters //sets desired accuracy - use least accurate option needed to function (to conserve resources)
        locationManager.distanceFilter = 100 //indicates the distance in meters the device has to move before an update location event is generated
        locationManager.startUpdatingLocation() //starts the location manager running and updating the location
        locationManager.startUpdatingHeading() //report on changes to heading (compass) information
    }
    
    
    //called when another view moves to the foreground
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    } //location manager stops when view disappears to conserve battery

    
    
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
    
    
    //called whenever location manager updates device location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last { //get most recent location from array
            let eventDate = location.timestamp //get time stamp for location
            let howRecent = eventDate.timeIntervalSinceNow //check time interval between now and then
            if Double(howRecent) < 15.0 { //convert from TimeInterval type to double and check that update time is less that 15sec
                //update ui with refreshed coordinates
                let coordinate = location.coordinate
                lblLongitude.text = String(format: "%g\u{00B0}", coordinate.longitude)
                lblLatitude.text = String(format: "%g\u{00B0}", coordinate.latitude)
                lblLocationAccuracy.text = String(format: "%gm", location.horizontalAccuracy) //get accuracy from radius in meter of circle the device is within
                lblAltitude.text = String(format: "%gm", location.altitude) //altitude in meters above/below sea level
                lblAltitudeAccuracy.text = String(format: "%gm", location.verticalAccuracy) //accuracy in meters to this number

            }
        }
    }
    
    
    
    //call to get heading/compass info for device
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.headingAccuracy > 0 { //check accuracy for validity
            let theHeading = newHeading.trueHeading //specify true heading over magnetic heading
            var direction: String
            switch theHeading { //set compass heading based on heading in degrees
                //less than signs indicate the interval goes from the lower value up to but not including the upper value
            case 225..<315:
                direction = "W"
            case 135..<225:
                direction = "S"
            case 45..<135:
                direction = "E"
            default:
                direction = "N"
            }
            
            //update labels with accuracy and heading info
            lblHeading.text = String(format: "%g\u{00B0} (%@)", theHeading, direction)
            lblHeadingAccuracy.text = String(format: "%g\u{00B0}", newHeading.headingAccuracy) //heading reported as number of degrees off in either direction
        }
    }
    
    
    //location manager error handling
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        //gets raw value (bool) for the denied property, then uses conditional assignment statement to assign one of two literal strings to the errorType variable
        let errorType = error._code == CLError.denied.rawValue ? "Location Permission Denied" : "Unknown Error" //if location services turned off
        
        //creates an alert view with error type as title and raw error msg
        let alertController = UIAlertController(title: "Error Getting Location: \(errorType)", message: "Error Message: \(error.localizedDescription))", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(actionOK)
        
        //displays alert controller
        present(alertController, animated: true, completion: nil)
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






