//
//  getPhotoUsecase.swift
//  TryingApp
//
//  Created by Rizki Siraj on 30/01/26.
//

import Foundation
import Combine

struct GetPhotoUseCase {
    private let repository: PhotoRepository
    
    init(repository: PhotoRepository) {
        self.repository = repository
    }
    
    func execute(page: Int) -> AnyPublisher<PagedPhotos, Error> {
        repository.getPhotos(page: page)
    }
}
