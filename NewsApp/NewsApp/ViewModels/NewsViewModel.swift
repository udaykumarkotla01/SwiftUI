//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Uday Kumar Kotla on 09/02/26.
//

import Foundation

@MainActor
@Observable
public class NewsViewModel{
    var newsModel : Article = Article(data: data)
    var isLoading : Bool = false
    var errorMsg : String? = nil
    
    private let API_KEY = APIKEY
    
    func fetch_Headlines() async{
        isLoading = true
        errorMsg = nil
        
        let urlString = "https://api.thenewsapi.com/v1/news/top?api_token=\(API_KEY)&locale=us&limit=10"
        guard let url = URL(string: urlString) else{
           isLoading = false
            errorMsg = "Failed to Load..."
            return
        }
        do{
            let(data, _) = try await URLSession.shared.data(from: url)
            newsModel = try JSONDecoder().decode(Article.self, from: data)
        }catch{
            errorMsg = "Server broken...Try after sometime."
        }
        isLoading = false
    }
    
}


 var data = [
     Datum(
         uuid: "16a7cbcc-6480-4c95-a1fb-557037778382",
         title: "Trump has a plan to steal the midterms. It will probably fail.",
         description: "The threat of Donald Trump trying to rig the 2026 midterm elections has never been higher. After the FBI’s raid of an election office in Fulton County — mys...",
         url: "https://www.vox.com/politics/478263/trump-midterms-2026-rigged-election-fulton-county-gabbard-bondi",
         imageURL: "https://platform.vox.com/wp-content/uploads/sites/2/2026/02/gettyimages-2257975335.jpg?quality=90&strip=all&crop=0%2C10.732984293194%2C100%2C78.534031413613&w=1200",
         publishedAt: "2026-02-09T11:09:25.000000Z"
     ),
     Datum(
         uuid: "7783c728-87b5-435b-9d18-c1bd9f66c8e4",
         title: "The 2-pronged GOP plot to make it harder to get an abortion",
         description: "Anti-abortion officials want to shutter Planned Parenthood — and make it harder to get abortion medication.",
         url: "https://www.salon.com/2026/02/09/the-new-2-pronged-gop-approach-to-make-it-harder-to-get-an-abortion-partner/",
         imageURL: "https://www.salon.com/app/uploads/2024/02/planned_parenthood_1241517147.jpg",
         publishedAt: "2026-02-09T11:00:54.000000Z"
     ),
     Datum(
         uuid: "bc3d6c29-1ead-4cf4-8e9b-6a060431fa65",
         title: "I Offered to Babysit My Sister-in-Law’s Kids. Then I Saw What She’s Really Up To.",
         description: "She's taking advantage of me.",
         url: "https://slate.com/advice/2026/02/family-advice-child-care-late-favor.html?via=rss",
         imageURL: "https://compote.slate.com/images/5b5c10f1-93ea-4ee2-ae6e-0406e8a2f622.jpeg?crop=1560%2C1040%2Cx0%2Cy0&width=1560",
         publishedAt: "2026-02-09T11:00:00.000000Z"
     )
 ]

