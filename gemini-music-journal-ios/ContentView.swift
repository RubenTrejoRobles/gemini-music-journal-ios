//
//  ContentView.swift
//  CSE_355_Project
//
//  Created by Ruben on 3/16/26.
//

import SwiftUI
import SwiftData
import _PhotosUI_SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @StateObject var reviewController: ReviewController = ReviewController()
    @StateObject var profileController: ProfileController = ProfileController()
    @State var selectedTab: Int = 0
    
    @State var trendingSongs: [TrendingSong] = []
    @State var favoriteGenreSongs: [SongAttributes] = []
    
    @State var searchResults:[SongAttributes] = []
    @State var searchStrHome: String = ""
    @State var searchFromHome: Bool = false
    @State var searchStrSearch: String = ""
    @State var searchFromSearch: Bool = false
    @State var noResults: Bool = false
    
    var body: some View {
        
        Group{
            //CreateProfile()
            if profileController.userProfile != nil{
                TabView(selection: $selectedTab){
                    
                    HomePage(reviewController: reviewController, profileController: profileController,
                             trendingSongs: $trendingSongs, searchStr: $searchStrHome, searchTrigger: $searchFromHome, favoriteGenreSongs: $favoriteGenreSongs)
                    .tag(0)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    
                    SearchPage(reviewController: reviewController, profileController: profileController, searchStr: $searchStrSearch, searchTrigger: $searchFromSearch, searchResults: $searchResults, noResults: $noResults)
                        .tag(1)
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                    AIRecommendationsPage(reviewController: reviewController, profileController: profileController)
                        .tag(2)
                        .tabItem{
                            Label("Discover", systemImage: "sparkles")
                        }
                    
                    ReviewHistory(reviewController: reviewController, profileController: profileController)
                        .tag(3)
                        .tabItem {
                            Label("My Reviews", systemImage: "rectangle.stack")
                        }
                    
                    ProfilePage(reviewController: reviewController, profileController: profileController, selectedTab: $selectedTab)
                    .tag(4)
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                }
            }
            else {
                CreateProfile(profileController: profileController) 
            }
        }
        .task {
            reviewController.setupDatabase(modelContext: modelContext)
            profileController.setupDatabase(modelContext: modelContext)
            
            if let p = profileController.userProfile {
                trendingSongs = await reviewController.getTrendingMusic()
                favoriteGenreSongs = await reviewController.searchSongs(searchStr: p.favoriteGenre)
            }
        }
        .onChange(of: profileController.userProfile){ profileOld, profileNew in
            Task{
                if let profile = profileNew {
                    trendingSongs = await reviewController.getTrendingMusic()
                    favoriteGenreSongs = await reviewController.searchSongs(searchStr: profile.favoriteGenre)
                }
            }
        }
        .onChange(of: profileController.userProfile?.favoriteGenre){ genreOld, genreNew in
            Task{
                if let genre = genreNew {
                    favoriteGenreSongs = await reviewController.searchSongs(searchStr: genre)
                }
            }
        }
        .onChange(of: searchFromHome){_, _ in
            Task{
                searchResults = []
                searchResults = await reviewController.searchSongs(searchStr: searchStrHome)
                selectedTab = 1
                
                noResults = searchResults.isEmpty
                
                searchStrSearch = searchStrHome
                searchStrHome = ""
            }
            
        }
        .onChange(of: searchFromSearch){_, _ in
            Task{
                searchResults = []
                searchResults = await reviewController.searchSongs(searchStr: searchStrSearch)
                
                noResults = searchResults.isEmpty
            }
        }
    }
}







        


#Preview {
    ContentView()
        .modelContainer(for: [Review.self, UserProfile.self], inMemory: true)
}
