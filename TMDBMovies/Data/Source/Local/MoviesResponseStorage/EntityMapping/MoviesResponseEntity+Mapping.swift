//
//  MoviesResponseEntity+Mapping.swift
//  TMDBMovies
//
//  Created by Mohamed Ramadan on 25/01/2024.
//

import CoreData

//MARK: - Mapping To Data Transfer Object
extension MoviesResponseEntity {
    func toDTO() -> MoviesResponseDTO {
        return MoviesResponseDTO(page: 0,
                                 results: movies?.map{($0 as! MovieResponseEntity).toDTO()} ?? [],
                                 totalPages: 0,
                                 totalResults: 0)
    }
}

extension MovieResponseEntity {
    func toDTO() -> MovieDTO {
        return MovieDTO(adult: adult ,
                        backdropPath: backdropPath ?? "",
                        id: Int(id),
                        originalLanguage: originalLanguage ?? "",
                        originalTitle: originalTitle ?? "",
                        overview: overview ?? "",
                        popularity: popularity,
                        posterPath: posterPath ?? "",
                        releaseDate: releaseDate ?? "",
                        title: title ?? "",
                        video: video ,
                        voteCount: Int(voteCount))
    }
}


// Mapping to Entity Model
extension MoviesRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> MoviesRequestEntity {
        let entity: MoviesRequestEntity = .init(context: context)
        
        entity.page = Int32(page)
        entity.keyword = keyword
        
        return entity
    }
}

extension MoviesResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> MoviesResponseEntity {
        let entity: MoviesResponseEntity = .init(context: context)
        
        self.results.forEach {
            entity.addToMovies($0.toEntity(in: context))
        }
        
        return entity
    }
}

extension MovieDTO {
    func toEntity(in context: NSManagedObjectContext) -> MovieResponseEntity {
        let entity: MovieResponseEntity = .init(context: context)
        
        entity.adult = adult
        entity.backdropPath = backdropPath
        entity.id = Int32(id)
        entity.originalLanguage = originalLanguage
        entity.originalTitle = originalTitle
        entity.overview = overview
        entity.popularity = popularity
        entity.posterPath = posterPath
        entity.releaseDate = releaseDate
        entity.title = title
        entity.video = video
        entity.voteCount = Int32(voteCount)
        
        return entity
    }
}
