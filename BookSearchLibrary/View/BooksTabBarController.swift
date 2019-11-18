//
//  BooksTabBarController.swift
//  BookSearchLibrary
//
//  Created by K Y on 11/13/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import UIKit

class BooksTabBarController: UITabBarController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
            
        setupControllersForVCs()
    }
    
    func setupControllersForVCs() {
        guard let vcs = viewControllers else {
            return
        }
        let coreData = CoreDataManager()
        let networker = DecodableNetwork(URLSession(configuration: .default),
                                         coreData.mainContext)
        let searchVM = BookViewModel(networker, coreData: coreData)
        let favVM = FavouritedBooksViewModel([])
        searchVM.updateDelegate = favVM
        
        // access the search VC
        if let searchVCNav = vcs[0] as? UINavigationController {
            if let searchVC = searchVCNav.topViewController as? BookSearchViewController {
                searchVC.vm = searchVM
            }
            
        }
        
        // access the favorite VC
        if let favouriteVCNav = vcs[1] as? UINavigationController {
            if let favVC = favouriteVCNav.topViewController as? FavouriteViewController {
                favVC.vm = favVM
            }
        }

    }
}
