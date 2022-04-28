//
//  HikingSpot.swift
//  IvanZrvnarHikingSpots
//
//  Created by Ivan Zrvnar on 2022-04-25.
//

import Foundation

enum Section: Int {
    case main
}



class HikingSpot: Hashable, Codable{
    var image: String?
    var dateLabel: Date
    var park: String
    var province: String
    var details: String
    
    init(image: String?, dateLabel: Date, park: String, province: String, details: String){
        self.image = image
        self.dateLabel = dateLabel
        self.park = park
        self.province = province
        self.details = details
    }
    
    
    
    static func == (lhs: HikingSpot, rhs: HikingSpot) -> Bool {
        return lhs.image == rhs.image && lhs.dateLabel == rhs.dateLabel && lhs.park == rhs.park && lhs.province == rhs.province && lhs.details == rhs.details
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(dateLabel)
        hasher.combine(park)
        hasher.combine(province)
        hasher.combine(details)
    }


    
    
    
}

