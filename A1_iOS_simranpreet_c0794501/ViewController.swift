//
//  ViewController.swift
//  A1_iOS_simranpreet_c0794501
//
//  Created by simranPreet KAur on 26/01/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var map: MKMapView!

    var aName: CLLocationCoordinate2D!
    var bName : CLLocationCoordinate2D!
    var cName: CLLocationCoordinate2D!
    
    
    var places = [PLACES]()
    var x = 0
    var locationManager = CLLocationManager() // variable of location manager
    
    var destination = CLLocationCoordinate2D()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        map.delegate = self
        map.showsUserLocation = true
        
        button.isHidden = true
        
        locationManager.delegate = self  // creating delegate prperty
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  // accuracy of the location
        
        
        locationManager.requestWhenInUseAuthorization()  // REQUEST FOR THE PREMISSION TO ACCESS LOCATION
        
        
        locationManager.startUpdatingLocation()   // start updating the location
        
        
        addDoubleTapGesture()
        
        
     //   addPolygon ()
       
    }
    
    
    @IBAction func router(_ sender: UIButton)
    {
        
    directionRouter(source: aName, destination: bName)
    directionRouter(source: bName, destination: cName)
    directionRouter(source: cName, destination: aName)
        
        
    }
        func directionRouter(source:CLLocationCoordinate2D,destination:CLLocationCoordinate2D)
        {
        map.removeOverlays(map.overlays)
        let sourcePlaceMark = MKPlacemark(coordinate: source)
        
        let destinationPlaceMark = MKPlacemark(coordinate: destination)
        
        // request direction
        let directionRequest = MKDirections.Request()
        
        // assign the source and destination properties of they request
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        
        // transportation type
        directionRequest.transportType = .automobile
        
        // calculate the direction
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard  let directionResponse = response else {return}
            
            // create the route
            let route = directionResponse.routes[0] // array
            
            // drawing polyline
            self.map.addOverlay(route.polyline, level: .aboveRoads)
            
            // define bounding map rect
            let rect = route.polyline.boundingMapRect
            
            // visibility of the maprect
            
           self.map.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
            
         //   self.map.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        
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
            aName = coordination
            places.append(PLACES(title:annotation.title, coordinate:annotation.coordinate))
        map.addAnnotation(annotation)
        }
        else if x == 2
        {
        annotation.title = "B"
        annotation.coordinate = coordination
            bName = coordination
            places.append(PLACES(title:annotation.title, coordinate:annotation.coordinate))
        map.addAnnotation(annotation)
        }
        else if x == 3
        {
        annotation.title = "C"
        annotation.coordinate = coordination
            cName = coordination
            places.append(PLACES(title:annotation.title, coordinate:annotation.coordinate))
        map.addAnnotation(annotation)
            addPolygon()
            button.isHidden = false
        }
        else if x == 4
        {
            
            places.removeAll()
            map.removeAnnotations(map.annotations)
            map.removeOverlays(map.overlays)
            x=0
            button.isHidden = true
        }
        
        destination = coordination
      //  button.isHidden = true
    }


    // DID update location method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        displayLoaction(latitude: latitude, longitude: longitude, title: "you are here", subtitle: "")
        
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
        
     let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "hlo")
        marker.tintColor = UIColor.blue
        return marker
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
        
        else if overlay is MKPolyline
        {
            let rendrer = MKPolylineRenderer(overlay: overlay)
            rendrer.lineWidth = 3
            rendrer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            return rendrer 
        }
         return MKOverlayRenderer()
    }
}
