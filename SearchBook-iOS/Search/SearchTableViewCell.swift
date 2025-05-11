//
//  SearchTableViewCell.swift
//  SearchBook-iOS
//
//  Created by USER on 5/11/25.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setBook(_ book: Book) {
        titleLabel.text = book.title
        priceLabel.text = book.price
        
        Task {
            do {
                bookImageView.image = try await loadImage(book: book)
            } catch {
                bookImageView.image = nil
            }
        }
    }
}

func loadImage(book: Book) async throws -> UIImage {
    guard let imageURL = URL(string: book.imageURLString) else { throw APIRequester.APIError.invalidURL }
    
    let data = try await URLSession.shared.data(from: imageURL).0
    if let image = UIImage(data: data) {
        return image
    } else {
        throw APIRequester.APIError.loadFailed
    }
}
