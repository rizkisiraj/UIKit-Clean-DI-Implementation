//
//  PhotoMapper.swift
//  TryingApp
//
//  Created by Rizki Siraj on 30/01/26.
//

import Foundation

struct PhotoMapper {
    
    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return f
    }()

    
    static func map(dto: PhotoDTO) -> Photo {        
        let date = formatter.date(from: dto.createdAt) ?? Date()
        
        return Photo(
            id: dto.id, width: dto.width, createdAt: date, title: dto.title, description: dto.description, url: dto.url
        )
    }
    
    static func map(dtos: [PhotoDTO]) -> [Photo] {
        dtos.map { map(dto: $0) }
    }
}
