import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// MARK: - Models

struct UserResponse: Codable {
    let data: [User]
}

struct User: Codable {
    let about: String?
}

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
}

// MARK: - Function

func getAuthorHistory(author: String) -> [String] {
    var history: [String] = []
    let semaphore = DispatchSemaphore(value: 0)
    
    // 1️⃣ Fetch Author Info
    if let userURL = URL(string: "https://jsonmock.hackerrank.com/api/article_users?username=\(author)") {
        
        URLSession.shared.dataTask(with: userURL) { data, response, error in
            defer { semaphore.signal() }
            
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode(UserResponse.self, from: data)
                
                if let about = decoded.data.first?.about,
                   !about.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    history.append(about)
                }
            } catch {
                print("User decode error:", error)
            }
        }.resume()
        
        semaphore.wait()
    }
    
    // 2️⃣ Fetch Articles (Handle Pagination)
    
    var currentPage = 1
    var totalPages = 1
    
    repeat {
        if let articlesURL = URL(string: "https://jsonmock.hackerrank.com/api/articles?author=\(author)&page=\(currentPage)") {
            
            URLSession.shared.dataTask(with: articlesURL) { data, response, error in
                defer { semaphore.signal() }
                
                guard let data = data else { return }
                
                do {
                    let decoded = try JSONDecoder().decode(ArticleResponse.self, from: data)
                    
                    totalPages = decoded.total_pages
                    
                    for article in decoded.data {
                        if let title = article.title,
                           !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            history.append(title)
                        } else if let storyTitle = article.story_title,
                                  !storyTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            history.append(storyTitle)
                        }
                    }
                    
                } catch {
                    print("Article decode error:", error)
                }
            }.resume()
            
            semaphore.wait()
        }
        
        currentPage += 1
        
    } while currentPage <= totalPages
    
    return history
}

// MARK: - Example Run

let result = getAuthorHistory(author: "epaga")

for item in result {
    print(item)
}

PlaygroundPage.current.finishExecution()
