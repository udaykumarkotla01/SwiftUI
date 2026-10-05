//
//  PostRepository.swift
//  CleanArchitectre_p1
//
//  Created by Uday Kumar Kotla on 05/10/26.
//

import Foundation

public enum RepositoryError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case noData

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The posts URL is invalid."
        case .invalidResponse:
            return "Invalid server response received."
        case .httpError(let statusCode):
            return "Server responded with status code: \(statusCode)."
        case .noData:
            return "No data was returned by the server."
        }
    }
}


public final class PostRepository: PostRepositoryProtocol {
    private let session: URLSession
    private let apiURLString: String

    public init(
        session: URLSession = .shared,
        apiURLString: String = "https://jsonplaceholder.typicode.com/posts"
    ) {
        self.session = session
        self.apiURLString = apiURLString
    }

    public func getPosts() async throws -> [Post] {
        guard let url = URL(string: apiURLString) else {
            throw RepositoryError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw RepositoryError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw RepositoryError.httpError(statusCode: httpResponse.statusCode)
        }

        guard !data.isEmpty else {
            throw RepositoryError.noData
        }

        let postDTOs = try JSONDecoder().decode([PostDTO].self, from: data)

        return postDTOs.map { $0.toDomain() }
    }
}
