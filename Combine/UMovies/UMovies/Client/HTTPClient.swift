//
//  HTTPClient.swift
//  UMovies
//
//  Created by Uday Kumar Kotla on 21/01/26.
//

import Foundation
import Combine

enum NetwoprkError : Error{
    case badRequest
}

class HTTPClient {
    
    func fetchMovie(name : String) -> AnyPublisher<[Movie],Error>{
        let url = URL(string: "https://www.omdbapi.com/?s=\(name)&apikey=18ba4c3d")
        guard let url else {fatalError()}
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieModel.self, decoder: JSONDecoder())
            .map(\.Search)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
