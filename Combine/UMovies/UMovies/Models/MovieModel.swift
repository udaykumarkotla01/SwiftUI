//
//  MovieModel.swift
//  UMovies
//
//  Created by Uday Kumar Kotla on 21/01/26.
//


/**
 API: https://www.omdbapi.com/?s=superman&apikey=18ba4c3d
 
 {
   "Search": [
     {
       "Title": "Batman v Superman: Dawn of Justice",
       "Year": "2016",
       "imdbID": "tt2975590",
       "Type": "movie",
       "Poster": "https://m.media-amazon.com/images/M/MV5BZTJkYjdmYjYtOGMyNC00ZGU1LThkY2ItYTc1OTVlMmE2YWY1XkEyXkFqcGc@._V1_SX300.jpg"
     },
     {
       "Title": "Batman v Superman: Dawn of Justice",
       "Year": "2016",
       "imdbID": "tt2975590",
       "Type": "movie",
       "Poster": "https://m.media-amazon.com/images/M/MV5BZTJkYjdmYjYtOGMyNC00ZGU1LThkY2ItYTc1OTVlMmE2YWY1XkEyXkFqcGc@._V1_SX300.jpg"
     },
 ]
 */
import Foundation

class MovieModel : Codable {
    let Search: [Movie]
}

class Movie : Identifiable ,Codable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: URL?
    var id : String { imdbID }
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}
