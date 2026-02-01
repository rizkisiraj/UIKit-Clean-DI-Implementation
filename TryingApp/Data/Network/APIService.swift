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
        print(request)
        
        return session.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                let response = output.response as? HTTPURLResponse
                
                if !(200..<300).contains(response?.statusCode ?? 0) {
                    let body = String(data: output.data, encoding: .utf8)
                    print("BODY:", body ?? "-")
                    throw URLError(.badServerResponse)
                }
                
                return output.data
            }
            .decode(type: PhotoListResponseDTO.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        
        var components = URLComponents(string: "https://jsonplaceholder.typicode.com/posts")!
        
        let request = URLRequest(url: components.url!)
        
        return session.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                let response = output.response as? HTTPURLResponse
                
                if !(200..<300).contains(response?.statusCode ?? 0) {
                    let body = String(data: output.data, encoding: .utf8)
                    print("BODY:", body ?? "-")
                    throw URLError(.badServerResponse)
                }
                
                return output.data
            }
            .decode(type: [Post].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func fetchPhoto(id: Int) -> AnyPublisher<PhotoSingleResponseDTO, Error> {
        
        let url = URL(string: "https://boringapi.com/api/v1/photo/\(id)")!
        let request = URLRequest(url: url)
        
        return session.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                let response = output.response as? HTTPURLResponse
                
                guard (200..<300).contains(response?.statusCode ?? 0) else {
                    throw URLError(.badServerResponse)
                }
                
                return output.data
            }
            .decode(type: PhotoSingleResponseDTO.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func fetchPost(id: Int) -> AnyPublisher<Post, Error> {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(id)")!
        let request = URLRequest(url: url)
        
        return session.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                let response = output.response as? HTTPURLResponse
                
                guard (200..<300).contains(response?.statusCode ?? 0) else {
                    throw URLError(.badServerResponse)
                }
                
                return output.data
            }
            .decode(type: Post.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
