//
//  MoviesModel.swift
//  TMDBMovies
//
//  Created by Mohamed Ramadan on 25/01/2024.
//

import Foundation

struct MoviesModel {
    let page: Int
    let movies: [MovieModel]
    let totalPages, totalResults: Int
}

// MARK: - MovieModel
struct MovieModel {
    let adult: Bool
    let backdropPath: String
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteCount: Int
}
   
