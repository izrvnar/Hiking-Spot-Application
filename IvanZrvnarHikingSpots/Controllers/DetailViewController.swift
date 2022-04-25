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
    @IBAction func saveButton(_ sender: UIButton) {

        
    }
    
    
    //MARK: - Properties
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var hikingSpot = [HikingSpot]()
    
    
    
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
    
    // save method with a JSON encoder
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(hikingSpot) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "hikingSpot")
        } else {
            print("Failed to save hikingSpot.")
        }
    }
    
    
    
    // getting acsess to the camera on the double tap 
    @objc func cameraDoubleTapped() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
                try? jpegData.write(to: imagePath)
            }
        
        let currentSpot = HikingSpot(image: imageName, dateLabel: "Current Date")
        hikingSpot.append(currentSpot)
        cameraImage.image = image
        save()
        
        // get rid of image selection
        dismiss(animated: true)
        
        
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
        

}//: View Controller

//MARK: - Extensions



    



    
