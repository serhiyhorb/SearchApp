//
//  SearchAppViewModel.swift
//  SearchApp
//
//  Created by Serhii on 23.01.2025.
//

import Foundation
import Combine
import CoreServices.SearchKit
import AppKit

class SearchAppViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var isCaseSensitive: Bool  = UserDefaultsManager.shared.isCaseSensitive {
        didSet {
            UserDefaultsManager.shared.isCaseSensitive = isCaseSensitive
            performSearch(with: searchText)
        }
    }
    @Published var lastSearchQueries: [String] = UserDefaultsManager.shared.lastSearchQueries {
          didSet {
              UserDefaultsManager.shared.lastSearchQueries = lastSearchQueries
          }
      }
      
    @Published var filteredItems: [Item]
    private var items: [Item]
    
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
            // Perform case-sensitive or case-insensitive filtering
            let result: [Item] = self.items.filter { item in
                if self.isCaseSensitive {
                    return item.text.contains(query)
                } else {
                    return item.text.lowercased().contains(query.lowercased())
                }
            }
            // Sort the result so that items starting with the search query come first
            let sortedResult = result.sorted { item1, item2 in
                let item1StartsWithQuery = item1.text.lowercased().hasPrefix(query.lowercased())
                let item2StartsWithQuery = item2.text.lowercased().hasPrefix(query.lowercased())
                
                if item1StartsWithQuery == item2StartsWithQuery {
                    // If both start with the query or both don't, sort alphabetically
                    return item1.text < item2.text
                }
                return item1StartsWithQuery // Prioritize items starting with the query
            }
            DispatchQueue.main.async {
                self.filteredItems = sortedResult
                self.isLoading = false
                self.addQueryToHistory(query)
                
            }
        }
    }
    
    func exportTextFile() {
        let data = filteredItems.map { $0.text }.joined(separator: "\n")
        if data.isEmpty {
            // Show a warning alert
            let alert = NSAlert()
            alert.messageText = "No Data to Save"
            alert.informativeText = "There is no data to save. Please perform a search first."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
            return
        }
        let savePanel = NSSavePanel()
        savePanel.title = "Save File"
        savePanel.allowedFileTypes = ["txt"]
        savePanel.canCreateDirectories = true
       
        // Display the save panel
        if let window = NSApplication.shared.windows.first {
          savePanel.beginSheetModal(for: window) { response in
              if response == .OK, let url = savePanel.url {
                  do {
                      try data.write(to: url, atomically: true, encoding: .utf8)
                      print("File saved successfully at \(url.path)")
                  } catch {
                      print("Failed to save file: \(error.localizedDescription)")
                  }
              }
          }
        }
    }
    
    func reset() {
        searchText = ""
        lastSearchQueries.removeAll()
        isCaseSensitive = false
        UserDefaultsManager.shared.clearAll()
    }
    
    private func addQueryToHistory(_ query: String) {
        guard !query.isEmpty else { return }
        // Check if the query already exists in the history
        if let existingIndex = lastSearchQueries.firstIndex(of: query) {
            // Move the existing query to the front
            lastSearchQueries.remove(at: existingIndex)
        }
        // Insert the new query at the front
        lastSearchQueries.insert(query, at: 0)
        
        // Ensure the history contains only the 5 most recent queries
        if lastSearchQueries.count > 5 {
            lastSearchQueries.removeLast()
        }
    }
}
