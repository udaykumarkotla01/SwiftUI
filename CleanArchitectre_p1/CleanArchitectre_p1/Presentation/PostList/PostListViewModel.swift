//
//  PostListViewModel.swift
//  CleanArchitectre_p1
//
//  Created by Uday Kumar Kotla on 01/10/26.
//

import Foundation
import Combine

@MainActor
public final class PostListViewModel: ObservableObject {
    @Published public private(set) var state: ViewState<[Post]> = .idle
    @Published public var searchText: String = ""
    
    private let fetchPostsUseCase: FetchPostsUseCaseProtocol
    private var allPosts: [Post] = []
    
    public init(fetchPostsUseCase: FetchPostsUseCaseProtocol) {
        self.fetchPostsUseCase = fetchPostsUseCase
    }
    

    public var filteredPosts: [Post] {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return allPosts
        }
        return allPosts.filter { post in
            post.title.localizedCaseInsensitiveContains(searchText) ||
            post.body.localizedCaseInsensitiveContains(searchText)
        }
    }
    

    public func fetchPosts() async {
        if case .loading = state { return }
        
        state = .loading
        
        do {
            let posts = try await fetchPostsUseCase.execute()
            self.allPosts = posts
            self.state = .loaded(posts)
        } catch let localizedError as LocalizedError {
            self.state = .error(localizedError.errorDescription ?? localizedError.localizedDescription)
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }
    
    public func refresh() async {
        do {
            let posts = try await fetchPostsUseCase.execute()
            self.allPosts = posts
            self.state = .loaded(posts)
        } catch let localizedError as LocalizedError {
            self.state = .error(localizedError.errorDescription ?? localizedError.localizedDescription)
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }
}
