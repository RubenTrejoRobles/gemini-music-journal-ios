//
//  ReviewOnMap.swift
//  CSE_335_Project
//
//  Created by Ruben on 4/9/26.
//

import SwiftUI
import SwiftData
import _PhotosUI_SwiftUI
import CoreLocation
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct ReviewLocationView: View {
    @ObservedObject var reviewController: ReviewController
    @ObservedObject var profileController: ProfileController
    
    @State var songReview: Review
    
    
    @State private var region: MKCoordinateRegion
    @State private var markers: [Location]
    @State var searchText: String = ""
    
    init(reviewController: ReviewController, profileController: ProfileController, songReview: Review){
        self.reviewController = reviewController
        self.profileController = profileController
        self.songReview = songReview
        
        region = MKCoordinateRegion(
            center: songReview.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
        
        markers = [ Location(name: songReview.trackName, coordinate: songReview.coordinate) ]
    }
    
    var body: some View {
        
        
        
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $region,
                interactionModes: .all,
                annotationItems: markers
            ) { location in
                //MapMarker(coordinate: location.coordinate)
                MapAnnotation(coordinate: location.coordinate){
                    VStack{
                        Text(location.name)
                                .font(.caption)
                                .opacity(0)
                        
                        Image(systemName: "mappin.circle.fill")
                            .foregroundStyle(.red)
                            .frame(width: 20, height: 20)
                        
                        Text(location.name)
                            .font(.caption)
                            .cornerRadius(5)
                        
                    }
                 }
            }
        }
        .ignoresSafeArea()
        
        searchBar
    }
    
    
    
    
    
    private var searchBar: some View {
        HStack {
            Button {
                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = searchText
                searchRequest.region = region
                
                MKLocalSearch(request: searchRequest).start { response, error in
                    guard let response = response else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error").")
                        return
                    }
                    
                    region = response.boundingRegion
                    markers.append(contentsOf: response.mapItems.map { item in
                        Location(
                            name: item.name ?? "",
                            coordinate: item.placemark.coordinate
                        )
                    })
                }
            } label: {
                Text("Search")
            }
            .padding()
            
            TextField("Search e.g restaurants", text: $searchText)
                .padding()
        }
    }
}
