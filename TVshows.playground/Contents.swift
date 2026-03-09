import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// MARK: - Models

struct TVResponse: Codable {
    let page: Int
    let per_page: Int
    let total: Int
    let total_pages: Int
    let data: [TVShow]
}

struct TVShow: Codable {
    let name: String
    let runtime_of_series: String
}

// MARK: - Helper

func extractYears(from runtime: String) -> (start: Int?, end: Int?) {
    
    var cleaned = runtime
        .replacingOccurrences(of: "(I)", with: "")
        .replacingOccurrences(of: "(II)", with: "")
        .trimmingCharacters(in: .whitespaces)
    
    cleaned = cleaned
        .replacingOccurrences(of: "(", with: "")
        .replacingOccurrences(of: ")", with: "")
    
    if cleaned.contains("-") {
        let parts = cleaned.split(separator: "-")
        let start = Int(parts[0])
        let end = parts.count > 1 && !parts[1].isEmpty ? Int(parts[1]) : nil
        return (start, end)
    } else {
        let year = Int(cleaned)
        return (year, year)
    }
}

// MARK: - Safe Version

func fetchPage(page: Int) -> (shows: [TVShow], totalPages: Int)? {
    
    let semaphore = DispatchSemaphore(value: 0)
    var result: (shows: [TVShow], totalPages: Int)?
    
    let url = URL(string: "https://jsonmock.hackerrank.com/api/tvseries?page=\(page)")!
    
    URLSession.shared.dataTask(with: url) { data, _, _ in
        defer { semaphore.signal() }
        
        guard let data = data else { return }
        
        if let decoded = try? JSONDecoder().decode(TVResponse.self, from: data) {
            result = (decoded.data, decoded.total_pages)
        }
    }.resume()
    
    semaphore.wait()
    return result
}

func showsInProduction(startYear: Int, endYear: Int) -> [String] {
    
    var results: [String] = []
    
    guard let firstPage = fetchPage(page: 1) else { return [] }
    
    let totalPages = firstPage.totalPages
    let allPagesData = [firstPage.shows] +
        (2...totalPages).compactMap { fetchPage(page: $0)?.shows }
    
    for pageShows in allPagesData {
        for show in pageShows {
            
            let years = extractYears(from: show.runtime_of_series)
            guard let start = years.start else { continue }
            
            if endYear == -1 {
                if start >= startYear && years.end == nil {
                    results.append(show.name)
                }
            } else {
                guard let end = years.end else { continue }
                if start >= startYear && end <= endYear {
                    results.append(show.name)
                }
            }
        }
    }
    
    return results.sorted()
}

// Example
let result = showsInProduction(startYear: 2006, endYear: 2011)
print(result)

PlaygroundPage.current.finishExecution()
