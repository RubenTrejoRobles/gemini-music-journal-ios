//
//  CreateProfile.swift
//  CSE_335_Project
//
//  Created by Ruben on 3/24/26.
//

import SwiftUI
import SwiftData
import _PhotosUI_SwiftUI

struct CreateProfile: View {
    @ObservedObject var profileController: ProfileController
    
    @State var genres: [(String, Bool, Color)] = [("Rock", false, .gray),
                                                      ("Jazz", false, .gray),
                                                      ("Electronic", false, .gray),
                                                      ("R&B", false, .gray),
                                                      ("Classical", false, .gray),
                                                      ("Country", false, .gray),
                                                      ("Hip-Hop", false, .gray),
                                                      ("Pop", false, .gray)]
    @State var genreSelected: String?
    
    @State var username: String = ""
    
    @State var selectedItem: PhotosPickerItem?
    @State var new_image: UIImage? = nil
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let image = UIImage(data: imageData) else { return }
            
            new_image = image
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack{
                Spacer()
                Text("Create Your Profile")
                    .font(.system(size: 43, weight: .bold))
                Spacer()
            }
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                if let image = new_image{
                    ZStack{
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                        
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .offset(x: 75, y: 75)
                            .foregroundStyle(.blue)
                    }
                    
                }
                else{
                    ZStack{
                        
                        
                        Image("DefaultProfilePicture")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                        
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .offset(x: 75, y: 75)
                            .foregroundStyle(.blue)
                        
                        
                    }
                }
            }
       
            
            
            
            VStack{
                Text("Username")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, -5)
                HStack {
                    Image(systemName: "person.crop.circle")
                        .foregroundColor(.secondary)
                    TextField("Username", text: $username)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Text("Favorite Genre")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom, -1)
            
            
            HStack{
                //Spacer()
                Button(genres[0].0){
                    genres[0] = setCategory(c: genres[0])
                }
                .padding(8)
                .font(.title3)
                .background(genres[0].2)
                .foregroundColor(.white)
                .clipShape(Capsule())
                //Spacer()
                
                Button(genres[1].0){
                    genres[1] = setCategory(c: genres[1])
                }
                .padding(8)
                .font(.title3)
                .background(genres[1].2)
                .foregroundColor(.white)
                .clipShape(Capsule())
                //Spacer()
                
                Button(genres[2].0){
                    genres[2] = setCategory(c: genres[2])
                }
                .padding(8)
                .font(.title3)
                .background(genres[2].2)
                .foregroundColor(.white)
                .clipShape(Capsule())
                //Spacer()
                
                Button(genres[3].0){
                    genres[3] = setCategory(c: genres[3])
                }
                .padding(8)
                .font(.title3)
                .background(genres[3].2)
                .foregroundColor(.white)
                .clipShape(Capsule())
               Spacer()
            }
            .padding(.horizontal)
            
            HStack{
                //Spacer()
                Button(genres[4].0){
                    genres[4] = setCategory(c: genres[4])
                }
                .padding(8)
                .font(.title3)
                .background(genres[4].2)
                .foregroundColor(.white)
                .clipShape(Capsule())
                //Spacer()
                
                Button(genres[5].0){
                    genres[5] = setCategory(c: genres[5])
                }
                .padding(8)
                .font(.title3)
                .background(genres[5].2)
                .foregroundColor(.white)
                .clipShape(Capsule())
                //Spacer()
                
                Button(genres[6].0){
                    genres[6] = setCategory(c: genres[6])
                }
                .padding(8)
                .font(.title3)
                .background(genres[6].2)
                .foregroundColor(.white)
                .clipShape(Capsule())
                //Spacer()
                
                Button(genres[7].0){
                    genres[7] = setCategory(c: genres[7])
                }
                .padding(8)
                .font(.title3)
                .background(genres[7].2)
                .foregroundColor(.white)
                .clipShape(Capsule())
               Spacer()
            }
            .padding(.horizontal)
        
        
        Spacer()
        
        
        Button("Start Exploring"){
            // create profile here
            
            if let imageData = (new_image ?? UIImage(named: "DefaultProfilePicture"))?.pngData(){
                profileController.setProfile(username: username, favoriteGenre: genreSelected!, profilePicture: imageData)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .center)
        .font(.title)
        .bold()
        .background(.blue)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal)
        .disabled(genreSelected == nil || username.isEmpty)
            
        }
        .onChange(of: selectedItem, loadImage)
    }
        
    
    
    func setCategory(c: (String, Bool, Color)) -> (String, Bool, Color){
        genres = [("Rock", false, .gray),
                      ("Jazz", false, .gray),
                      ("Electronic", false, .gray),
                      ("R&B", false, .gray),
                      ("Classical", false, .gray),
                      ("Country", false, .gray),
                      ("Hip-Hop", false, .gray),
                      ("Pop", false, .gray)]
        genreSelected = c.0
        return (c.0, true, .blue)
    }
}
