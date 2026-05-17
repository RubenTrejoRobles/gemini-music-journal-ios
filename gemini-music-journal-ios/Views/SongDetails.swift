//
//  SongDetailsPage.swift
//  CSE_335_Project
//
//  Created by Ruben on 3/26/26.
//

import SwiftUI
import SwiftData
import _PhotosUI_SwiftUI

struct SongDetails: View {
    
    @ObservedObject var reviewController: ReviewController
    @ObservedObject var profileController: ProfileController
    @State var songReview: Review?
    
    
    @State var song: SongAttributes?
    @State var songId: String?
    @Environment(\.openURL) var openURL
    
    let textClr = Color(.white).opacity(0.75)
    
    
    @State var showingAddReviewSheet: Bool = false
    @State var new_rating: Int = 0
    @State var new_comment: String = ""
    
    @State var showingSongReviewSheet: Bool = false
    @State var showingEditReviewSheet: Bool = false
    @State var showingAddReviewFailedSheet: Bool = false
    
    @State var deleteConfirmationAlertShowing: Bool = false
    var body: some View {
        
        ZStack{
            
            if let song = song {
                
                let imageLink = song.artworkUrl100?.replacingOccurrences(of: "100x100", with: "500x500")
                
                AsyncImage(url: URL(string: imageLink ?? "")){ image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                        .blur(radius: 65, opaque: true)
                }
                placeholder: {
                    
                }
                
                VStack{
                        
                    let imageLink = song.artworkUrl100?.replacingOccurrences(of: "100x100", with: "500x500")
                    AsyncImage(url: URL(string: imageLink ?? "")){ image in
                        image
                            .resizable()
                            .frame(width: 250, height: 250)
                            .cornerRadius(10)
                    }
                    placeholder: {
                        ProgressView()
                            .frame(width: 50, height: 50)
                    }
                
                    Text(song.trackName ?? "Song Name Unavailable")
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                        .frame(maxWidth: 350)
                        .lineLimit(1)
                    
                    Text(song.artistName ?? "Artist Name Unavailable")
                        .foregroundStyle(textClr)
                        .font(.title3)
                    
                    if songReview == nil{
                        Button {
                            showingAddReviewSheet = true
                        } label: {
                            Label("Write a Review", systemImage: "square.and.pencil")
                                .foregroundStyle(.black)
                                .frame(maxWidth: 325)
                                .padding()
                                .background(Color(.white))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                    else {
                        Button {
                            showingSongReviewSheet = true
                        } label: {
                            Label("See Song Review", systemImage: "eye.fill")
                                .foregroundStyle(.black)
                                .frame(maxWidth: 325)
                                .padding()
                                .background(Color(.white))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        NavigationLink(destination: ReviewLocationView(reviewController: reviewController,
                                                                       profileController: profileController,
                                                                       songReview: songReview!)){
                            Label("View Review Location", systemImage: "map")
                                .foregroundStyle(.white)
                                .frame(maxWidth: 325)
                                .padding()
                                .background(Color(.gray))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                        
                    Button {
                        openURL(URL(string: song.trackViewUrl!)!)
                    } label: {
                        Label("Visit Song", systemImage: "play.fill")
                            .foregroundStyle(.white)
                            .frame(maxWidth: 325)
                            .padding()
                            .background(Color(.darkGray))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    
                    
                    HStack(){
                        Image(systemName: "timer")
                            .foregroundStyle(textClr)
                            
                        Text("Duration")
                            .foregroundStyle(textClr)
                        
                        Spacer()
                        
                        if let milisec = song.trackTimeMillis{
                            let secondsTotal = Double(milisec) * 0.001
                            let minutes = Int(secondsTotal / 60)
                            let seconds = Int(secondsTotal.truncatingRemainder(dividingBy: 60))
                            Text("\(minutes):\(seconds)")
                                .foregroundStyle(textClr)
                        }
                        else {
                            Text("NA")
                                .foregroundStyle(textClr)
                        }
                    }
                    .frame(maxWidth: 350)
                    .padding(7)
                    
                    HStack(){
                        Image(systemName: "paintpalette.fill")
                            .foregroundStyle(textClr)
                            
                        Text("Genre")
                            .foregroundStyle(textClr)
                        
                        Spacer()
                        
                        if let genre = song.primaryGenreName{
                            
                            Text(genre)
                                .foregroundStyle(textClr)
                        }
                        else {
                            Text("NA")
                                .foregroundStyle(textClr)
                                
                        }
                    }
                    .frame(maxWidth: 350)
                    .padding(.bottom, 7)
                    
                    HStack(){
                        Image(systemName: "calendar")
                            .foregroundStyle(textClr)
                            
                        Text("Release Date")
                            .foregroundStyle(textClr)
                        
                        Spacer()
                        
                        if let date = song.releaseDate{
                            
                            Text(date.prefix(10))
                                .foregroundStyle(textClr)
                        }
                        else {
                            Text("NA")
                                .foregroundStyle(textClr)
                                
                        }
                    }
                    .frame(maxWidth: 350)
                    
                    
                    
                    
                }
            }
            
            else if (songId != nil) {
                Text("Song Details Loading...")
            }
            else {
                Text("Song is Not Available :(")
            }
        }
        .navigationTitle("Song Details")
        
        .task {
            if song == nil{
                if let id = songId {
                    song = await reviewController.getSongAttributes(id: id)
                }
            }
        }
        
        
        
        
        .sheet(isPresented: $showingAddReviewSheet) {
            NavigationStack {
                Form {
                    
  
                    HStack{
                        let imageLink = song?.artworkUrl100
                        AsyncImage(url: URL(string: imageLink ?? "")){ image in
                            image
                                .resizable()
                                .frame(width: 60, height: 60)
                                .cornerRadius(10)
                        }
                        placeholder: {
                            ProgressView()
                                .frame(width: 60, height: 60)
                        }
                        
                        VStack(alignment: .leading){
                            Text(song?.artistName ?? "")
                                .font(.headline)
                                .lineLimit(1)
                            
                            
                            Text(song?.trackName ?? "")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                            
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    
                    
                    HStack{
                        Spacer()
                        
                        ForEach(1..<6, id: \.self) { i in
                            Button {
                                new_rating = i
                            } label: {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(i > new_rating ? .gray : .yellow)
                                    .font(.system(size: 40))
                            }
                            .padding(.horizontal, 3)
                        }
                        
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                    .buttonStyle(BorderlessButtonStyle())
                    .listRowSeparator(.hidden)
                    
                    TextField("Comment", text: $new_comment, axis: .vertical)
                        .padding(5)
                        .lineLimit(9...20)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                            .fill(.clear)
                            .stroke(.gray)
                        )
                        .listRowBackground(Color.clear)
                        
                }
                .contentMargins(.top, -15)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Submit Review")
                
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Post") {
                            // logic for adding a new review
                            
                            let wasCreated = reviewController.addReview(song: song!, rating: new_rating, comment: new_comment)
                            if !wasCreated{
                                showingAddReviewFailedSheet = true
                            }
                            else{
                                showingAddReviewSheet = false
                                songReview = reviewController.getReview(trackId: (song?.trackId)!)
                                
                                new_rating = 0
                                new_comment = ""
                                
                            }
                            
                        }
                        .foregroundColor(.blue)
                        .disabled(new_rating == 0)
                    }
                }
                // alert here
                
                .alert("Error Adding the Review", isPresented: $showingAddReviewFailedSheet, actions: {


                    Button("Ok", role: .cancel, action: {
                        showingAddReviewFailedSheet = false
                    }) 
                    
                }, message: {Text("There was an error adding the review.\nMake sure you have location services activated in settings")})
                
                
                
            }
            .presentationDetents([.medium, .large])
            
        }
        
        .sheet(isPresented: $showingEditReviewSheet) {
            NavigationStack {
                Form {
                    
                    
                    HStack{
                        let imageLink = song?.artworkUrl100
                        AsyncImage(url: URL(string: imageLink ?? "")){ image in
                            image
                                .resizable()
                                .frame(width: 60, height: 60)
                                .cornerRadius(10)
                        }
                        placeholder: {
                            ProgressView()
                                .frame(width: 60, height: 60)
                        }
                        
                        VStack(alignment: .leading){
                            Text(song?.artistName ?? "")
                                .font(.headline)
                                .lineLimit(1)
                            
                            
                            Text(song?.trackName ?? "")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                            
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    
                    
                    HStack{
                        Spacer()
                        
                        ForEach(1..<6, id: \.self) { i in
                            Button {
                                new_rating = i
                            } label: {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(i > new_rating ? .gray : .yellow)
                                    .font(.system(size: 40))
                            }
                            .padding(.horizontal, 3)
                        }
                        
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                    .buttonStyle(BorderlessButtonStyle())
                    .listRowSeparator(.hidden)
                    
                    TextField("Comment", text: $new_comment, axis: .vertical)
                        .padding(5)
                        .lineLimit(9...20)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                            .fill(.clear)
                            .stroke(.gray)
                        )
                        .listRowBackground(Color.clear)
                    
                    
                    
                    
                }
                .contentMargins(.top, -15)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Edit Review")
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Submit") {
                            if let review = songReview {
                                showingEditReviewSheet = false
                                
                                reviewController.updateReview(trackId: review.trackId, rating: new_rating, comment: new_comment)
                                songReview = reviewController.getReview(trackId: (song?.trackId)!)
                                
                                new_rating = 0
                                new_comment = ""
                            }
                            
                        }
                        .foregroundColor(.blue)
                        .disabled(new_rating == 0)
                    }
                }
            }
            .presentationDetents([.medium, .large])
        }
        
        
        .sheet(isPresented: $showingSongReviewSheet) {
            NavigationStack {
                Form {
                    if let review = songReview {
                        HStack{
                            let imageLink = song?.artworkUrl100
                            AsyncImage(url: URL(string: imageLink ?? "")){ image in
                                image
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(10)
                            }
                            placeholder: {
                                ProgressView()
                                    .frame(width: 60, height: 60)
                            }
                            
                            VStack(alignment: .leading){
                                Text(song?.artistName ?? "")
                                    .font(.headline)
                                    .lineLimit(1)
                                
                                
                                Text(song?.trackName ?? "")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                                
                            }
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        
                        
                        HStack{
                            Spacer()
                            
                            ForEach(1..<6, id: \.self) { i in
                                HStack{
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(i > review.rating ? .gray : .yellow)
                                        .font(.system(size: 40))
                                }
                                .padding(.horizontal, 3)
                            }
                            
                            Spacer()
                        }
                        .listRowBackground(Color.clear)
                        .buttonStyle(BorderlessButtonStyle())
                        .listRowSeparator(.hidden)
                        
                        
                        Text(review.comment)
                            .padding(5)
                            .listRowBackground(Color.clear)
                    }
                }
                .contentMargins(.top, -15)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Song Review")
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Delete") {
                            deleteConfirmationAlertShowing = true
                        }
                        .foregroundColor(.blue)
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Edit") {
                            if let review = songReview {
                                showingSongReviewSheet = false;
                                
                                new_rating = review.rating
                                new_comment = review.comment
                                
                                showingEditReviewSheet = true;
                                
                                
                            }
                            
                        }
                        .foregroundColor(.blue)
                    }
                    
                    
                }
                
                .alert("Delete Review", isPresented: $deleteConfirmationAlertShowing, actions: {
                    
                    
                    Button("Confirm", role: .confirm, action: {
                        if let review = songReview{
                            reviewController.deleteReview(trackId: review.trackId)
                            songReview = reviewController.getReview(trackId: review.trackId)
                            
                            showingSongReviewSheet = false
                            deleteConfirmationAlertShowing = false
                        }
                    })

                    Button("Cancel", role: .cancel, action: {
                        deleteConfirmationAlertShowing = false
                    })
                    
                }, message: {Text("Are you sure you want to delete this review?")})
                
                
            }
            .presentationDetents([.medium, .large])
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
    
    let profileController = ProfileController()
    let reviewController = ReviewController()
    
    profileController.setupDatabase(modelContext: context)
    reviewController.setupDatabase(modelContext: context)
        
        let profile = UserProfile(
            username: "Ruben_Test",
            favoriteGenre: "Hip-Hop",
            profilePicture: (UIImage(named: "DefaultProfilePicture")?.pngData())!)
            
    profileController.userProfile = profile
    
    return SongDetails(
        reviewController: reviewController,
        profileController: profileController,
        songId: "1442846038"
    )
    .modelContainer(sharedModelContainer)
}


