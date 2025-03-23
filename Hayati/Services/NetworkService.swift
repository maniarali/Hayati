//
//  NetworkService.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 23/03/2025.
//
import Foundation
import Combine

protocol NetworkService {
    func fetchData<T: Decodable>(from url: URL, headers: [String: String]) -> AnyPublisher<T, Error>
}

class NetworkServiceImpl: NetworkService {
    func fetchData<T: Decodable>(from url: URL, headers: [String: String]) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
