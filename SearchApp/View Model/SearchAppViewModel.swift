//
//  SearchAppViewModel.swift
//  SearchApp
//
//  Created by Serhii on 23.01.2025.
//

import Foundation
import Combine
import CoreServices.SearchKit

class SearchAppViewModel: ObservableObject {
    @Published var filteredItems: [Item]
    private var items: [Item]
    
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>() // To store Combine subscriptions
    
    init() {
        self.filteredItems = []
        self.items = []
        setupSearchPublisher()
        loadData()
    }
    
    func loadData() {
        do {
            // Read the file content.
            if let url = Bundle.main.url(forResource: "dictionary", withExtension: "txt") {
                let content = try String(contentsOf: url, encoding: .utf8)
                let words = content.split(separator: "\n")
                for word in words {
                    items.append(Item(text: String(word)))
                }
                filteredItems = items
            }
        } catch {
            print("Error reading file: \(error)")
        }
    }
    
    private func setupSearchPublisher() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main) // Add debounce delay
            .removeDuplicates() // Avoid processing the same value multiple times
            .sink { [weak self] query in
                self?.performSearch(with: query)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(with query: String) {
        guard !query.isEmpty else {
            self.filteredItems = self.items
            self.isLoading = false
            return
        }
        
        self.isLoading = true
        self.filteredItems = []
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let result = self.items.filter { $0.text.contains(query) }
            DispatchQueue.main.async {
                self.filteredItems = result
                self.isLoading = false
            }
        }
    }
}
