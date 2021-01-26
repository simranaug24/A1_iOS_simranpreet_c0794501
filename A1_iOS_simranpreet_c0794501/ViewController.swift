//
//  ViewController.swift
//  A1_iOS_simranpreet_c0794501
//
//  Created by simranPreet KAur on 26/01/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate{

    
    @IBOutlet weak var map: MKMapView!

    var places = [PLACES]()
    var x = 0
    var locationManager = CLLocationManager() // variable of location manager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        map.showsUserLocation = true
        
        locationManager.delegate = self  // creating delegate prperty
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  // accuracy of the location
        
        
        locationManager.requestWhenInUseAuthorization()  // REQUEST FOR THE PREMISSION TO ACCESS LOCATION
        
        
        locationManager.startUpdatingLocation()   // start updating the location
        
        
        addDoubleTapGesture()
        
        
     //   addPolygon ()
       
    }
    
    
    //POLYGON METHOD
    func addPolygon()
    {
        
        let coordinates = places.map{$0.coordinate}
        let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
        map.addOverlay(polygon)
    }
    
    
    
    // DOUBLE TAP GESTURE
    func addDoubleTapGesture ()
    {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(PIN))
        doubleTapGesture.numberOfTapsRequired = 2
        
        map.addGestureRecognizer(doubleTapGesture)
    }
    
    // adding PIN function
    
    @objc func PIN (sender: UITapGestureRecognizer)
    {
        
        let touchPoint = sender.location(in: map)
        let coordination = map.convert(touchPoint, toCoordinateFrom: map)
        let annotation = MKPointAnnotation()
       x += 1
         
        if x == 1
        {
        annotation.title = "A"
        annotation.coordinate = coordination
            places.append(PLACES(title:annotation.title, coordinate:annotation.coordinate))
        map.addAnnotation(annotation)
        }
        else if x == 2
        {
        annotation.title = "B"
        annotation.coordinate = coordination
            places.append(PLACES(title:annotation.title, coordinate:annotation.coordinate))
        map.addAnnotation(annotation)
        }
        else if x == 3
        {
        annotation.title = "C"
        annotation.coordinate = coordination
            places.append(PLACES(title:annotation.title, coordinate:annotation.coordinate))
        map.addAnnotation(annotation)
            addPolygon()
        }
        else if x == 4
        {
            
            places.removeAll()
            map.removeAnnotation(annotation)
            x==0
        }
        
    }


    // DID update location method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
    }
    func displayLoaction(latitude:CLLocationDegrees,
                         longitude:CLLocationDegrees,
                         title:String,
                         subtitle:String)
    {
        
        // define span
    let  latDelta: CLLocationDegrees = 0.05
    let lngDelta: CLLocationDegrees = 0.05
        
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta,
                                    longitudeDelta: lngDelta)
        
        // step 3 define location
        let location = CLLocationCoordinate2D(latitude: latitude,
        longitude: longitude)
        
        
        
        // step 4  define the region
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        // step 5  set the region
        
        map.setRegion(region, animated: true)
        
        // step 6 add annotation
        
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subtitle
        annotation.coordinate = location
        map.addAnnotation(annotation)
        
    }
}


extension ViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation
        {
            return nil
        }
        
    return nil
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolygon
        {
            let rendrer = MKPolygonRenderer(overlay: overlay)
            rendrer.fillColor = UIColor.red.withAlphaComponent(0.5)
            rendrer.strokeColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            rendrer.lineWidth = 4
            
            return rendrer
        }
         return MKOverlayRenderer()
    }
}
