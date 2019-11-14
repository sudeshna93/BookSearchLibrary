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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setButton()
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
