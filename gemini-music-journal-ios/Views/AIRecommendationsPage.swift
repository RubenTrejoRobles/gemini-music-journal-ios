//
//  SongRecomendations.swift
//  CSE_335_Project
//
//  Created by Ruben on 4/10/26.
//

import SwiftUI
import SwiftData
import _PhotosUI_SwiftUI

struct AIRecommendationsPage: View {
    
    @ObservedObject var reviewController: ReviewController
    @ObservedObject var profileController: ProfileController
    
    @State var songRecommendations: [SongAttributes] = []
    
    @State var loading = false
    @State var noResults = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    VStack{
                        Text("Get AI Powered Recommendations")
                            .font(.system(size: 40, weight: .bold, design: .default))
                            .padding(.horizontal)

                        
                        
                        
                        Button{
                            Task{
                                
                                loading = true
                                noResults = false
                                await songRecommendations = reviewController.getAIRecommendations()
                                loading = false
                                
                                if songRecommendations.isEmpty {
                                    noResults = true
                                }
                                
                            }
                        }label: {
                            HStack() {
                                Image(systemName: "star.fill")
                                    .font(.title2)
                                    .padding(.leading, -10)
                                    .padding(.trailing, 5)
                                
                                Text("Get Song Recommendations based on your previous reviews")
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                
                            }
                            
                                .foregroundStyle(.white)
                                .frame(maxWidth: 325)
                                .padding()
                                .background(LinearGradient(colors: [Color.blue, Color.purple],
                                                           startPoint: .topLeading,
                                                           endPoint: .bottomTrailing
                                ))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .disabled(loading)
                        
                        
                        
                    }
                    .padding(.bottom, -5)
                    
                    
                    
                    if (loading){
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    else if (noResults){
                        Spacer()
                        Text("No Results")
                        Text("Gemini API services may be temporarily unavailable")
                        Text("or you may have hit the rate limits")
                        Text("Try again later")
                        Spacer()
                    }
                    else {
                        List{
                            ForEach(songRecommendations, id: \.trackId){ song in
                                
                                VStack(alignment: .leading){
                                    
                                    HStack{
                                        let imageLink = song.artworkUrl100
                                        AsyncImage(url: URL(string: imageLink ?? "")){ image in
                                            image
                                                .resizable()
                                                .frame(width: 60, height: 60)
                                                .cornerRadius(10)
                                        }
                                        placeholder: {
                                            
                                            ProgressView()
                                                .frame(width: 50, height: 50)
                                        }
                                        
                                        VStack(alignment: .leading){
                                            Text(song.trackName ?? "Not Available")
                                                .font(.title2)
                                                .fontWeight(.semibold)
                                                .lineLimit(1)
                                            
                                            
                                            Text(song.artistName ?? "Not Available")
                                                .font(.title3)
                                            
                                                .fontWeight(.regular)
                                                .lineLimit(1)
                                            
                                        }
                                        
                                        Spacer()
                                        
                                        
                                    }
                                    .padding(-8)
                                    
                                    
                                }
                                .background{
                                    NavigationLink("", destination: SongDetails(
                                        reviewController: reviewController,
                                        profileController: profileController,
                                        songReview: reviewController.getReview(trackId: song.trackId),
                                        song: song
                                    ))
                                    .opacity(0)
                                    
                                }
                                
                                
                            }
                            
                        }
                        
                        .scrollContentBackground(.hidden)
                        .listRowSpacing(10)
                        
                    }
                }
                
                
            }
        }
        
    }
}
