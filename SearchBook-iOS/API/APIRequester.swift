//
//  APIRequester.swift
//  SearchBook-iOS
//
//  Created by USER on 5/11/25.
//

import Foundation

struct API {
    static let itbook = "https://api.itbook.store/1.0"
    static let searchBookList = "\(itbook)/search"
}

class APIRequester {
    static let shared = APIRequester()
    
    enum APIError: Error {
        case invalidURL
        case loadFailed
        case noData
    }
    
    func searchBookList(keyword: String, page: Int, completion: @escaping (Result<[Book], Error>) -> Void) {
        let urlString = "\(API.searchBookList)/\(keyword)/\(page)"
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            guard let data else {
                completion(.failure(APIError.loadFailed))
                return
            }
            
            do {
                let bookList = try JSONDecoder().decode(BookList.self, from: data)
                if bookList.books.isEmpty {
                    completion(.failure(APIError.noData))
                } else {
                    completion(.success(bookList.books))
                }
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
}

