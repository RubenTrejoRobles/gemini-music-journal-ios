//
//  MusicReview.swift
//  CSE_355_Project
//
//  Created by Ruben on 3/17/26.
//


import SwiftData
import Foundation
import CoreLocation


@Model
class Review {
    
    var id: UUID = UUID()
    var trackId: Int
    var artistName: String
    var trackName: String
    var previewUrl: String
    var artworkUrl100: String
    
    var rating: Int
    var comment: String
    var latitude: Double
    var longitude: Double
    var timestamp: Date = Date()
    
    var coordinate: CLLocationCoordinate2D {   CLLocationCoordinate2D(latitude: latitude, longitude: longitude)   }
    
    init(trackId: Int, artistName: String, trackName: String, previewUrl: String, artworkUrl100: String, rating: Int, comment: String, latitude: Double, longitude: Double){
        self.trackId = trackId
        self.artistName = artistName
        self.trackName = trackName
        self.previewUrl = previewUrl
        self.artworkUrl100 = artworkUrl100
        self.rating = rating
        self.comment = comment
        self.latitude = latitude
        self.longitude = longitude
    }
}

