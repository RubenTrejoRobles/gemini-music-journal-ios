//
//  ReviewController.swift
//  CSE_355_Project
//
//  Created by Ruben on 3/17/26.
//

import Foundation
import PhotosUI
import CoreLocation
import MapKit
import SwiftData
internal import Combine
import SwiftUI

var geminiAPIKey: String {
    guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
          let plist = NSDictionary(contentsOfFile: filePath),
          let value = plist.object(forKey: "GEMINI_API_KEY") as? String else {
        fatalError("Couldn't find api key in Secrets.plist")
    }
    return value
}

class ReviewController: ObservableObject {
    var modelContext: ModelContext?
    @Published var reviews: [Review] = []
    @ObservedObject var locationDataManager: LocationDataManager = LocationDataManager()
    
    
    
    
    
    func setupDatabase(modelContext: ModelContext){
        self.modelContext = modelContext
        
        let descriptor = FetchDescriptor<Review>( sortBy: [SortDescriptor(\.timestamp, order: .reverse)] )

        do {
            let results = try modelContext.fetch(descriptor)
            self.reviews = results
        } catch {
            print("Failed to setup reviews: \(error)")
        }
    }
    
    
    func getTrendingMusic() async -> [TrendingSong]{
        do{
            let urlAsString = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/50/songs.json"
            let url = URL(string: urlAsString)!
            
            let urlSession = URLSession.shared
            let (data, _) = try await urlSession.data(from: url)
             
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(TrendingSongs.self, from: data)
            
            if let songs = decodedData.feed?.results {
                return songs
            }
            else {
                return []
            }
        } catch{
            print(error)
            return []
        }
    }
    
    func searchSongs(searchStr: String) async -> [SongAttributes]{
        guard let encodedSearch = searchStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return []
        }
        
        do{
            let urlAsString = "https://itunes.apple.com/search?term=\(encodedSearch)&limit=100&entity=song"
            let url = URL(string: urlAsString)!
            
            let urlSession = URLSession.shared
            let (data, _) = try await urlSession.data(from: url)
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(SearchResults.self, from: data)
            
            if let songs = decodedData.results{
                return songs
            }
            else {
                return []
            }
        } catch{
            print(error)
            return []
        }
        
    }
    
    func getAIRecommendations() async -> [SongAttributes]{
        // if a call with one model fails try the next one.
        let r1 = await getAIRecommendationsFromModel(model: "gemini-3.1-flash-lite-preview")
        if (r1.1){
            return r1.0
        }
        let r2 = await getAIRecommendationsFromModel(model: "gemini-3-flash-preview")
        if (r2.1){
            return r2.0
        }
        let r3 = await getAIRecommendationsFromModel(model: "gemini-2.5-flash")
        if (r3.1){
            return r3.0
        }
        let r4 = await getAIRecommendationsFromModel(model: "gemini-2.5-flash-lite")
        if (r4.1){
            return r4.0
        }
        
        return []
    }

    func getAIRecommendationsFromModel(model: String) async -> ([SongAttributes], Bool){
        do {
            var prompt: String = "These are my song reviews:\n"
            for r in reviews {
                prompt.append("- \(r.trackName) by \(r.artistName) (\(r.rating)/5 stars) comment: \(r.comment)\n")
            }
            prompt.append("Based on these ratings, recommend 10 new songs I might like. You MUST return ONLY a valid JSON array of objects. Each object must have exactly two keys: trackName and artistName. Do not include markdown.")
            
            //let model = "gemini-3-flash-preview"
            //let model = "gemini-3.1-flash-lite-preview"
            let urlAsString = "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(geminiAPIKey)"
            let url = URL(string: urlAsString)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let myAIRequest = PostBody(contents: [
                Content(parts: [
                    Part(text: prompt)
                ])
            ])

            request.httpBody = try JSONEncoder().encode(myAIRequest)
            
            let urlSession = URLSession.shared
            let (data, _) = try await urlSession.data(for: request)
            
            print("Response: \(String(data: data, encoding: .utf8) ?? "Not Available")")
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(AIResponse.self, from: data)
            
            if let response = decodedData.candidates.first?.content.parts.first?.text {
                print(response)
                let responseData = response.data(using: .utf8)!
                let songRecommendations = try decoder.decode([AISong].self, from: responseData)
                
                var songList: [SongAttributes] = []
                for song in songRecommendations {
                    try? await Task.sleep(for: .seconds(0.5))
                    
                    let searchResults = await searchSongs(searchStr: "\(song.trackName) \(song.artistName)")
                    if let song = searchResults.first{
                        songList.append(song)
                    }
                }
                return (songList, true)
                
            }
            else {
                return ([], false)
            }
            
            
        } catch{
            print(error)
            return ([], false)
        }
        
    }
    
    
    func getSongAttributes(id: String) async -> SongAttributes?{
        do {
            let urlAsString = "https://itunes.apple.com/lookup?id=\(id)"
            let url = URL(string: urlAsString)!
            
            let urlSession = URLSession.shared
            let (data, _) = try await urlSession.data(from: url)
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(SearchResults.self, from: data)
            
            if (Int(decodedData.results?.count ?? 0) > 0){
                return decodedData.results?[0]
            }
            else {
                return nil
            }
        } catch{
            print(error)
            return nil
        }
        
    }
    
    
    
    
    func addReview(song: SongAttributes, rating: Int, comment: String) -> Bool{
        // TODO: update location for getting realtime location of the user later
        switch locationDataManager.locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            if let location = locationDataManager.locationManager.location?.coordinate{
                
                
                let NA = "Not Available"
                let r = Review(trackId: song.trackId ?? 0, artistName: song.artistName ?? NA, trackName:
                                song.trackName ?? NA,
                               previewUrl: song.previewUrl ?? NA, artworkUrl100: song.artworkUrl100 ?? NA,  rating: rating, comment: comment,
                               latitude: location.latitude, longitude: location.longitude)
                
                if let m = modelContext {
                    m.insert(r)
                    reviews.insert(r, at: 0)
                    
                }
                return true
            }
            print("There was an error getting the users location")
            return false
        default:
            print("Location Services are not enabled")
            return false
        }
    }
    
    func updateReview(trackId: Int, rating: Int, comment: String){
        if let r = getReview(trackId: trackId){
            r.rating = rating
            r.comment = comment
        }
    }
    
    func deleteReview(trackId: Int){
        if let m = modelContext{
            for i in 0..<reviews.count {
                if reviews[i].trackId == trackId {
                    let reviewToDelete = reviews[i]
                    m.delete(reviewToDelete)
                    reviews.remove(at: i)
                    return
                }
            }
        }
    }
    
    func getReview(trackId: Int?) -> Review?{
        if let trackId = trackId{
            for review in reviews{
                if review.trackId == trackId{
                    return review
                }
            }
        }
        return nil
    }
    
    func getReview(trackId: String?) -> Review?{
        if let trackId = trackId{
            if let trackId = Int(trackId){
                for review in reviews{
                    if review.trackId == trackId{
                        return review
                    }
                }
            }
        }
        return nil
    }
    
    func deleteAllReviews() {
        if let m = modelContext {
            do {
                try m.delete(model: Review.self)
                reviews.removeAll()
                
                print("Database successfully reset.")
            }
            catch {
                print("Failed to reset database: \(error)")
            }
        }
            
    }
    
    
    
    func getRatingAverage() -> Double{
        if reviews.count == 0 {
            return 0
        }
        
        var reviewTotal: Double = 0
        for review in reviews{
            reviewTotal += Double(review.rating)
        }
        
        return reviewTotal / Double(reviews.count)
    }
    
 
    

}
