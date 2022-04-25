//
//  DetailViewController.swift
//  IvanZrvnarHikingSpots
//
//  Created by Ivan Zrvnar on 2022-04-18.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    //MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cameraImage: UIImageView!
    
    
    //MARK: - Properties
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // loading the current location of the user
        locationManager.delegate = self
        mapView.delegate = self
        
        cameraImage.isUserInteractionEnabled = true
  
        
        // using the satilite
        mapView.showsUserLocation = true
        mapView.mapType = .satellite
        
        guard CLLocationManager.locationServicesEnabled() else { return }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        if locationManager.authorizationStatus == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }else {
            locationManager.stopUpdatingLocation()
        }
        
        // creating double tap gesture to open the camera
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(cameraDoubleTapped))
        doubleTap.numberOfTapsRequired = 2
        cameraImage.addGestureRecognizer(doubleTap)
        
    
        
    }//: View did load
    
    //MARK: -Methods
    // getting acsess to the camera on the double tap 
    @objc func cameraDoubleTapped() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
        

}//: View Controller

//MARK: - Extensions



    



    
