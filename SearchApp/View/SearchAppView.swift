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
               Text("Search App")
                   .font(.largeTitle)
                   .padding()
               SearchBar(searchText: $viewModel.searchText)
                   .padding()
               Table(viewModel.items) {
                   TableColumn("Name", value: \.text)
                   
               }
               .frame(minWidth: 400, minHeight: 300)
               .padding()
               
               Button("Export") {
                   print("Button tapped!")
               }.padding()
           }
       }
}

#Preview {
    SearchAppView()
}
