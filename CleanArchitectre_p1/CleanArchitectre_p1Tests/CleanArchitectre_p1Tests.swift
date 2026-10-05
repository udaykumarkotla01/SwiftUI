//
//  CleanArchitectre_p1Tests.swift
//  CleanArchitectre_p1Tests
//
//  Created by Uday Kumar Kotla on 05/10/26.
//

import XCTest
@testable import CleanArchitectre_p1

// MARK: - Mock URLProtocol for URLSession Network Testing

final class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Handler is not set.")
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

// MARK: - Mock Repository

final class MockPostRepository: PostRepositoryProtocol {
    var result: Result<[Post], Error>?
    private(set) var getPostsCallCount = 0

    func getPosts() async throws -> [Post] {
        getPostsCallCount += 1
        guard let result = result else {
            throw RepositoryError.noData
        }
        switch result {
        case .success(let posts):
            return posts
        case .failure(let error):
            throw error
        }
    }
}

// MARK: - Mock Use Case

final class MockFetchPostsUseCase: FetchPostsUseCaseProtocol {
    var result: Result<[Post], Error>?
    private(set) var executeCallCount = 0

    func execute() async throws -> [Post] {
        executeCallCount += 1
        guard let result = result else {
            throw RepositoryError.noData
        }
        switch result {
        case .success(let posts):
            return posts
        case .failure(let error):
            throw error
        }
    }
}

// MARK: - Unit Tests

final class CleanArchitectre_p1Tests: XCTestCase {

