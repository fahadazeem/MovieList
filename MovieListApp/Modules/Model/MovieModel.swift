//
//  MovieModel.swift
//  MovieListApp
//
//  Created by Junaid Butt on 25/05/2022.
//

import Foundation

// MARK: - MovieModel
struct MovieModel: Codable {
    let search: [Movie]?
    let  response: String
    let totalResults : String?
    let error : String?
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case error = "Error"
        case response = "Response"
    }
}

// MARK: - Search
struct Movie: Codable {
    var title: String?
    var year: String?
    var released: String?
    var plot: String?
    var poster: String?
    var imdbRating: String?
    var imdbID: String?
    var isFavourite: Bool = false
    var isHidden: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case released = "Released"
        case plot = "Plot"
        case poster = "Poster"
        case imdbRating
        case imdbID
    }
}


