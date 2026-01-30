//
//  GetFavoritePhotoUsecase.swift
//  TryingApp
//
//  Created by Rizki Siraj on 30/01/26.
//

import Foundation
import Combine

struct FavoritePhotoUsecase {
    private let repository: PhotoRepository
    
    init(repository: PhotoRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Photo], Error> {
        repository.getFavoritePhotos()
    }
}
