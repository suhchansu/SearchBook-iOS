//
//  ViewController.swift
//  SearchBook-iOS
//
//  Created by USER on 5/11/25.
//

import UIKit

class ViewController: UIViewController {
    
    enum Constant {
        static let cellID = "SearchTableViewCell"
        static let tableViewHeight: CGFloat = 150
        static let mainStoryboardID = "Main"
        static let bookVC = "BookViewController"
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var bookList: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: Constant.cellID, bundle: nil), forCellReuseIdentifier: Constant.cellID)
    }
    
    private func alertErrorView(message: String) {
        let alert = UIAlertController(title: "오류",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if bookList.count > indexPath.row,
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellID, for: indexPath) as? SearchTableViewCell {
            cell.setBook(bookList[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.tableViewHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let book = bookList[indexPath.row]
        APIRequester.shared.searchBook(isbn13: book.isbn13) { [weak self] in
            switch $0 {
            case .failure(let error):
                self?.alertErrorView(message: error.localizedDescription)
            case .success(let book):
                DispatchQueue.main.async { [weak self] in
                    if let vc = UIStoryboard(name: Constant.mainStoryboardID,
                                             bundle: nil).instantiateViewController(withIdentifier: Constant.bookVC) as? BookViewController {
                        vc.book = book
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            
        }
    }
    
    // MARK: - UITableViewDataSourcePrefetching
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let keyword = searchBar.text else { return }

        for indexPath in indexPaths {
            guard bookList.count - 1 == indexPath.row else { continue }
            
            let currentPage = bookList.count / 10
            APIRequester.shared.searchBookList(keyword: keyword, page: currentPage + 1) { [weak self] in
                switch $0 {
                case .failure(let error):
                    self?.alertErrorView(message: error.localizedDescription)
                case .success(let bookList):
                    self?.bookList += bookList
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        
        APIRequester.shared.searchBookList(keyword: keyword, page: 1) { [weak self] in
            switch $0 {
            case .failure(let error):
                self?.alertErrorView(message: error.localizedDescription)
            case .success(let bookList):
                self?.bookList = bookList
                
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }

        searchBar.resignFirstResponder()
    }
}
