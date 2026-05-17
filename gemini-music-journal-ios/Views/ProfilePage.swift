//
//  ProfilePage.swift
//  CSE_335_Project
//
//  Created by Ruben on 3/24/26.
//


import SwiftUI
import SwiftData
import _PhotosUI_SwiftUI


struct ProfilePage: View {
    @ObservedObject var reviewController: ReviewController
    @ObservedObject var profileController: ProfileController
    
    @State var ratingAvg: Double = 0
    
    @State var deleteAllDataAlertShowing: Bool = false
    
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack{
            VStack{
                
                if let image = profileController.userProfile?.image{
                    ZStack{
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                        
                        
                    }
                }
                else{
                    ZStack{
                        Image("DefaultProfilePicture")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                    }
                }
                
                Text(profileController.userProfile?.username ?? "Not Available")
                    .font(.system(size: 35, weight: .bold))
                
                
                let shadowRad = CGFloat(5)
                let clr = Color(.systemGray6).opacity(0.90)//Color(red: 0.43, green: 0.84, blue: 1)
                let symClr = Color(red: 0.43, green: 0.80, blue: 1)
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(clr)
                            .frame(width: 110, height: 100)
                            .shadow(radius: shadowRad)
                        
                        VStack{
                            Image(systemName: "music.note")
                                .foregroundStyle(symClr)
                            
                            Text(String(reviewController.reviews.count))
                                .font(.largeTitle)
                                .bold()
                            
                            
                            Text("Reviews Given")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        
                    }
                    
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(clr)
                            .frame(width: 110, height: 100)
                            .shadow(radius: shadowRad)
                        
                        VStack{
                            Image(systemName: "star.fill")
                                .foregroundStyle(symClr)
                            
                            Text(ratingAvg, format: .number.precision(.fractionLength(1)))
                                .font(.largeTitle)
                                .bold()
                            
                            Text("Avg Rating")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            
                            
                        }
                        
                    }
                    
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(clr)
                            .frame(width: 110, height: 100)
                            .shadow(radius: shadowRad)
                            .padding(2)
                        
                        VStack{
                            
                            Image(systemName: "volume.3.fill")
                                .foregroundStyle(symClr)
                            
                            Text(profileController.userProfile?.favoriteGenre ?? "Not Available")
                                .font(.title2)
                                .bold()
                                .padding(4)
                            
                            Text("Favorite Genre")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        
                    }
                }
                
                Text("Settings and Actions")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, -1)
                
                VStack(spacing: 15) {
                    NavigationLink(destination: EditProfile(profileController: profileController)) {
                        HStack {
                            Image(systemName: "pencil")
                                .foregroundStyle(symClr)
                                .frame(width: 30)
                            Text("Edit Profile Details")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.gray)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                    
                    Divider()
                    /*
                    
                    HStack {
                        Image(systemName: "chart.bar.xaxis")
                            .frame(width: 30)
                            .foregroundStyle(symClr)
                        Text("Review Statistics")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.gray)
                    }
                    
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "info.circle")
                            .frame(width: 30)
                            .foregroundStyle(symClr)
                        Text("About the App")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.gray)
                    }
                    
                    Divider()
                     */
                    
                    Button(action: {deleteAllDataAlertShowing = true})
                    {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.red)
                                .frame(width: 30)
                            Text("Delete All Data")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.gray)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                    
                    
                }
                .padding()
                .background(Color(clr))
                .cornerRadius(10)
                .padding(.horizontal)
                
                
                .alert("Delete All Data", isPresented: $deleteAllDataAlertShowing, actions: {
                    
                    
                    Button("Delete All Data", role: .confirm, action: {
                        reviewController.deleteAllReviews()
                        profileController.deleteProfile()
                        selectedTab = 0
                        
                        deleteAllDataAlertShowing = false
                    })
                    
                    Button("Cancel", role: .cancel, action: {
                        deleteAllDataAlertShowing = false
                    })
                    
                }, message: {Text("This action can not be undone\nAre you sure you want to Delete All Data")})
                
            }
        }
        .onAppear() {
            ratingAvg = reviewController.getRatingAverage()
        }
        .onChange(of: reviewController.reviews.count){
            ratingAvg = reviewController.getRatingAverage()
        }
        
    }
}

#Preview {
    let profileController = ProfileController()
        
        let profile = UserProfile(
            username: "Ruben_Test",
            favoriteGenre: "Hip-Hop",
            profilePicture: (UIImage(named: "DefaultProfilePicture")?.pngData())!)
            
    profileController.userProfile = profile
    
    return ProfilePage(
        reviewController: ReviewController(),
        profileController: profileController,
        selectedTab: .constant(1)
    )
    .modelContainer(for: [Review.self, UserProfile.self], inMemory: true)
}
