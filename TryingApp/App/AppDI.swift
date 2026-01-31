//
//  AppDI.swift
//  TryingApp
//
//  Created by Rizki Siraj on 29/01/26.
//
import Foundation

final class DependencyContainer {

    lazy var apiService: APIService = {
        APIService()
    }()

    lazy var favoriteStorage: FavoriteStorage = {
        FavoriteStorageImpl()
    }()

    lazy var photoRepository: PhotoRepository = {
        PhotoRepositoryImpl(
            apiService: apiService,
            favoriteStorage: favoriteStorage)
    }()

    // MARK: - Use Cases

    lazy var getPhotosUseCase: GetPhotoUseCase = {
        GetPhotoUseCase(repository: photoRepository)
    }()

    lazy var getPhotoDetailUseCase: GetPhotoDetailUsecase = {
        GetPhotoDetailUsecase(repository: photoRepository)
    }()

    lazy var getFavoritePostsUseCase: FavoritePhotoUsecase = {
        FavoritePhotoUsecase(repository: photoRepository)
    }()

    lazy var toggleFavoriteUseCase: ToggleFavoriteUsecase = {
        ToggleFavoriteUsecase(repository: photoRepository)
    }()
}


