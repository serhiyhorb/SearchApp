//
//  SearchBar.swift
//  SearchApp
//
//  Created by Serhii on 23.01.2025.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.gray)
            TextField("Search...", text: $searchText)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color.black)
        }.frame(height: 20)
    }
}

struct SearchBarPreviews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant(""))
            .padding()
    }
}
