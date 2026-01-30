//
//  ToggleFavoriteUsecase.swift
//  TryingApp
//
//  Created by Rizki Siraj on 30/01/26.
//

import Foundation
import Combine

struct ToggleFavoriteUsecase {
    private let repository: PhotoRepository
    
    init(repository: PhotoRepository) {
        self.repository = repository
    }
    
    func execute(photo: Photo) -> AnyPublisher<Void, Never> {
        repository.toggleFavorite(photo: photo)
        return Just(())
            .eraseToAnyPublisher()
    }
}
