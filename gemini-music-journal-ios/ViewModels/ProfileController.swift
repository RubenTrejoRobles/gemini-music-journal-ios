//
//  ProfileController.swift
//  CSE_355_Project
//
//  Created by Ruben on 3/17/26.
//

import Foundation
import PhotosUI
import CoreLocation
import MapKit
import SwiftData
import CoreLocation
internal import Combine
import SwiftUI


class ProfileController: ObservableObject {
    var modelContext: ModelContext?
    @Published var userProfile: UserProfile?

    
    func setupDatabase(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        let descriptor = FetchDescriptor<UserProfile>()
        do {
            let results = try modelContext.fetch(descriptor)
            self.userProfile = results.first
        } catch {
            print("Failed to setup profile: \(error)")
        }
    }
    
    
    
    func setProfile(username: String, favoriteGenre: String, profilePicture: Data){
        if let p = userProfile{
            p.username = username
            p.favoriteGenre = favoriteGenre
            p.profilePicture = profilePicture
        }
        else{
            userProfile = UserProfile(username: username, favoriteGenre: favoriteGenre, profilePicture: profilePicture)
            modelContext!.insert(userProfile!)
        }
    }
    
    func deleteProfile(){
        if let m = modelContext{
            if let u = userProfile{
                m.delete(u)
                self.userProfile = nil
            }
        }
    }
    
}
