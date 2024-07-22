//
//  DynamicHeightCollectionView.swift
//  JanSahayak
//
//  Created by Jonish Sangwan on 16/06/22.
//  Copyright © 2022 Jonish Sangwan. All rights reserved.
//

import UIKit

class DynamicHeightCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
}
