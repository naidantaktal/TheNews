//
//  NewsApi.swift
//  TheNews
//
//  Created by Найдан Тактал on 05.02.2023.
//


import Foundation

struct NewsApi {

    static let ApiKey = "dbb7b8c67e5d470c99227bebead4d2c0"

    static func urlForCategory(_ category: String) -> URL? {
        var urlComponents = NewsApi.baseUrlComponents

        urlComponents.path = Path.top.rawValue

        let keyQueryItem = NewsApi.keyQueryItem
        let countryQueryItem = URLQueryItem(name: "country", value: "ru")
        let categoryQueryItem = URLQueryItem(name: "category", value: category)

        urlComponents.queryItems = [ keyQueryItem, countryQueryItem, categoryQueryItem ]

        return urlComponents.url
    }

    static func urlForQuery(_ query: String) -> URL? {
        var urlComponents = NewsApi.baseUrlComponents

        urlComponents.path = Path.search.rawValue

        let keyQueryItem = NewsApi.keyQueryItem
        let languageQueryItem = URLQueryItem(name: "language", value: "ru")
        let queryQueryItem = URLQueryItem(name: "q", value: query)

        urlComponents.queryItems = [ keyQueryItem, languageQueryItem, queryQueryItem ]

        return urlComponents.url
    }

}

private extension NewsApi {
    enum Path: String {
        case top = "/v2/top-headlines"
        case search = "/v2/everything"
    }

    static var baseUrlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"

        return urlComponents
    }

    static var keyQueryItem: URLQueryItem {
        return URLQueryItem(name: "apiKey", value: ApiKey)
    }
}

extension URL {

    func get<T: Codable>(completion: @escaping (Result<T, ApiError>) -> Void) {
        print("get: \(self.absoluteString)")

        let session = URLSession.shared
        let task = session.dataTask(with: self) { data, _, error in
            if let _ = error {
                DispatchQueue.main.async {
                    completion(.failure(.generic))
                }
                return
            }

            guard let unwrappedData = data else {
                DispatchQueue.main.async {
                    completion(.failure(.generic))
                }
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let decoded = try? decoder.decode(T.self, from: unwrappedData) {
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(.generic))
                }
            }
        }

        task.resume()
    }

}

enum ApiError: Error {
    case generic
}
