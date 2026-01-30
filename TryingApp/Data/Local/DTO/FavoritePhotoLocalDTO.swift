//
//  FavoritePhotoLocalDTO.swift
//  TryingApp
//
//  Created by Rizki Siraj on 30/01/26.
//

import Foundation

struct FavoritePhotoLocalDTO: Codable {
    let id: Int
    let width: Int
    let createdAt: String
    let title: String
    let description: String
    let url: String
}



