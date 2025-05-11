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
                XCTFail("\(error)")
            }
        }
    }
}
