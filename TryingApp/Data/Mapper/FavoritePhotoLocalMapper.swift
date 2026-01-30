//
//  FavoritePhotoLocalMapper.swift
//  TryingApp
//
//  Created by Rizki Siraj on 30/01/26.
//

import Foundation

struct FavoritePhotoLocalMapper {

    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return f
    }()

    static func toDomain(dto: FavoritePhotoLocalDTO) -> Photo {

        let date = formatter.date(from: dto.createdAt) ?? Date()

        return Photo(
            id: dto.id,
            width: dto.width,
            createdAt: date,
            title: dto.title,
            description: dto.description,
            url: dto.url
        )
    }

    static func toLocal(photo: Photo) -> FavoritePhotoLocalDTO {

        let dateString = formatter.string(from: photo.createdAt)

        return FavoritePhotoLocalDTO(
            id: photo.id,
            width: photo.width,
            createdAt: dateString,
            title: photo.title,
            description: photo.description,
            url: photo.url
        )
    }
}
