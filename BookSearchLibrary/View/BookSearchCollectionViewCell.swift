//
//  BookSearchCollectionViewCell.swift
//  BookSearchLibrary
//
//  Created by Consultant on 11/8/19.
//  Copyright © 2019 Consultant. All rights reserved.
//

import UIKit

protocol BookSearchCellTapDelegate {
    func didDoubleTap(id: Int)
}

class BookSearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    var prevTag: Int? = nil
    var delegate: BookSearchCellTapDelegate?
    var delegateID: Int = 0
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didDoubleTap))
        tap.numberOfTapsRequired = 2
        self.contentView.addGestureRecognizer(tap)
        return tap
    }()
    
    /// call this to register handling taps
    func register(_ delegate: BookSearchCellTapDelegate, id: Int) {
        self.delegate = delegate
        self.delegateID = id
        let _ = tapGesture
    }

    /// is called when cell is double-tapped
    @objc func didDoubleTap() {
        delegate?.didDoubleTap(id: delegateID)
    }
    
}
