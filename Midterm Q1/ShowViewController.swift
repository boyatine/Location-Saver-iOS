import UIKit
import MapKit

class ShowViewController: UIViewController, MKMapViewDelegate {
    
    var previousVC = MyTableViewController()
    var location = -1
    
    let latDelta: CLLocationDegrees = 0.05
    let lonDelta: CLLocationDegrees = 0.05
    
    @IBOutlet var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let place = previousVC.placesList[location]
        let userLocation = CLLocation(latitude: place.lat, longitude: place.lng)
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        
        self.map.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocation.coordinate
        annotation.title = place.address
        self.map.addAnnotation(annotation)
    }
}
