//
//  DetailViewController.swift
//  IvanZrvnarHikingSpots
//
//  Created by Ivan Zrvnar on 2022-04-18.
//

import UIKit
import MapKit

class DetailViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    //MARK: - Outlets
    @IBOutlet var parkText: UITextField!
    @IBOutlet var detailsText: UITextField!
    @IBOutlet var provinceText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    

    
    
    //MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let passedItem = hikingSpot{
            parkText.text = passedItem.park
            provinceText.text = passedItem.province
            detailsText.text = passedItem.details
            // passed item
            if let imageString = passedItem.image {
            cameraImage.image  = hikingSpotStore?.fetchImage(withIdentifier: imageString)
            }
            }
        
        // setting the keyboard to dismiss and adjust depending on contentet selected
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        
        // loading the current location of the user
        locationManager.delegate = self
        mapView.delegate = self
        
        cameraImage.isUserInteractionEnabled = true
  
        
        // using the satilite
        mapView.showsUserLocation = true
        mapView.mapType = .satellite
        // added rounded corner to mapview
        mapView.layer.cornerRadius = 8
        mapView.clipsToBounds = true
        
    
        // getting user location
        guard CLLocationManager.locationServicesEnabled() else { return }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        if locationManager.authorizationStatus == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }else {
            locationManager.startUpdatingLocation()
        }
    
        
        // creating double tap gesture to open the camera
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(cameraDoubleTapped))
        doubleTap.numberOfTapsRequired = 2
        cameraImage.addGestureRecognizer(doubleTap)
        
        //createRegion(atLatitude: currentLocation.coordinate.latitude, atLongitude: currentLocation.coordinate.longitude)
    
        
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
    // show alert for missing info
    func showErrorAlert(withMessage message: String){
        let alert = UIAlertController(title: "Missing Information", message: message , preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        
        present(alert, animated: true)
    }
    
    // adjust keyboard method
    @objc func adjustForKeyboard(notification: Notification){
        //get the user info key to retrieve the keyboard’s frame at the end of its animation.
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        //get the rectangular representation of the keyboard frame
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        //this will match the keyboard frame the view's co-ordinate system - this will handle the situation where the use is in landscape
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        //remember this is being called when two conditions are observed.  If this is a situation where the keyboard is hidingand appearing - first if it is hiding
        if notification.name == UIResponder.keyboardWillHideNotification{
            //set the inset back to nothing
            scrollView.contentInset = .zero
        } else {
            //set the inset to the height of the keyboard - minus the bottom safe area value
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        //without this, the scroll indicator will disappear under the keyboard
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
        
    }
    
        func createRegion(atLatitude lat: Double, atLongitude long: Double){
        let centerPosition = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: centerPosition, latitudinalMeters: 1_000, longitudinalMeters: 1_000)
        mapView.setRegion(region, animated: true)
    }
    
     func locateMe(_ sender: Any) {
       locationManager.requestLocation()
       createRegion(atLatitude: currentLocation.coordinate.latitude, atLongitude: currentLocation.coordinate.longitude)
   }



        

}//: View Controller

//MARK: - Extensions
extension DetailViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        parkText.resignFirstResponder()
        provinceText.resignFirstResponder()
        detailsText.resignFirstResponder()
        return true
    }
}
extension DetailViewController: MKMapViewDelegate{
    
}
extension DetailViewController: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus != .denied || manager.authorizationStatus != .notDetermined {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Updating location....")
        if let lastLocation = locations.last {
            currentLocation = lastLocation
            // getting the map to zoom in on the region
            
            createRegion(atLatitude: currentLocation.coordinate.latitude, atLongitude: currentLocation.coordinate.longitude)
            let annotation = CustomPin(coordinate: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude))
            mapView.addAnnotation(annotation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location - \(error.localizedDescription)")
    }
    
}

    





    



    
