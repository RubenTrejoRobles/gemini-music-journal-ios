//
//  UserProfile.swift
//  CSE_355_Project
//
//  Created by Ruben on 3/17/26.
//


import SwiftData
import Foundation
import CoreLocation
import UIKit


@Model
class UserProfile {
    var username: String
    var favoriteGenre: String
    var profilePicture: Data
    var image: UIImage? { return UIImage(data: profilePicture) }
    
    init(username: String, favoriteGenre: String, profilePicture: Data) {
            self.username = username
            self.favoriteGenre = favoriteGenre
            self.profilePicture = profilePicture
        }
}
