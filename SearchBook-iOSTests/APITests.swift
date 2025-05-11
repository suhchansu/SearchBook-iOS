//
//  APITests.swift
//  SearchBook-iOSTests
//
//  Created by USER on 5/11/25.
//

import XCTest
@testable import SearchBook_iOS

class APITests: XCTestCase {
    
    func testAPI_searchBookList_success() {
        // Given
        let keyword = "AI"
        let page = 1
        
        // When
        APIRequester.shared.searchBookList(keyword: keyword, page: page) {
            switch $0 {
            case .success(let bookList):
                // Then
                XCTAssertTrue(bookList.count > 0)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testAPI_searchBook_success() {
        // Given
        let isbn13 = "9781119867920"
        
        // When
        APIRequester.shared.searchBook(isbn13: isbn13) {
            switch $0 {
            case .success(let book):
                // Then
                XCTAssertEqual(book.title, "Trustworthy AI")
                XCTAssertEqual(book.subtitle, "A Business Guide for Navigating Trust and Ethics in AI")
                XCTAssertEqual(book.price, "$37.08")
                XCTAssertEqual(book.imageURLString, "https://itbook.store/img/books/9781119867920.png")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
}
