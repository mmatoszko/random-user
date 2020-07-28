//
//  UserListCollectionView.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 27/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import UIKit

final class UserListCollectionView: UICollectionView {

    // MARK: - Initialization

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        register(UserCollectionViewCell.self, forCellWithReuseIdentifier: UserCollectionViewCell.identifier)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
