//
//  BookViewController.swift
//  SearchBook-iOS
//
//  Created by USER on 5/11/25.
//

import UIKit

class BookViewController: UIViewController {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var pagesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let book = book else { return }

        titleLabel.text = book.title
        subtitleLabel.text = book.subtitle
        priceLabel.text = book.price
        authorsLabel.text = book.authors
        languageLabel.text = book.language
        yearLabel.text = book.year
        pagesLabel.text = book.pages
        descriptionLabel.text = book.desc
        
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
    

