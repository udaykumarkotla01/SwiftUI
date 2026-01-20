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


// error handling



