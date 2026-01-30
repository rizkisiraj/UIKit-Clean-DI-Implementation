//
//  PhotoRepository.swift
//  TryingApp
//
//  Created by Rizki Siraj on 30/01/26.
//
import Combine

protocol PhotoRepository {
    func getPhotos(page: Int) -> AnyPublisher<[Photo], Error>
    func getPhotoDetail(id: Int) -> AnyPublisher<Photo, Error>
    func getFavoritePhotos() -> AnyPublisher<[Photo], Never>
    func toggleFavorite(photo: Photo)
}


