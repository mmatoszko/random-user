//
//  UserListDataSource.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 27/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import UIKit

enum Section {
    case main
}

typealias UserListDataSource = UICollectionViewDiffableDataSource<Section, User>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, User>

func makeUserListDataSource(collectionView: UICollectionView) -> UserListDataSource {
    return UserListDataSource(
    collectionView: collectionView) { (collectionView, indexPath, user) -> UICollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.identifier, for: indexPath) as? UserCollectionViewCell
        cell?.render(user: user)
        return cell
    }
}
