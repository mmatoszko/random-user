//
//  UserListDataSource.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 27/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import UIKit

final class UserListDataSource: NSObject, UICollectionViewDataSource {

    // MARK: - UICollectionViewDataSource Delegate

    var users: [User] = []

    /** Presentation state of the DataSource. */
    var presentationType: PresentationType = .normal

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersFor(presentationType: presentationType).count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.identifier, for: indexPath) as! UserCollectionViewCell
        let user = usersFor(presentationType: presentationType)[indexPath.row]
        cell.render(user: user)
        return cell
    }

    private func usersFor(presentationType: PresentationType) -> [User] {
        switch presentationType {
        case .normal:
            return users
        case .filtered(filteredUsers: let filteredUsers):
            return filteredUsers
        }
    }

}

/** Representation of the presentation type used in the `UserListViewController`. */
enum PresentationType {
    case normal
    case filtered(filteredUsers: [User])
}
