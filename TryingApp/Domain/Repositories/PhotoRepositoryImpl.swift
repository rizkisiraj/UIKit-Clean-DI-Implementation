//
//  PhotoRepositoryImpl.swift
//  TryingApp
//
//  Created by Rizki Siraj on 30/01/26.
//

import Foundation
import Combine

final class PhotoRepositoryImpl: PhotoRepository {    
    private let apiService: APIService
    private let favoriteStorage: FavoriteStorage
    
    init(apiService: APIService, favoriteStorage: FavoriteStorage) {
        self.apiService = apiService
        self.favoriteStorage = favoriteStorage
    }
    
    
    func getPhotoDetail(id: Int) -> AnyPublisher<Photo, Error> {
        apiService.fetchPhoto(id: id)
            .tryMap { responseDTO in
                return PhotoMapper.map(dto: responseDTO.photo)
            }
            .eraseToAnyPublisher()
    }
    
    func getFavoritePhotos() -> AnyPublisher<[Photo], Never> {
        
        favoriteStorage.getFavorites()
            .map { localDTOs in
                localDTOs.map(FavoritePhotoLocalMapper.toDomain)
            }
            .eraseToAnyPublisher()
    }
    
    func toggleFavorite(photo: Photo) {
        favoriteStorage.getFavorites()
            .first()
            .sink { [weak self] current in

                guard let self else { return }

                if current.contains(where: { $0.id == photo.id }) {

                    self.favoriteStorage.remove(photoID: photo.id)

                } else {

                    let local = FavoritePhotoLocalMapper.toLocal(photo: photo)
                    self.favoriteStorage.save(photo: local)
                }
            }
            .cancel()
    }
    
    
    func getPhotos(page: Int) -> AnyPublisher<[Photo], Error> {

        let remotePublisher =
            apiService.fetchPhotos(page: page)
                .map { responseDTO in
                    PhotoMapper.map(dtos: responseDTO.photos)
                }

        let favoriteIDsPublisher =
            favoriteStorage.getFavorites()
                .map { localDTOs in
                    Set(localDTOs.map { $0.id })
                }
                .setFailureType(to: Error.self)

        return remotePublisher
            .combineLatest(favoriteIDsPublisher)
            .map { photos, favoriteIDs in
                photos.map { photo in
                    Photo(
                        id: photo.id,
                        width: photo.width,
                        createdAt: photo.createdAt,
                        title: photo.title,
                        description: photo.description,
                        url: photo.url,
                        isFavorite: favoriteIDs.contains(photo.id)
                    )
                }
            }
            .eraseToAnyPublisher()
    }

}
