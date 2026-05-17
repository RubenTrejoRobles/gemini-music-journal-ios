//
//  HomePage.swift
//  CSE_335_Project
//
//  Created by Ruben on 3/24/26.
//

import SwiftUI
import SwiftData
import _PhotosUI_SwiftUI

struct HomePage: View {
    @ObservedObject var reviewController: ReviewController
    @ObservedObject var profileController: ProfileController
    @Binding var trendingSongs: [TrendingSong]
    @Binding var searchStr: String
    @Binding var searchTrigger: Bool
    
    @Binding var favoriteGenreSongs: [SongAttributes]
    
    var body: some View {
        NavigationStack {
            
            // Search Bar
            HStack{
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search for a song", text: $searchStr)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                
                Button {
                    searchTrigger.toggle()
                } label: {
                    Text("Search")
                }
                
                
            }
            .padding(.horizontal)
            
            VStack{
                Text("Trending Songs")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(trendingSongs, id: \.id){song in
                            NavigationLink{SongDetails(
                                reviewController: reviewController,
                                profileController: profileController,
                                songReview: reviewController.getReview(trackId: song.id),
                                songId: song.id
                            )} label: {
                                VStack{
                                    let imageLink = song.artworkUrl100
                                    AsyncImage(url: URL(string: imageLink ?? "")){ image in
                                        image
                                            .resizable()
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(20)
                                    }
                                    placeholder: {
                                        ProgressView()
                                            .frame(width: 150, height: 150)
                                    }
                                    
                                    
                                    Text(song.artistName ?? "")
                                        .font(.headline)
                                        .lineLimit(1)
                                        .frame(width: 150, alignment: .leading)
                                    
                                    Text(song.name ?? "")
                                        .font(.headline)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                        .frame(width: 150, alignment: .leading)
                                }
                                
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    
                }
            }
            .padding(.vertical)
            
            Spacer()
            VStack{
                
                Text("Songs In Your Favorite Genre")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                List {
                    ForEach(favoriteGenreSongs, id: \.trackId){song in
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
                                    Text(song.artistName ?? "")
                                        .font(.headline)
                                        .lineLimit(1)
                                    
                                    
                                    Text(song.trackName ?? "")
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
    }
}

/*
#Preview {
    @Previewable @State var trendingSongs: [TrendingSong] = []
    @Previewable @State var favoriteGenreSongs: [SongAttributes] = []
    
    let profileController = ProfileController()
    let reviewController = ReviewController() 
        
    
    
        let profile = UserProfile(
            username: "Ruben_Test",
            favoriteGenre: "Hip-Hop",
            profilePicture: (UIImage(named: "DefaultProfilePicture")?.pngData())!)
            
    profileController.userProfile = profile
    
    Task{
        if let p = profileController.userProfile {
            trendingSongs = await reviewController.getTrendingMusic()
            favoriteGenreSongs = await reviewController.searchSongs(searchStr: p.favoriteGenre)
        }
    }
    
    return HomePage(
        reviewController: reviewController,
        profileController: profileController,
        trendingSongs: $trendingSongs, favoriteGenreSongs: $favoriteGenreSongs
    )
    .modelContainer(for: [Review.self, UserProfile.self], inMemory: true)
}
*/
 
