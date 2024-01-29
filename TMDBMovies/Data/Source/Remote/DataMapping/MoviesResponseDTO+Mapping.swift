//
//  MoviesResponseDTO+Mapping.swift
//  TMDBMovies
//
//  Created by Mohamed Ramadan on 25/01/2024.
//

import Foundation

// MARK: - MoviesResponseDTO
//typealias MoviesResponseDTO = [MovieDTO]

struct MoviesResponseDTO: Codable {
    let page: Int
    let results: [MovieDTO]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


// MARK: - MovieDTO
struct MovieDTO: Codable {
    let adult: Bool
    let backdropPath: String
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteCount = "vote_count"
    }
}

   
//MARK: Mapping To Domain
extension MoviesResponseDTO {
    func toDomain(page: Int) -> MoviesModel {
        //return .init(page: page, movies: self.map{ $0.toDomain()})
        return .init(page: page, movies: self.results.map{ $0.toDomain()}, totalPages: totalPages, totalResults: totalResults)
    }
}

extension MovieDTO {
    func toDomain() -> MovieModel {
        return .init(adult: adult, backdropPath: backdropPath, id: id, originalLanguage: originalLanguage, originalTitle: originalTitle, overview: overview, popularity: popularity, posterPath: posterPath, releaseDate: releaseDate, title: title, video: video, voteCount: voteCount)
    }
}

