//
//  PhotoSingleResponseDTO.swift
//  TryingApp
//
//  Created by Rizki Siraj on 30/01/26.
//

struct PhotoSingleResponseDTO: Decodable {
    let success: Bool
    let message: String
    let photo: PhotoDTO
}
