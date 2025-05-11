//
//  ModelTests.swift
//  SearchBook-iOSTests
//
//  Created by USER on 5/11/25.
//

import XCTest
@testable import SearchBook_iOS

class ModelTests: XCTestCase {
    
    func testModel_bookList_success() {
        // Given
        guard let url = Bundle(for: type(of: self)).url(forResource: "bookList",
                                                        withExtension: "json") else {
            XCTFail()
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            // When
            let bookList = try decoder.decode(BookList.self, from: data)
            
            // Then
            XCTAssertTrue(bookList.books.count > 0)
        } catch {
            XCTFail()
        }
    }
    
    func testBook_searchBookAPI_success() {
        // Given
        guard let url = Bundle(for: type(of: self)).url(forResource: "book",
                                                        withExtension: "json") else {
            XCTFail()
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            // When
            let book = try decoder.decode(Book.self, from: data)
            
            // Then
            XCTAssertEqual(book.title, "Trustworthy AI")
            XCTAssertEqual(book.subtitle, "A Business Guide for Navigating Trust and Ethics in AI")
            XCTAssertEqual(book.price, "$37.08")
            XCTAssertEqual(book.imageURLString, "https://itbook.store/img/books/9781119867920.png")
        } catch {
            XCTFail()
        }
    }
}
