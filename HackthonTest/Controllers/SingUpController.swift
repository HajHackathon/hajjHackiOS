//
//  LogInViewController.swift
//  HackthonTest
//
//  Created by Qahtan on 8/1/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class LogInViewController: UIViewController {

    
    var loaction:CLLocation?
    var coordinate = [Double]()
    let userNameTv : UITextField = {
        
        let tv = UITextField()
        tv.borderStyle = .roundedRect
        tv.placeholder = "Enter user name here "
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    let emailTv : UITextField = {
        
        let tv = UITextField()
        tv.borderStyle = .roundedRect
        tv.placeholder = "Exampl@gmail.com"
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    let passwordTV : UITextField = {
        
        let tv = UITextField()
        tv.borderStyle = .roundedRect
        tv.isSecureTextEntry = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    let singInButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(hendleUserLogin), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 33, green: 156, blue: 234, alpha: 1.0)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        catchUserLaction()
    }
    func catchUserLaction(){
        let locationManager = CLLocationManager()
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            loaction = locationManager.location
            print("loactionloactionloaction", loaction)
        }
    }
    func setupViews(){
        view.backgroundColor = .gray
        view.addSubview(userNameTv)
        view.addSubview(emailTv)
        view.addSubview(passwordTV)
        view.addSubview(singInButton)
        
        let stackView = UIStackView(arrangedSubviews: [emailTv,userNameTv,passwordTV,singInButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 200).isActive = true

    }
    @objc func hendleUserLogin() {
        print("12233333")
        guard let username = userNameTv.text, username.characters.count > 0 else { return}
        guard let email = emailTv.text ,email.characters.count > 0  else { return}
        guard let pass = passwordTV.text ,pass.characters.count > 0  else { return}
        // #############
//        guard let loaction = [loaction?.altitude.]loaction else { return}
        Auth.auth().createUser(withEmail: email, password: pass) { (authResult, error) in
            if let err = error {
                print("field to sing in user ",err)
                return
            }
            print("Successfuly Create a user",authResult?.user.uid)
            
///----------- Save User To database
            guard let uid = authResult?.user.uid else { return}
            /// Catch the fire geo loaction
            ////------    location
            self.coordinate.append(Double(self.loaction?.coordinate.latitude ?? 0))
            self.coordinate.append(Double(self.loaction?.coordinate.longitude ?? 0))
            let dictionaryValues = ["username":username,"location": self.coordinate] as [String : Any]
            let values = [uid : dictionaryValues]
            print("Successfuly Create a user",values)
            Database.database().reference().child("paramedic").updateChildValues(values, withCompletionBlock: { (error, reff) in
                if let er = error {
                    print("Failed to save user info to db", error)
                    return
                }
                print("Sussccfly Save value to db")
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
}
extension LogInViewController:CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        print("location",userLocation)
        
    }
}

