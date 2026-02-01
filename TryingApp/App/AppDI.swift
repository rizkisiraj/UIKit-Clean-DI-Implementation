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
    
    lazy var favoritePostStorage: FavoriteStoragePosts = {
        FavoriteStoragePostsImpl()
    }()

    lazy var photoRepository: PhotoRepository = {
        PhotoRepositoryImpl(
            apiService: apiService,
            favoriteStorage: favoriteStorage)
    }()
    
    lazy var postRepository: PostRepository = {
        PostRepositoryImpl(apiService: apiService, favoriteStoragePosts: favoritePostStorage)
    }()

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
    
    lazy var getPostsUseCase: GetPostsUseCase = {
        GetPostsUseCase(repository: postRepository)
    }()
}


