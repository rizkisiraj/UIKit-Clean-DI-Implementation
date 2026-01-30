//
//  PhotoRepository.swift
//  TryingApp
//
//  Created by Rizki Siraj on 30/01/26.
//
import Combine

protocol PhotoRepository {
    func getPhotos() -> AnyPublisher<[Photo], Error>
    func getPhotoDetail(id: Int) -> AnyPublisher<Photo, Error>
    func getFavoritePhotos() -> AnyPublisher<[Photo], Error>
    func toggleFavorite(photo: Photo)
}