    private var mockSession: URLSession!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: configuration)
    }

    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        mockSession = nil
        super.tearDown()
    }

    // MARK: - 1. DTO to Domain Entity Mapping Tests

    func testPostDTO_MappingToDomainPost() {
        let dto = PostDTO(
            userId: 1,
            id: 101,
            title: "Test Title",
            body: "Test Body"
        )
        let entity = dto.toDomain()

        XCTAssertEqual(entity.userId, 1)
        XCTAssertEqual(entity.id, 101)
        XCTAssertEqual(entity.title, "Test Title")
        XCTAssertEqual(entity.body, "Test Body")
    }

    // MARK: - 2. Direct Repository Network Tests

    func testPostRepository_SuccessfulDataFetchAndMapping() async throws {
        let jsonString = """
        [
            {
                "userId": 1,
                "id": 1,
                "title": "sunt aut facere",
                "body": "quia et suscipit"
            },
            {
                "userId": 1,
                "id": 2,
                "title": "qui est esse",
                "body": "est rerum tempore"
            }
        ]
        """
        let data = jsonString.data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.absoluteString, "https://jsonplaceholder.typicode.com/posts")
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, data)
        }

        let repository = PostRepository(session: mockSession)
        let posts = try await repository.getPosts()

        XCTAssertEqual(posts.count, 2)
        XCTAssertEqual(posts[0].id, 1)
        XCTAssertEqual(posts[0].title, "sunt aut facere")
        XCTAssertEqual(posts[1].id, 2)
        XCTAssertEqual(posts[1].title, "qui est esse")
    }

    func testPostRepository_HttpErrorStatusCode_ThrowsError() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data("Not Found".utf8))
        }

        let repository = PostRepository(session: mockSession)

        do {
            _ = try await repository.getPosts()
            XCTFail("Expected HTTP error to be thrown")
        } catch let error as RepositoryError {
            XCTAssertEqual(error, RepositoryError.httpError(statusCode: 404))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    // MARK: - 3. Use Case Tests

    func testFetchPostsUseCase_ExecutesAndReturnsPosts() async throws {
        let mockRepo = MockPostRepository()
        let expectedPosts = [
            Post(userId: 1, id: 1, title: "Post A", body: "Content A"),
            Post(userId: 2, id: 2, title: "Post B", body: "Content B")
        ]
        mockRepo.result = .success(expectedPosts)

        let useCase = FetchPostsUseCase(repository: mockRepo)
        let posts = try await useCase.execute()

        XCTAssertEqual(mockRepo.getPostsCallCount, 1)
        XCTAssertEqual(posts, expectedPosts)
    }

    func testFetchPostsUseCase_PropagatesRepositoryError() async {
        let mockRepo = MockPostRepository()
        mockRepo.result = .failure(RepositoryError.invalidResponse)

        let useCase = FetchPostsUseCase(repository: mockRepo)

        do {
            _ = try await useCase.execute()
            XCTFail("Expected use case to throw")
        } catch let error as RepositoryError {
            XCTAssertEqual(error, RepositoryError.invalidResponse)
            XCTAssertEqual(mockRepo.getPostsCallCount, 1)
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }

    // MARK: - 4. ViewModel State & Search Tests

    @MainActor
    func testPostListViewModel_FetchPostsSuccess_TransitionsToLoadedState() async {
        let mockUseCase = MockFetchPostsUseCase()
        let samplePosts = [
            Post(userId: 1, id: 1, title: "Clean Architecture in SwiftUI", body: "Direct URLSession call in Repository."),
            Post(userId: 1, id: 2, title: "Swift Concurrency", body: "Async await and actors.")
        ]
        mockUseCase.result = .success(samplePosts)

        let viewModel = PostListViewModel(fetchPostsUseCase: mockUseCase)
        XCTAssertEqual(viewModel.state, .idle)

        await viewModel.fetchPosts()

        XCTAssertEqual(viewModel.state, .loaded(samplePosts))
        XCTAssertEqual(viewModel.filteredPosts.count, 2)
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
    }

    @MainActor
    func testPostListViewModel_FetchPostsFailure_TransitionsToErrorState() async {
        let mockUseCase = MockFetchPostsUseCase()
        mockUseCase.result = .failure(RepositoryError.httpError(statusCode: 500))

        let viewModel = PostListViewModel(fetchPostsUseCase: mockUseCase)
        XCTAssertEqual(viewModel.state, .idle)

        await viewModel.fetchPosts()

        if case .error(let message) = viewModel.state {
            XCTAssertTrue(message.contains("500"))
        } else {
            XCTFail("Expected error state, got: \(viewModel.state)")
        }
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
    }

    @MainActor
    func testPostListViewModel_SearchFiltering() async {
        let mockUseCase = MockFetchPostsUseCase()
        let samplePosts = [
            Post(userId: 1, id: 1, title: "SwiftUI Architecture", body: "View ViewModel UseCase"),
            Post(userId: 2, id: 2, title: "Networking in Swift", body: "URLSession and Decodable"),
            Post(userId: 3, id: 3, title: "Unit Testing", body: "Mocking dependencies with protocols")
        ]
        mockUseCase.result = .success(samplePosts)

        let viewModel = PostListViewModel(fetchPostsUseCase: mockUseCase)
        await viewModel.fetchPosts()

        // Empty search text returns all posts
        viewModel.searchText = ""
        XCTAssertEqual(viewModel.filteredPosts.count, 3)

        // Search matching title
        viewModel.searchText = "SwiftUI"
        XCTAssertEqual(viewModel.filteredPosts.count, 1)
        XCTAssertEqual(viewModel.filteredPosts.first?.id, 1)

        // Search matching body
        viewModel.searchText = "URLSession"
        XCTAssertEqual(viewModel.filteredPosts.count, 1)
        XCTAssertEqual(viewModel.filteredPosts.first?.id, 2)

        // Search matching nothing
        viewModel.searchText = "NonExistingKeyword"
        XCTAssertEqual(viewModel.filteredPosts.count, 0)
    }

    @MainActor
    func testPostListViewModel_Refresh() async {
        let mockUseCase = MockFetchPostsUseCase()
        let initialPosts = [Post(userId: 1, id: 1, title: "First Post", body: "Initial body")]
        let updatedPosts = [
            Post(userId: 1, id: 1, title: "First Post", body: "Initial body"),
            Post(userId: 1, id: 2, title: "Second Post", body: "New body")
        ]

        mockUseCase.result = .success(initialPosts)
        let viewModel = PostListViewModel(fetchPostsUseCase: mockUseCase)
        await viewModel.fetchPosts()
        XCTAssertEqual(viewModel.filteredPosts.count, 1)

        mockUseCase.result = .success(updatedPosts)
        await viewModel.refresh()
        XCTAssertEqual(viewModel.filteredPosts.count, 2)
        XCTAssertEqual(mockUseCase.executeCallCount, 2)
    }
}
