//
//  UserDefaultsManager.swift
//  SearchApp
//
//  Created by Serhii on 24.01.2025.
//
import Foundation

class UserDefaultsManager {
    // MARK: - Singleton Instance
    static let shared = UserDefaultsManager()
    
    private init() {} // Prevent external instantiation
    
    // MARK: - Keys
    private let lastSearchQueriesKey = "LastSearchQueries"
    private let isCaseSensitiveKey = "IsCaseSensitive"
    private let userPreferredThemeKey = "UserPreferredTheme"
    
    // MARK: - Properties
    var lastSearchQueries: [String] {
        get {
            UserDefaults.standard.stringArray(forKey: lastSearchQueriesKey) ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: lastSearchQueriesKey)
        }
    }
    
    var isCaseSensitive: Bool {
        get {
            UserDefaults.standard.bool(forKey: isCaseSensitiveKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isCaseSensitiveKey)
        }
    }
    
    // MARK: - Methods
    func clearAll() {
        UserDefaults.standard.removeObject(forKey: lastSearchQueriesKey)
        UserDefaults.standard.removeObject(forKey: isCaseSensitiveKey)
    }
}
