//
//  MoviesResponseDTO+Mapping.swift
//  TMDBMovies
//
//  Created by Mohamed Ramadan on 25/01/2024.
//

import Foundation

// MARK: - MoviesResponseDTO
typealias MoviesResponseDTO = [MovieDTO]

// MARK: - MovieDTO
struct MovieDTO: Codable {
    let id, author: String
    let url, downloadURL: String

    enum CodingKeys: String, CodingKey {
        case id, author, url
        case downloadURL = "download_url"
    }
}
   
//MARK: Mapping To Domain
extension MoviesResponseDTO {
    func toDomain(page: Int) -> MoviesModel {
        return .init(page: page, movies: self.map{ $0.toDomain()})
    }
}

extension MovieDTO {
    func toDomain() -> MovieModel {
        return .init(id: id, author: author, url: url, downloadURL: downloadURL)
    }
}

