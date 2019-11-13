//
//  FavouriteViewController.swift
//  BookSearchLibrary
//
//  Created by Consultant on 11/11/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import UIKit
import FanMenu

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
        
            FanMenuButton(id: "mail_id", image: UIImage(named: String("mailButton")), color: .red),
            
            FanMenuButton(id: "google_id", image:  UIImage(named: String("googleButton")), color: .white)
            
        ]
        
        fanMenuView.menuRadius = 90.0
        
        fanMenuView.duration = 2.0
        
        fanMenuView.delay = 0.05
        
        fanMenuView.interval = (0, 2.0 * .pi)
        
       // fanMenuView.menuBackground = .gray
        
        fanMenuView.onItemDidClick = { FanMenuButton in
            print("itemDidClick: \(FanMenuButton.id)")
            
        }
        
        fanMenuView.onItemWillClick = {
            FanMenuButton in
            //print("itemwillclick:\(FanMenuButton.id)")
            self.fanMenuView.open()
        }
    }
    

}
