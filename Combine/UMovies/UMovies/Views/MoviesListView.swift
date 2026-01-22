//
//  MoviesListView.swift
//  UMovies
//
//  Created by Uday Kumar Kotla on 21/01/26.
//

import SwiftUI
import Combine

struct MoviesListView: View {
    @State private var movies: [Movie] = []
    @State private var filterMovies : [Movie] = []
    @State private var searchText: String = ""
    @State private var filteredText: String = ""
    private let httpClient = HTTPClient()
    private let searchSubject = CurrentValueSubject<String, Never>("")
    @State private var cancellables: Set<AnyCancellable> = []
    private func setupSearch() {
        searchSubject
            .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .sink { searchText in
                httpClient.fetchMovie(name: searchText).sink {
                    completion in
                    switch completion {
                    case .finished : print("Done")
                    case .failure(let error) : print(error)
                    }
                } receiveValue: { movies in
                    self.movies = movies
                    self.filterMovies = movies
                }.store(in: &cancellables)

            }
            .store(in: &cancellables)
    }
    
    var body: some View {
        TextField("filter the Search", text: $filteredText)
        List(filterMovies) { movie in
                HStack{
                    AsyncImage(url: movie.poster) { image in
                        image.resizable().frame(width: 100, height: 100).scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    Text(movie.title)
                }
        }.onAppear(){
            setupSearch()
        }
        .onChange(of: filteredText) { oldValue, newValue in
            if filteredText.isEmpty {
                self.filterMovies = self.movies
            }else{
                filterMovies = self.movies.filter{
               $0.title.lowercased().contains(filteredText.lowercased())
                }
            }
        }
        .searchable(text: $searchText)
            .onChange(of: searchText) { oldValue, newValue in
                searchSubject.send(searchText)
            }
    }
}

#Preview {
    NavigationStack{
        MoviesListView()
    }
}
