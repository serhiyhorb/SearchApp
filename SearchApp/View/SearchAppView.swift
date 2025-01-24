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
               Button("Export to File") {
                   viewModel.exportTextFile()
             }.padding()
           }
           .searchable(text: $viewModel.searchText, prompt: "Search")
           .navigationTitle("Search App")
           .toolbar {
               ToolbarItem(placement: .automatic) {
                   Menu("Options") {
                       // Search History Section
                       Menu("Search History") {
                           if viewModel.lastSearchQueries.isEmpty {
                               Text("No search history yet.")
                           }
                           ForEach(viewModel.lastSearchQueries, id: \.self) { query in
                               Button(query) {
                                   viewModel.searchText = query
                               }
                           }
                       }
                       Divider()
                       // Case Sensitive Toggle Section
                       Section {
                           Toggle(isOn: $viewModel.isCaseSensitive) {
                               Text("Case Sensitive")
                           }
                       }
                       Divider()
                       // Reset Button Section
                       Section {
                           Button("Reset") {
                               viewModel.reset()
                           }
                       }
                   }
               }
           }
       }
}

#Preview {
    SearchAppView()
}
