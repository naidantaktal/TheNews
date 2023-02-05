//
//  UserDefault.swift
//  TheNews
//
//  Created by Найдан Тактал on 05.02.2023.
//

import Foundation

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            guard let saved = UserDefaults.standard.object(forKey: key) as? Data,
                  let decoded = try? JSONDecoder().decode(T.self, from: saved) else { return defaultValue }

            return decoded
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }
    }
}
