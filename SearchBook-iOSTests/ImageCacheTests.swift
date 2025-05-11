//
//  ImageCacheTests.swift
//  SearchBook-iOSTests
//
//  Created by USER on 5/11/25.
//

import XCTest
@testable import SearchBook_iOS

class ImageCacheTests: XCTestCase {
    var book: Book?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        guard let url = Bundle(for: type(of: self)).url(forResource: "book",
                                                        withExtension: "json") else {
            XCTFail()
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let book = try decoder.decode(Book.self, from: data)
            self.book = book
        } catch {
            XCTFail()
        }
    }
        
        
    func testImageCache_memory_success() async throws {
        guard let book else {
            XCTFail()
            return
        }
        
        let image = try await ImageCache.shared.loadImage(book: book, cacheOption: .memory)
        XCTAssertNotNil(image)
        
        let cachedImage = ImageCache.shared.memoryCache.object(forKey: book.isbn13 as NSString)
        XCTAssertNotNil(cachedImage)
    }
    
    func testImageCache_disk_success() async throws {
        guard let book else {
            XCTFail()
            return
        }
        
        let image = try await ImageCache.shared.loadImage(book: book, cacheOption: .disk)
        XCTAssertNotNil(image)
        
        let fileURL = ImageCache.shared.diskCachURL.appendingPathComponent(book.isbn13)
        XCTAssertTrue(FileManager.default.fileExists(atPath: fileURL.path))
        
        try ImageCache.shared.remove(book: book)
        XCTAssertFalse(FileManager.default.fileExists(atPath: fileURL.path))
    }
}
    

