//
//  TrendingSongs
//  CSE_355_Project
//
//  Created by Ruben on 3/18/26.
//


struct TrendingSongs: Codable {
    var feed: TrendingFeed?
}

struct TrendingFeed: Codable {
    var results: [TrendingSong]?
}

struct TrendingSong: Codable {
    var artistName: String?
    var id: String?
    var name: String?
    var releaseDate: String?
    var kind: String?
    var artistId: String?
    var artistUrl: String?
    var artworkUrl100: String?
    var url: String?
    var contentAdvisoryRating: String?
    var genres: [Genre]?
}

struct Genre: Codable {
    var genreId: String?
    var name: String?
    var url: String?
}
