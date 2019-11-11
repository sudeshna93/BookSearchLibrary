//
//  BookSearchCollectionViewCell.swift
//  BookSearchLibrary
//
//  Created by Consultant on 11/8/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import UIKit

class BookSearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    var prevTag: Int? = nil
    
}
