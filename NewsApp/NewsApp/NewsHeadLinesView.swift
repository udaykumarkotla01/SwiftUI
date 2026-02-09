//
//  ContentView.swift
//  NewsApp
//
//  Created by Uday Kumar Kotla on 09/02/26.
//

import SwiftUI

struct NewsHeadLinesView: View {
    @State private var vm = NewsViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.purple.opacity(0.5),.blue.opacity(0.5),], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .blur(radius: 40)
                    .ignoresSafeArea()
                
                if(vm.isLoading){
                    ProgressView("Loading..")
                }else{
                    VStack{
                        ForEach(vm.article.data,id: \.id){
                            article in
                            Text(article.title)
                        }
                    }
                    
                }
                
            }.navigationTitle("Top Headlines")
                .task {
                    //await vm.fetch_Headlines()
                }
        }
    }
}

#Preview {
    NewsHeadLinesView()
}
