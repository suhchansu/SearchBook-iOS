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
                bookImageView.image = try await ImageCache.shared.loadImage(book: book,
                                                                            cacheOption: .disk)
            } catch {
                bookImageView.image = nil
            }
        }
    }
}
