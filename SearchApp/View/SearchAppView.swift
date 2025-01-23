//
//  ContentView.swift
//  SearchApp
//
//  Created by Serhii on 23.01.2025.
//

import SwiftUI



struct SearchAppView: View {
    @StateObject var viewModel = SearchAppViewModel()
        
    var body: some View {
           VStack {
               List(viewModel.filteredItems, id: \.id) {
                   Text($0.text)
               }.overlay {
                   if viewModel.isLoading {
                       ProgressView("Searching \"\(viewModel.searchText)\"")
                   } else {
                       if viewModel.filteredItems.isEmpty {
                           Text("Results not found for\n\"\(viewModel.searchText)\"")
                               .multilineTextAlignment(.center)
                       }
                   }
               }
               Button("Export") {
                   print("Button tapped!")
               }.padding()
           }
           .searchable(text: $viewModel.searchText, prompt: "Search")
           .navigationTitle("Search App")
       }
}

#Preview {
    SearchAppView()
}
