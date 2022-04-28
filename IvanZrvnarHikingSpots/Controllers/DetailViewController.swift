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
    @IBOutlet var parkText: UITextField!
    @IBOutlet var detailsText: UITextField!
    @IBOutlet var provinceText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cameraImage: UIImageView!
    
    //MARK: - Properties
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var hikingSpot : HikingSpot!
    var hikingSpotStore : HikingSpotStore?
    var date = Date()
    
    //MARK: - Actions
    @IBAction func saveButton(_ sender: UIButton) {
    // ensuring valid park province and details
        
        guard let park = parkText.text, !park.isEmpty else{
            showErrorAlert(withMessage: "Please Enter a Park Name")
            return
        }
        
        guard let province = provinceText.text, !province.isEmpty else {
            showErrorAlert(withMessage: "Please enter a Province")
            return
        }
        
        guard let details = detailsText.text, !details.isEmpty else{
            showErrorAlert(withMessage: "Please Enter Details ")
            return
        }
        
        if let passedItem = hikingSpot{
            passedItem.park = park
            passedItem.province = province
            passedItem.details = details
            passedItem.dateLabel = date         
            
            //update the image
            if let image = cameraImage.image{
                if let hikingImage = passedItem.image{
                    hikingSpotStore?.saveImage(image: image, withIdentifier: hikingImage)
                } else{
                    let hikingImage = UUID().uuidString
                    passedItem.image = hikingImage
                    hikingSpotStore?.saveImage(image: image, withIdentifier: hikingImage)
                }
            }
            
            hikingSpotStore?.saveSpot()
        } else {
            // creating a new hiking spot
            let newSpot = HikingSpot(image: nil, dateLabel: date, park: park, province: province, details: details)
            
            if let image = cameraImage.image{
                let hikingImage = UUID().uuidString
                newSpot.image = hikingImage
                hikingSpotStore?.saveImage(image: image, withIdentifier: hikingImage)
            }
            
            hikingSpotStore?.addHikingSpot(spot: newSpot)
          
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let passedItem = hikingSpot{
            parkText.text = passedItem.park
            provinceText.text = passedItem.province
            detailsText.text = passedItem.details

            
            
        }
        
        
        
        
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
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        cameraImage.image = image
        
        navigationController?.dismiss(animated: true)

    }
    
    func showErrorAlert(withMessage message: String){
        let alert = UIAlertController(title: "Missing Information", message: message , preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        
        present(alert, animated: true)
    }
    
        

}//: View Controller

//MARK: - Extensions



    



    
