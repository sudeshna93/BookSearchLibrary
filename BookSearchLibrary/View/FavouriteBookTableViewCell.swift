//
//  FavouriteBookTableViewCell.swift
//  BookSearchLibrary
//
//  Created by K Y on 11/13/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import UIKit


extension UIView {
    func fillIn(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        let constraints = [
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

class FavouriteBookTableViewCell: UITableViewCell {
    
    lazy var bookLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.font = UIFont(name: "alphabetized cassette tapes",
                        size: 60.0)
        l.fillIn(contentView)
        return l
    }()
    
    
}
