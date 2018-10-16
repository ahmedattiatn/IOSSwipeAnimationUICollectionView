//
//  OverlapCollectionViewCell.swift
//  IOSSwipeAnimationUICollectionView
//
//  Created by Ahmed ATIA on 16/10/2018.
//  Copyright © 2018 Ahmed ATIA. All rights reserved.
//

import UIKit

class OverlapCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.black.cgColor
    }
    
    
    /// Commenting out the below method results in cell insertions occurring at an improper index. It appears that the
    /// collection view is not setting the zIndex on the cell properly.
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        layer.zPosition = CGFloat(layoutAttributes.zIndex)
    }
}
