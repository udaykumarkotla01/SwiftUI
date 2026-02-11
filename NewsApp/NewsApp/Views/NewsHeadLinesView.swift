//
//  ContentView.swift
//  NewsApp
//
//  Created by Uday Kumar Kotla on 09/02/26.
//

import SwiftUI
import WebKit

struct NewsHeadLinesView: View {
    @State private var vm = NewsViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
//                LinearGradient(colors: [.blue.opacity(0.5),.white.opacity(0.5),], startPoint: .topLeading, endPoint: .bottomTrailing)
//                    .blur(radius: 40)
//                    .ignoresSafeArea(
                
                if(vm.isLoading){
                    ProgressView("Loading..")
                        .font(.headline)
                        .padding()
                        .background(.ultraThinMaterial,in: RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 10)
                }else{
                    List{
                        ForEach(vm.newsModel.data,id: \.id){ article in
                            NavigationLink{
                                WebView(url: URL(string:article.url))
                            }label: {
                                ArticleRowView(datum: article)
                            }
                            
                        }
                    }
                }
                
            }
            .alert("Error"
                   , isPresented: .constant(vm.errorMsg != nil), actions: {
                Button("OK"){
                    vm.errorMsg = nil
                }
            },message: {
                Text(vm.errorMsg ?? "")
            })
            .navigationTitle("Top Headlines")
                .task {
                    await vm.fetch_Headlines()
                }
                .refreshable {
                    await vm.fetch_Headlines()
                }
        }
    }
}

#Preview {
    NewsHeadLinesView()
}
