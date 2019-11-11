//
//  BookSearchViewController.swift
//  BookSearchLibrary
//
//  Created by Consultant on 11/8/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import UIKit

class BookSearchViewController: UIViewController {

    @IBOutlet weak var collectionview: UICollectionView!{
        didSet{
            collectionview.reloadData()
        }
    }
    
    @IBOutlet weak var bookSearchBar: UISearchBar!
    var controller : BookModelViewProtocol = BookModelView()
    var arr: [String] = []
    private var previousRun = Date()
    private let minInterval = 0.05
    
    
    
    //MARK: View life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionview.delegate = self
        collectionview.dataSource = self
        bookSearchBar.delegate = self
        bookSearchBar.returnKeyType = UIReturnKeyType.done
        configSearchBar()

    }
   
}

extension BookSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "BookSearchCollectionViewCell", for: indexPath) as! BookSearchCollectionViewCell
        let row = indexPath.row
        setupImage(for: cell, at: row)
        setupName(for: cell, at: row)
        return cell
        
    }
    
    
    func setupImage(for cell: BookSearchCollectionViewCell, at row: Int){
        //cancel a previous enqueued task if any
        let book = controller.books[row]
        if let prevTaskIndex = cell.prevTag,
            let urlString = book.volumeInfo.imageLinks.thumbnail {
            if let oldURL = URL(string: urlString){
                controller.cancelTask(oldURL)
            }
        }
        
        //set image
        //cell.thumbnailImage.image = nil
        if let image = book.volumeInfo.imageLinks.thumbnail,
            let url = URL(string: image){
            cell.prevTag = row
            controller.getPicture(url) { (data) in
                guard let data = data else {
                    return
                }
                DispatchQueue.main.async {
                    cell.thumbnailImage.image = UIImage(data: data)
                }
            }
        }
        
    }
    
    
    func setupName(for cell: BookSearchCollectionViewCell , at row: Int){
        if let title = controller.books[row].volumeInfo.title {
            arr.append(title)
            cell.titleLabel.text = title
        }
        else{
            cell.titleLabel.text = "loading..."
        }
        
    }
    
}

extension BookSearchViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            return
        }

        if Date().timeIntervalSince(previousRun) > minInterval {
            previousRun = Date()

            controller.download(search: textToSearch) { _ in
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                }
            }
        }
        
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       
        controller.download(search: " ") { _ in
            DispatchQueue.main.async {
                self.collectionview.reloadData()
            }
        }
    }
    
    func configSearchBar(){
        bookSearchBar.placeholder = "search here"
        
        if let textfield = bookSearchBar.value(forKey: "searchField") as? UITextField
        {
            textfield.textColor = UIColor.blue
            if let backgroundView = textfield.subviews.first{
                backgroundView.backgroundColor = UIColor.white
                backgroundView.layer.cornerRadius = 10
                backgroundView.clipsToBounds = true
            }
        }
    }
}
