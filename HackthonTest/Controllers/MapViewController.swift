//
//  ViewController.swift
//  HackthonTest
//
//  Created by Qahtan on 8/1/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
class MapViewController: UIViewController {

    var hajji: Hajji?
    var locationManager = CLLocationManager()
    var mapView = GMSMapView()
    var shortestRouet = [Double]()
    var allRoutes = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")


        let camera = GMSCameraPosition.camera(withLatitude: 21.616758, longitude: 39.155844, zoom: 14)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        mapView.mapType = .satellite
        //create a marker
        let currentLocation = CLLocationCoordinate2DMake((hajji?.loction[0])!, (hajji?.loction[1])!)

        createAMarker(lat: currentLocation.latitude, lng: currentLocation.longitude, title: "Help me")
        let src = CLLocationCoordinate2DMake(21.616758, 39.155844)
        
        draw(src: src, dst: currentLocation)
        addHosptelsLocation()
        
//        addHosptelsLocation()
    }
    func createAMarker(lat:Double,lng:Double,title:String) {
        let location = CLLocationCoordinate2DMake(lat, lng)
        let marker = GMSMarker(position: location)
        marker.title = title
        marker.map = mapView
    }
    @objc func handleLogout(){
        do{
            try Auth.auth().signOut()
            let nav = UINavigationController(rootViewController: LogInViewController())
            nav.isNavigationBarHidden = true
            self.present(nav, animated: true, completion: nil)
        } catch let singOutErr {
            print("Failed to sing out", singOutErr)
        }
    }
    func addHosptelsLocation(){
        guard let path  = Bundle.main.path(forResource: "arrafat_coordinate", ofType: "json") else { return}
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            guard let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [Any] else{ return}
            for i in jsonResult {
                guard let ii = i as? [String:Any] else {return}
                let hosptil = Hospital(name: ii["title"] as! String ,lat: ii["lat"] as! Double, lng: ii["lng"] as! Double, snapit: ii["snippet"] as! String)
                createAMarker(lat: hosptil.lat, lng: hosptil.lng, title: hosptil.name)
            }
        } catch {
            // handle error
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWillApper")
    }
    func fetchDataFromDataBase(){
        /// Fetch all the data under the node
        Database.database().reference().child("paramedic").observe(.value, with: { (snapshot) in
            print("snapShot",snapshot)
        }) { (eror) in
            print("Field to fitch data from database ",eror)
        }
//        Database.database().reference().child("paramedic").observeEvent(of: .value, with: { (snapShot) in
//            print("snap",snapShot.key)
//        }) { (error) in
//
//        }
    }
    func drawTheShortestRoute(routs:[[String:Any]],values:[Double]) {
    }
    func draw(src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(src.latitude),\(src.longitude)&destination=\(dst.latitude),\(dst.longitude)&sensor=false&mode=driving")!

        let request = URLSession.shared.dataTask(with: url) { (data, res, erorr) in
            if let err = erorr {
                print("field request",err)
            }
            do {
                let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                let routes = parsedData["routes"] as? [Any]
                
                let overview_polyline = routes?[0] as?[String:Any]
                let optionsObject = overview_polyline!["legs"] as? [Any]
                let opt = optionsObject![0] as? [String:Any]
                let op =  opt!["steps"] as? [Any]
                
                for o in  op! {
                    let oo = o as? [String:Any] /// THE ROUTE DETIELS
                    
                    let valueToComper = oo!["distance"] as? [String:Any]
                    let value = valueToComper!["value"] as? Double
                    self.allRoutes.append(oo!)
                    self.shortestRouet.append(value!)
                    
                }
                let polyString = overview_polyline?["overview_polyline"] as?[String:Any]
                let points = polyString!["points"] as? String
                
                DispatchQueue.main.async(execute: {
                    let path = GMSPath(fromEncodedPath: points!)
                    let polyline = GMSPolyline(path: path)
                    polyline.strokeWidth = 5.0
                    polyline.strokeColor = UIColor.blue
                    
                    // TRY to change the camera
                    self.mapView.camera = GMSCameraPosition.camera(withLatitude: src.latitude, longitude: src.longitude, zoom: 16)
                    polyline.map = self.mapView
                })
                
            } catch let error as NSError {
                print(error)
            }
        }
        request.resume()
    }
    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapView // Your map view
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 10, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
