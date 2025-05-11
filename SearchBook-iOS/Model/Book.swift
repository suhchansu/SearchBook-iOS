//
//  Book.swift
//  SearchBook-iOS
//
//  Created by USER on 5/11/25.
//

import Foundation

struct BookList: Codable {
    let error: Int
    let total: Int
    let page: Int
    let books: [Book]
    
    // error, total, page를 Int로 변환
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let errorString = try container.decode(String.self, forKey: .error)
        let totalString = try container.decode(String.self, forKey: .total)
        let pageString = try container.decode(String.self, forKey: .page)
        
        self.error = Int(errorString) ?? -1
        self.total = Int(totalString) ?? 0
        self.page = Int(pageString) ?? 0
        self.books = try container.decode([Book].self, forKey: .books)
    }
}

struct Book: Codable {
    // API.searchBookList 모델
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let imageURLString: String
    let urlString: String

    // API.searchBook 모델
    let error: String?
    let authors: String?
    let publisher: String?
    let language: String?
    let isbn10: String?
    let pages: String?
    let year: String?
    let rating: String?
    let desc: String?
    
    enum CodingKeys: String, CodingKey {
        case title, subtitle, isbn13, price
        // respone에서 image, url 2개는 형태에 맞는 이름으로 변경
        case imageURLString = "image"
        case urlString = "url"
        case error, authors, publisher, language, isbn10, pages, year, rating, desc
    }
}
