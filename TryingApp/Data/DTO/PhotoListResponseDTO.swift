//
//  PhotoListResponseDTO.swift
//  TryingApp
//
//  Created by Rizki Siraj on 30/01/26.
//

import Foundation

struct PhotoListResponseDTO: Decodable {
    let success: Bool
    let message: String
    let count: Int
    let totalPages: Int
    let photos: [PhotoDTO]
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case count
        case totalPages = "total_pages"
        case photos
    }
}
