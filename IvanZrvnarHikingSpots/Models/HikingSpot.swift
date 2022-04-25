//
//  HikingSpot.swift
//  IvanZrvnarHikingSpots
//
//  Created by Ivan Zrvnar on 2022-04-25.
//

import Foundation
class HikingSpot: Hashable, Codable{
    // conforming to hashable protocol
    static func == (lhs: HikingSpot, rhs: HikingSpot) -> Bool {
        return lhs.image == rhs.image && lhs.dateLabel == rhs.dateLabel
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(dateLabel)
    }
    
    var image: String
    var dateLabel: String
    
    init(image: String, dateLabel: String){
        self.image = image
        self.dateLabel = dateLabel
    }
    
    
}
