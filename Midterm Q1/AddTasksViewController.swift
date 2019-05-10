import UIKit
import CoreLocation
import MapKit

class AddTasksViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {    
    let latDelta: CLLocationDegrees = 0.05
    let lonDelta: CLLocationDegrees = 0.05
    
    @IBOutlet weak var map: MKMapView!
    
    var userLocation: CLLocation!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        map.addGestureRecognizer(longTapGesture)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0]
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        
        self.map.setRegion(region, animated: false)
        
        locationManager.stopUpdatingLocation()
    }
    
    @objc func longTap(sender: UIGestureRecognizer){
        if sender.state == .began {
            let locationInView = sender.location(in: map)
            let locationOnMap = map.convert(locationInView, toCoordinateFrom: map)
            let newLocation = CLLocation(latitude: locationOnMap.latitude, longitude: locationOnMap.longitude)
            
            CLGeocoder().reverseGeocodeLocation(newLocation){(placemarks, error) in
                if error != nil {
                    print(error!)
                } // if
                else {
                    if let placemark = placemarks?[0] {
                        var subThoroughfare = "";
                        if placemark.subThoroughfare != nil {
                            subThoroughfare = placemark.subThoroughfare!
                        }
                        
                        var thoroughfare = ""
                        if placemark.thoroughfare != nil {
                            thoroughfare = placemark.thoroughfare!
                        }
                        
                        var subLocality = ""
                        if placemark.subLocality != nil {
                            subLocality = placemark.subLocality!
                        }
                        
                        var subAdministrativeArea = ""
                        if placemark.subAdministrativeArea != nil {
                            subAdministrativeArea = placemark.subAdministrativeArea!
                        }
                        
                        var postalCode = ""
                        if placemark.postalCode != nil {
                            postalCode = placemark.postalCode!
                        }
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = newLocation.coordinate
                        let address = subThoroughfare + " " + thoroughfare + " " + subLocality + ", " + subAdministrativeArea + " " + postalCode
                        annotation.title = address
                        self.map.addAnnotation(annotation)
                        
                        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                            let toSaveLoc = PLACES(entity: PLACES.entity(), insertInto: context)
                            toSaveLoc.address = address
                            toSaveLoc.lat = newLocation.coordinate.latitude
                            toSaveLoc.lng = newLocation.coordinate.longitude
                            try? context.save()
                        } // if let
                    } // if let
                } // else
            } //end GLGeocoder
        }
    }
}//AddViewCon
