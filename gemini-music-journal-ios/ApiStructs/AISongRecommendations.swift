//
//  AISongRecommendations.swift
//  CSE_335_Project
//
//  Created by Ruben on 4/10/26.
//

//For the response
struct AIResponse: Codable {
    var candidates: [Candidate]
}

struct Candidate: Codable {
    var content: Content
}

struct Content: Codable {
    var parts: [Part]
}

struct Part: Codable {
    var text: String?
}



struct AISong: Codable {
    var trackName: String
    var artistName: String
}


//For the POST API call

struct PostBody: Codable {
    var contents: [Content]
}
