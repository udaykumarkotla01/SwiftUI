//
//  PostListView.swift
//  CleanArchitectre_p1
//
//  Created by Uday Kumar Kotla on 01/10/26.
//

import SwiftUI

public struct PostListView: View {
    @StateObject private var viewModel: PostListViewModel

    public init(viewModel: PostListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    loadingView
                case .loaded:
                    contentView
                case .error(let message):
                    ErrorView(message: message) {
                        Task {
                            await viewModel.fetchPosts()
                        }
                    }
                }
            }
            .navigationTitle("Clean Architecture Posts")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $viewModel.searchText, prompt: "Search by title or body...")
            .task {
                if case .idle = viewModel.state {
                    await viewModel.fetchPosts()
                }
            }
        }
    }


    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.3)
            Text("Fetching posts...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var contentView: some View {
        Group {
         
                List(viewModel.filteredPosts) { post in
                    NavigationLink(destination: PostDetailView(post: post)) {
                        PostRowView(post: post)
                    }
                }
                .listStyle(.insetGrouped)
                .refreshable {
                    await viewModel.refresh()
                }
            
        }
    }
}

#Preview {
    struct MockFetchPostsUseCase: FetchPostsUseCaseProtocol {
        func execute() async throws -> [Post] {
            return [
                Post(userId: 1, id: 1, title: "Mock Post One", body: "This is sample body text for post number one."),
                Post(userId: 1, id: 2, title: "Mock Post Two", body: "This is sample body text for post number two.")
            ]
        }
    }

    return PostListView(
        viewModel: PostListViewModel(fetchPostsUseCase: MockFetchPostsUseCase())
    )
}
