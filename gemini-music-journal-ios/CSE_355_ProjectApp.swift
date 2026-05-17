//
//  CSE_355_ProjectApp.swift
//  CSE_355_Project
//
//  Created by Ruben on 3/16/26.
//

import SwiftUI
import SwiftData

@main
struct CSE_355_ProjectApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Review.self,
            UserProfile.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
