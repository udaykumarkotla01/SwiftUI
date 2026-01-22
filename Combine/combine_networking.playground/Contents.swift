import UIKit
import Combine

/**
 
 [
   {
     "userId": 1,
     "id": 1,
     "title": "are or make repel provide blinded except option reprehend",
     "body": "because and undertakes\ntakes upon the objections that follow expeditiously and when\nreprehends the annoyances as which all\nour things are but are things happen to the architect"
   },
 ]
 */

enum NetworkError:Error{
    case badResponse
}

class Post:Codable{
    var userId, id  : Int
    var title, body : String
}

func fetchPosts() -> AnyPublisher<[Post],Error>{
    URLSession.shared.dataTaskPublisher(for: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
//        .map(\.data)
        .tryMap({ data , response in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw NetworkError.badResponse
            }
            return data
        })
        .decode(type: [Post].self, decoder: JSONDecoder())
        .retry(2) // ERROR HANDLING CASE
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher() // hide specific type - more of abstract type
}

let postsPublisher1 = fetchPosts()
print("Approach 1")
let cancellable = postsPublisher1
    .flatMap({ val in
    val.publisher
})
    .sink(receiveCompletion: {
    completion in
    switch completion{
    case .finished: print("Done approach1")
    case .failure(let error): print("Failed 1: \(error)")
    }
    }, receiveValue: {
        print("\($0.id) - \($0.title)")
    })

print("Approach 2")
var canellables = Set<AnyCancellable>()
fetchPosts()
    .flatMap({ val in
    val.publisher
})
.sink(receiveCompletion: {
completion in
switch completion{
case .finished: print("Done appproach2")
case .failure(let error): print("Failed 2 \(error)")
}
}, receiveValue: {
    print($0.title)
})
.store(in: &canellables)



// Movies Api example

/**
 
  http://www.omdbapi.com/?i=tt3896198&apikey=18ba4c3d
  
  {
 "Search": [
   {
     "Title": "Bahubali",
     "Year": "2008–2009",
     "imdbID": "tt4549714",
     "Type": "series",
     "Poster": "https://m.media-amazon.com/images/M/MV5BMGNjMjRjY2QtOTNiNi00ZmE0LTkwNjYtYTVhNDE2Yzk0OTZhXkEyXkFqcGc@._V1_SX300.jpg"
   },
   {
     "Title": "Hum Bahubali",
     "Year": "2008",
     "imdbID": "tt5216536",
     "Type": "movie",
     "Poster": "N/A"
   },
   {
     "Title": "Gommateshwara Lord Bahubali",
     "Year": "2018",
     "imdbID": "tt8093880",
     "Type": "movie",
     "Poster": "https://m.media-amazon.com/images/M/MV5BODVlOWViZTctZjJmNC00YmUyLTg0ODItYzgxNWRmM2NjNGM4XkEyXkFqcGdeQXVyMjY1NzA0Nzc@._V1_SX300.jpg"
   },
   {
     "Title": "Bhojpuri Ke Sabse Bade Bhaiya Bahubali Bhaiya Ji",
     "Year": "2019",
     "imdbID": "tt33111896",
     "Type": "movie",
     "Poster": "N/A"
   },
 ]
 */
struct MovieResponse : Codable {
    let search: [Movie]
    private enum CodingKeys : String , CodingKey{
        case search = "Search"
    }
}

struct Movie : Codable{
    let title : String
    private enum CodingKeys : String , CodingKey{
        case title = "Title"
    }
}

func fetchMovie(_ movieName : String) -> AnyPublisher<MovieResponse , Error>{
    URLSession.shared.dataTaskPublisher(for: URL(string:"https://www.omdbapi.com/?s=\(movieName)&apikey=18ba4c3d")!)
        .map(\.data)
        .decode(type: MovieResponse.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
}

let spiderManMovies = fetchMovie("spiderman")
spiderManMovies
    .flatMap { $0.search.publisher }
    .sink { completion in
        switch completion{
        case .finished : print("movie fetch completed")
        case .failure( let error) : print("movies error")
        }
    } receiveValue: { val in
        print("Movie name: \(val.title)")
    }.store(in: &canellables)


