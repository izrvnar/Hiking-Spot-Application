//
//  HikingSpotStore.swift
//  IvanZrvnarHikingSpots
//
//  Created by Ivan Zrvnar on 2022-04-26.
//

import Foundation
import UIKit
class HikingSpotStore{
    var allHikingSpots = [HikingSpot]()
    
    var documentLibrary: URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        print(paths[0])
        
        return paths[0]
    }
    //method to add hiking spot
    func addHikingSpot(spot: HikingSpot){
        allHikingSpots.append(spot)
        saveSpot()
    }
    
    //MARK: - Save and load Methods 
    
    // method to save hiking spot
    func saveSpot(){
        if let fileLocation = documentLibrary?.appendingPathComponent("hikingSpots.json"){
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                
                let jsonData = try encoder.encode(allHikingSpots)
                
                try jsonData.write(to: fileLocation)
            } catch {
                print("Error - could not save: \(error.localizedDescription)")
            }
        }
        
    }//: saveSpot
    
    // method to load hiking spot
    func loadSpot(){
        if let fileLocation = documentLibrary?.appendingPathComponent("hikingSpots.json"){
            do{
                let jsonData = try Data(contentsOf: fileLocation)
                
                let decoder = JSONDecoder()
                allHikingSpots = try decoder.decode([HikingSpot].self, from: jsonData)
            }catch {
                print("Unable to load the JSON - \(error.localizedDescription)")
            }
        }
        
    }//: loadSpot
    
    //MARK: - Image Methods
    // fetch image
    func fetchImage(withIdentifier id: String) -> UIImage?{
        if let imagePath = documentLibrary?.appendingPathComponent(id), let imageFromDisk = UIImage(contentsOfFile: imagePath.path){
            return imageFromDisk
    }
        return nil
}
    
    func saveImage(image: UIImage, withIdentifier id: String){
        if let imagePath = documentLibrary?.appendingPathComponent(id){
            if let data = image.jpegData(compressionQuality: 0.8){
                do {
                    try data.write(to: imagePath)
                } catch {
                    print("Error saving the image - \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    
    
        
}//: Hiking Spot Store


