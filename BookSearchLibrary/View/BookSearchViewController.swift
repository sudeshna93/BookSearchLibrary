//
//  BookSearchViewvm.swift
//  BookSearchLibrary
//
//  Created by Consultant on 11/8/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import UIKit
import FanMenu

extension UIImage {
    func resize(fit size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

class BookSearchViewController: UIViewController {

    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var bookSearchBar: UISearchBar!

    var vm: BookViewModelProtocol = BookViewModel()
    var arr: [String] = []
    private var previousRun = Date()
    private let minInterval = 0.5 // half a second
    private var throttle: Throttle?
    
    //MARK: View life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // declare how the view will be updated by the VM
        vm.bind({
            DispatchQueue.main.async {
                self.collectionview.reloadData()
            }
        })
        // setup view elements.
        collectionview.delegate = self
        collectionview.dataSource = self
        bookSearchBar.delegate = self
        bookSearchBar.returnKeyType = UIReturnKeyType.done
        configSearchBar()
    }
    
    deinit {
        vm.unbind()
    }
   
}

extension BookSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "BookSearchCollectionViewCell", for: indexPath) as! BookSearchCollectionViewCell
        let row = indexPath.row
        setupImage(for: cell, at: row)
        setupName(for: cell, at: row)
        cell.register(self, id: row)
        return cell
        
    }
    
    
    func setupImage(for cell: BookSearchCollectionViewCell, at row: Int){
        //cancel a previous enqueued task if any
        let book = vm.books[row]
        if let prevTaskIndex = cell.prevTag,
            let urlString = vm.books[prevTaskIndex].volumeInfo.imageLinks.thumbnail {
            if let oldURL = URL(string: urlString){
                vm.cancelTask(oldURL)
            }
        }
        
        //set image
        //cell.thumbnailImage.image = nil
        if let image = book.volumeInfo.imageLinks.thumbnail,
            let url = URL(string: image){
            cell.prevTag = row
            vm.getPicture(url) { (data) in
                guard let data = data else {
                    return
                }
                DispatchQueue.main.async {
                    var image = UIImage(data: data)!
                    image = image.resize(fit: cell.thumbnailImage.frame.size)
                    cell.thumbnailImage.image = image
                }
            }
        }
        
    }
    
    
    func setupName(for cell: BookSearchCollectionViewCell , at row: Int){
        if let title = vm.books[row].volumeInfo.title {
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
            // cancel any enqueued task
            if let t = throttle { t.cancel() }
            return
        }

        // when user types,
        // cancel any existing attempt to do searching
        if let t = throttle {
            t.cancel()
            print("too fast")
        }
        
        // start a new attempt
        // this new attempt will be performed when
        // the user does not type for the minInterval
        throttle = Throttle(timeInterval: minInterval) { [weak self] in
            guard let self = self else { return }
            self.vm.download(search: textToSearch)
        }
        
        throttle?.start()
        
        /*
        if Date().timeIntervalSince(previousRun) > minInterval {
            previousRun = Date()
            vm.download(search: textToSearch) { _ in
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                }
            }
        }
        else {
            print("Too fast")
        }
        */
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       
        // cancel any enqueued request
        if let t = throttle {
            t.cancel()
        }
        
        vm.download(search: "")
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

extension BookSearchViewController: UICollectionViewDelegateFlowLayout {
    
    // the size of each item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // <[]-[]-[]>
        let cWidth = collectionView.frame.width
        let width: CGFloat = (cWidth - 27.0) / 3.0
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    // margin between sections
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    // margin between items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }

}

extension BookSearchViewController: BookSearchCellTapDelegate {
    func didDoubleTap(id: Int) {
        if vm.favourite(at: id) {
            showToast(text: "User did favourite a book!")
        }
        else {
            showToast(text: "You already have this book favorited!")
        }
    }
}

extension BookSearchViewController {
    func showToast(text: String) {
        let alert = UIAlertController(title: text,
                                      message: nil,
                                      preferredStyle: .alert)
        present(alert, animated: true) {
            UIView.animate(withDuration: 1.0, animations: {
                    alert.view.alpha = 0.0
            }) { (finished) in
                if finished { alert.dismiss(animated: true) }
            }
        }
    }
    
}
