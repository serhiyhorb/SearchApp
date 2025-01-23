//
//  SearchAppViewModel.swift
//  SearchApp
//
//  Created by Serhii on 23.01.2025.
//

import Foundation

class SearchAppViewModel: ObservableObject {
    @Published var items: [Item]
    
    @Published var searchText: String {
        didSet {
            //todo update items
        }
    }
    
    init() {
        searchText = ""
        self.items = [
            Item(text: "test"),
            Item(text: "test"),
            Item(text: "test"),
            Item(text: "test"),
            Item(text: "test"),
            Item(text: "test"),
            Item(text: "test"),
            Item(text: "test"),
            Item(text: "test"),
            Item(text: "test"),
            Item(text: "test")
        ]
    }
}
