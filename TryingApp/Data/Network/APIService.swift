//
//  APIService.swift
//  TryingApp
//
//  Created by Rizki Siraj on 30/01/26.
//

import Foundation
import Combine

final class APIService {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchPhotos(page: Int) -> AnyPublisher<PhotoListResponseDTO, Error> {
        
        var components = URLComponents(string: "https://boringapi.com/api/v1/photos")!
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        let request = URLRequest(url: components.url!)
        
        return session.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                let response = output.response as? HTTPURLResponse
                
                guard (200..<300).contains(response?.statusCode ?? 0) else {
                    throw URLError(.badServerResponse)
                }
                
                return output.data
            }
            .decode(type: PhotoListResponseDTO.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
