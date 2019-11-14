//
//  FavouriteViewController.swift
//  BookSearchLibrary
//
//  Created by Consultant on 11/11/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import UIKit
import FanMenu

enum FavouriteMenuOptions: String {
    case gmail = "mail_id"
    case google = "google_id"
}

extension FavouriteMenuOptions {
    var url: URL {
        let s: String
        switch self {
            case .gmail:
                s = "https://mail.google.com/mail/u/0/#"
            case .google:
                s = "https://www.google.com"
        }
        return URL(string: s)!
    }
}

class FavouriteViewController: UIViewController {

    @IBOutlet weak var fanMenuView: FanMenu!
    @IBOutlet weak var tableView: UITableView!
    
    var vm: FavouritedBooksViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setButton()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "reuseID")
        tableView.register(FavouriteBookTableViewCell.self, forCellReuseIdentifier: "fancyCell")
    }

    func setButton(){
        fanMenuView.button = FanMenuButton(
            id:"main",
            image: UIImage(named: String("crossButton")),
            color: .lime
        )
        
        fanMenuView.items = [
            FanMenuButton(id: FavouriteMenuOptions.gmail.rawValue,
                          image: UIImage(named: String("mailButton")),
                          color: .red),
            
            FanMenuButton(id: FavouriteMenuOptions.google.rawValue,
                          image: UIImage(named: String("googleButton")),
                          color: .white)
        ]
        
        fanMenuView.menuRadius = 90.0
        fanMenuView.duration = 2.0
        fanMenuView.delay = 0.05
        fanMenuView.interval = (0, 2.0 * .pi)
        fanMenuView.backgroundColor = .clear
        
       // fanMenuView.menuBackground = .gray
        
        fanMenuView.onItemDidClick = { FanMenuButton in
            print("itemDidClick: \(FanMenuButton.id)")
            if let option = FavouriteMenuOptions(rawValue: FanMenuButton.id) {
                UIApplication.shared.open(option.url,
                                          options: [:],
                                          completionHandler: nil)
            }
        }
        
        fanMenuView.onItemWillClick = {
            FanMenuButton in
            print("itemwillclick:\(FanMenuButton.id)")
            // self.fanMenuView.open()
        }
    }
    

}

extension FavouriteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return vm.favourites.count
        
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let book = vm.favourites[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "fancyCell") as! FavouriteBookTableViewCell
        cell.bookLabel.text = book.volumeInfo.title
        
        return cell
    }
    /*
    func oldCell() {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseID",
                                                 for: indexPath)
        cell.textLabel?.text = book.volumeInfo.title
    }
     */
}
