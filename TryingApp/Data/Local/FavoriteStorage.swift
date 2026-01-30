//
//  FavoriteStorage.swift
//  TryingApp
//
//  Created by Rizki Siraj on 30/01/26.
//
import Combine

protocol FavoriteStorage {
    func getFavorites() -> AnyPublisher<[FavoritePhotoLocalDTO], Never>
    func save(photo: FavoritePhotoLocalDTO)
    func remove(photoID: Int)
}
