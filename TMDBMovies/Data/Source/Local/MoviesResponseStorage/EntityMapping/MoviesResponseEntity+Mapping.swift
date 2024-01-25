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
        return movies?.map{($0 as! MovieResponseEntity).toDTO()} ?? []
    }
}

extension MovieResponseEntity {
    func toDTO() -> MovieDTO {
        return .init(id:id ?? "",
                     author: author ?? "",
                     url: url ?? "",
                     downloadURL: downloadUrl ?? "")
    }
}


// Mapping to Entity Model
extension MoviesRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> MoviesRequestEntity {
        let entity: MoviesRequestEntity = .init(context: context)
        
        entity.page = Int32(page)
        entity.limit = Int32(limit)
        
        return entity
    }
}

extension MoviesResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> MoviesResponseEntity {
        let entity: MoviesResponseEntity = .init(context: context)
        
        self.forEach {
            entity.addToMovies($0.toEntity(in: context))
        }
        
        return entity
    }
}

extension MovieDTO {
    func toEntity(in context: NSManagedObjectContext) -> MovieResponseEntity {
        let entity: MovieResponseEntity = .init(context: context)
        
        entity.id = id
        entity.author = author
        entity.url = url
        entity.downloadUrl = downloadURL
        
        return entity
    }
}
