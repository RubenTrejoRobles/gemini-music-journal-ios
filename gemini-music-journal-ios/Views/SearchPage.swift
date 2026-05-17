//
//  SearchPage.swift
//  CSE_335_Project
//
//  Created by Ruben on 3/26/26.
//

import SwiftUI
import SwiftData
import _PhotosUI_SwiftUI

struct SearchPage: View {
    
    @ObservedObject var reviewController: ReviewController
    @ObservedObject var profileController: ProfileController
    @Binding var searchStr: String
    @Binding var searchTrigger: Bool
    
    @Binding var searchResults: [SongAttributes]
    @Binding var noResults: Bool
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Search for a song", text: $searchStr)
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    
                    Button("Search"){
                        searchTrigger.toggle()
                    }
                }
                .padding(.horizontal)
                
                if(noResults){
                    Spacer()
                    Text("No Results")
                    Spacer()
                }
                else{
                    List {
                        ForEach(searchResults, id: \.trackId){song in
                            NavigationLink{SongDetails(
                                reviewController: reviewController,
                                profileController: profileController,
                                songReview: reviewController.getReview(trackId: song.trackId),
                                song: song
                            )} label: {
                                HStack{
                                    let imageLink = song.artworkUrl100
                                    AsyncImage(url: URL(string: imageLink ?? "")){ image in
                                        image
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(10)
                                    }
                                    placeholder: {
                                        
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                    }
                                    
                                    VStack(alignment: .leading){
                                        Text(song.trackName ?? "")
                                            .font(.headline)
                                            .lineLimit(1)
                                        
                                        
                                        Text(song.artistName ?? "")
                                            .font(.headline)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(1)
                                        
                                    }
                                }
                            }
                        }
                        
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
                
                
                
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
}

/*
 #Preview {
 let profileController = ProfileController()
 
 let profile = UserProfile(
 username: "Ruben_Test",
 favoriteGenre: "Hip-Hop",
 profilePicture: (UIImage(named: "DefaultProfilePicture")?.pngData())!)
 
 profileController.userProfile = profile
 
 return SearchPage(
 reviewController: ReviewController(),
 profileController: profileController,
 searchStr: "Kanye West"
 )
 .modelContainer(for: [Review.self, UserProfile.self], inMemory: true)
 }
 */
