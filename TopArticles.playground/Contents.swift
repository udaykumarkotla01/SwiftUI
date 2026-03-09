import Foundation
import PlaygroundSupport

//PlaygroundPage.current.needsIndefiniteExecution = true

// MARK: - Models

struct ArticleResponse: Codable {
    let page: Int
    let per_page: Int
    let total: Int
    let total_pages: Int
    let data: [Article]
}

struct Article: Codable {
    let title: String?
    let story_title: String?
    let num_comments: Int?
}

// MARK: - Function

func topArticles(limit: Int) -> [String] {
    
    var allArticles: [(name: String, comments: Int)] = []
    //let semaphore = DispatchSemaphore(value: 0)
    let group = DispatchGroup()
   let queue = DispatchQueue(label: "safe.queue")
    var currentPage = 1
    var totalPages = 1
    repeat {
        if let url = URL(string: "https://jsonmock.hackerrank.com/api/articles?page=\(currentPage)") {
            group.enter()
            URLSession.shared.dataTask(with: url) { data, response, error in
                defer {
                    //semaphore.signal()
                    group.leave()
                }
                
                guard let data = data else { return }
                
                do {
                    let decoded = try JSONDecoder().decode(ArticleResponse.self, from: data)
                    
                    totalPages = decoded.total_pages
                    
                    for article in decoded.data {
                        
                        var articleName: String?
                        
                        if let title = article.title,
                           !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            articleName = title
                        } else if let storyTitle = article.story_title,
                                  !storyTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            articleName = storyTitle
                        }
                        
                        if let name = articleName {
                            let comments = article.num_comments ?? 0
                            allArticles.append((name, comments))
                        }
                    }
                    
                } catch {
                    print("Decoding error:", error)
                }
            }.resume()
            group.wait()
            //semaphore.wait()
        }
        
        currentPage += 1
        
    } while currentPage <= totalPages
    
    // Sort:
    // Decreasing by comment count
    // Decreasing alphabetically if tie
    
    allArticles.sort {
        if $0.comments == $1.comments {
            return $0.name > $1.name   // descending alphabetical
        }
        return $0.comments > $1.comments
    }
    
    return Array(allArticles.prefix(limit).map { $0.name })
}

// MARK: - Example

let result = topArticles(limit: 2)

for title in result {
    print(title)
}

//PlaygroundPage.current.finishExecution()
