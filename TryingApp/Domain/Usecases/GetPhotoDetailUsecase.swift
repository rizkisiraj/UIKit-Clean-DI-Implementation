//
//  GetPhotoDetailUsecase.swift
//  TryingApp
//
//  Created by Rizki Siraj on 30/01/26.
//

import Foundation
import Combine

struct GetPhotoDetailUsecase {
    private let repository: PhotoRepository
    
    init(repository: PhotoRepository) {
        self.repository = repository
    }
    
    func execute(id: Int) -> AnyPublisher<Photo, Error> {
        repository.getPhotoDetail(id: id)
    }
}
