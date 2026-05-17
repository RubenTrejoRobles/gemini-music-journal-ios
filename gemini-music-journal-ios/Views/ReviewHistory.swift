//
//  ReviewHistory.swift
//  CSE_335_Project
//
//  Created by Ruben on 4/3/26.
//

import SwiftUI
import SwiftData
import _PhotosUI_SwiftUI

struct ReviewHistory: View {
    
    @ObservedObject var reviewController: ReviewController
    @ObservedObject var profileController: ProfileController
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    HStack{
                        Text("My Reviews")
                            .font(.system(size: 40, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        NavigationLink("Map View", destination: ReviewsMapView(reviewController: reviewController,
                                                                               profileController: profileController))
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(.blue)
                        .cornerRadius(25)
                        .padding(.horizontal)
                        .shadow(color: .black.opacity(0.3), radius: 5)
                        .disabled(reviewController.reviews.isEmpty)
                        
                    }
                    .padding(.bottom, -5)
                    
                    
                    if (reviewController.reviews.isEmpty){
                        Spacer()
                        Text("No Reviews Yet")
                        Spacer()
                    }
                    else{
                        
                        List{
                            ForEach(reviewController.reviews, id: \.trackId){ review in
                                
                                VStack(alignment: .leading){
                                    
                                    HStack{
                                        let imageLink = review.artworkUrl100
                                        AsyncImage(url: URL(string: imageLink)){ image in
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
                                            Text(review.trackName )
                                                .font(.title2)
                                                .fontWeight(.semibold)
                                                .lineLimit(1)
                                            
                                            
                                            Text(review.artistName )
                                                .font(.title3)
                                            
                                                .fontWeight(.regular)
                                                .lineLimit(1)
                                            
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing){
                                            Text(review.timestamp.formatted(date: .abbreviated, time: .omitted).dropLast(6))
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                            
                                            
                                            
                                            Text(review.timestamp.formatted(date: .abbreviated, time: .omitted).suffix(4))
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                                .padding(.vertical, -6)
                                                .padding(.bottom, -10)
                                            
                                            
                                            Text("\(String(review.rating))/5")
                                                .font(.title)
                                                .bold()
                                            
                                            Spacer()
                                            
                                        }
                                        
                                        
                                    }
                                    .padding(-8)
                                    
                                    Text(review.comment)
                                        .font(.title3)
                                        .lineLimit(2)
                                    
                                    
                                }
                                .background{
                                    NavigationLink("", destination: SongDetails(
                                        reviewController: reviewController,
                                        profileController: profileController,
                                        songReview: review,
                                        songId: String(review.trackId)
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








#Preview {
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Review.self,
            UserProfile.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    let context = sharedModelContainer.mainContext
    
    let reviewController = ReviewController()
    
    
    
    let mockReview1 = Review(
            trackId: 1442846038,
            artistName: "Kanye Westfdsafdas fdsafdsafdsa fdsadfsa",
            trackName: "Stronger dfasf da fds fads fdsa fads",
            previewUrl: "NA",
            artworkUrl100: "https://upload.wikimedia.org/wikipedia/en/7/70/Graduation_%28album%29.jpg",
            rating: 5,
            comment: "An absolute classic. The Daft Punk sample never gets old.",
            latitude: 0.0,
            longitude: 0.0
        )
    
    let mockReview2 = Review(
            trackId: 1442846039,
            artistName: "Frank Ocean",
            trackName: "Nights",
            previewUrl: "NA",
            artworkUrl100: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQlM8eQsFhyDoCfGdaZbui2ajETEcaPGLrUkA&s",
            rating: 4,
            comment: "The beat switch in the middle is legendary.",
            latitude: 0.0,
            longitude: 0.0
        )
    
    context.insert(mockReview1)
    context.insert(mockReview2)
    
    reviewController.setupDatabase(modelContext: context)
    
    return ReviewHistory(
        reviewController: reviewController, profileController: ProfileController()
    )
    .modelContainer(sharedModelContainer)
}
