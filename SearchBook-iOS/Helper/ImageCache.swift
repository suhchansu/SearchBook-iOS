//
//  ImageCache.swift
//  SearchBook-iOS
//
//  Created by USER on 5/11/25.
//

import UIKit

class ImageCache {
    enum ImageCacheError: Error {
        case invalidURL
        case invalidDirectory
        case loadFailed
    }
    
    enum ImageCacheOption {
        case memory
        case disk
    }
    
    static let shared = ImageCache()

    var memoryCache = NSCache<NSString, UIImage>()
    let diskCachURL: URL
    
    init() {
        guard let diskCachURL = FileManager.default.urls(for: .applicationSupportDirectory,
                                                         in: .userDomainMask).first?.appendingPathComponent("diskCache") else { fatalError() }
        
        self.diskCachURL = diskCachURL
        guard FileManager.default.fileExists(atPath: diskCachURL.path) == false else { return }
        
        do {
            try FileManager.default.createDirectory(at: diskCachURL,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch {
            fatalError()
        }
    }
    
    func remove(book: Book) throws {
        try FileManager.default.removeItem(at: diskCachURL.appendingPathComponent(book.isbn13))
    }

    func loadImage(book: Book, cacheOption: ImageCacheOption = .memory) async throws -> UIImage {
        guard let imageURL = URL(string: book.imageURLString) else { throw ImageCacheError.invalidURL }
        
        let fileID = book.isbn13
        switch cacheOption {
        case .memory:
            if let cachedImage = memoryCache.object(forKey: fileID as NSString) {
                return cachedImage
            }

            let data = try await URLSession.shared.data(from: imageURL).0
            if let image = UIImage(data: data) {
                memoryCache.setObject(image, forKey: fileID as NSString)
                return image
            } else {
                throw ImageCacheError.loadFailed
            }
        case .disk:
            do {
                let cachedImageData = try Data(contentsOf: diskCachURL.appendingPathComponent(fileID))
                if let cachedImage = UIImage(data: cachedImageData) {
                    return cachedImage
                } else {
                    throw ImageCacheError.invalidDirectory
                }
            } catch {
                let data = try await URLSession.shared.data(from: imageURL).0
                if let image = UIImage(data: data) {
                    try data.write(to: diskCachURL.appendingPathComponent(fileID), options: .atomic)
                    return image
                } else {
                    throw ImageCacheError.loadFailed
                }
            }
        }
    }
}
