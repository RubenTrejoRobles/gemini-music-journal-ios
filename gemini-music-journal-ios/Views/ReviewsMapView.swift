//
//  ReviewsMapView.swift
//  CSE_335_Project
//
//  Created by Ruben on 4/9/26.
//

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


struct ReviewsMapView: View {
    @ObservedObject var reviewController: ReviewController
    @ObservedObject var profileController: ProfileController
    
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion()
    @State private var markers: [Location] = []
    @State var searchText: String = ""
    
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
            .onAppear(){
                if let songReview = reviewController.reviews.first{
                    region = MKCoordinateRegion(
                        center: songReview.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                    )
                    
                    var m: [Location] = []
                    for review in reviewController.reviews {
                        m.append(Location(name: review.trackName, coordinate: review.coordinate))
                    }
                    markers = m
                }
            }
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
