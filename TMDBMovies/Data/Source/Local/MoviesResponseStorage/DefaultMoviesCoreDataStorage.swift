//
//  DefaultMoviesCoreDataStorage.swift
//  TMDBMovies
//
//  Created by Mohamed Ramadan on 25/01/2024.
//

import CoreData
 
final class DefaultMoviesCoreDataStorage {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    // MARK: - Private
    private func fetchRequest(for requestDto: MoviesRequestDTO) -> NSFetchRequest<MoviesRequestEntity> {
        let request: NSFetchRequest = MoviesRequestEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %d AND %K = %d",
                                        #keyPath(MoviesRequestEntity.limit), requestDto.limit,
                                        #keyPath(MoviesRequestEntity.page), requestDto.page)
        return request
    }

    private func deleteResponse(for requestDto: MoviesRequestDTO, in context: NSManagedObjectContext) {
        let request = fetchRequest(for: requestDto)

        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
}

extension DefaultMoviesCoreDataStorage: MoviesResponseStorage {

    func getResponse(for requestDTO: MoviesRequestDTO, completion: @escaping (Result<MoviesResponseDTO?, CoreDataStorageError>) -> Void) {
        
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(for: requestDTO)
                let requestEntity = try context.fetch(fetchRequest).first

                completion(.success(requestEntity?.response?.toDTO()))
            } catch {
                debugPrint(error.localizedDescription)
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
        
    }
    
    func save(responseDTO: MoviesResponseDTO, for requestDTO: MoviesRequestDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(for: requestDTO, in: context)

                let requestEntity = requestDTO.toEntity(in: context)
                requestEntity.response = responseDTO.toEntity(in: context)

                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataMoviesResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}

