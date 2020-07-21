//
//  UserListDataSource.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 27/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import UIKit

final class UserListDataSource: NSObject, UICollectionViewDataSource {

    private var users: [User] = []
    var visibleUsers: [User] = []

    /** Presentation state of the DataSource. */
    var presentationType: PresentationType = .normal {
        didSet { reloadVisibleUsers(for: presentationType) }
    }

    func updateUsers(users: [User]) {
        self.users = users
    }

    // MARK: - UICollectionViewDataSource Delegate

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleUsers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.identifier, for: indexPath) as! UserCollectionViewCell
        let user = visibleUsers[indexPath.row]
        cell.render(user: user)
        return cell
    }

    // MARK: - Private Methods

    private func reloadVisibleUsers(for presentationType: PresentationType) {
        switch presentationType {
        case .normal:
            self.visibleUsers = users
        case .filtered(let predicate):
            self.visibleUsers = users.filter(predicate)
        }
    }
}

/** Representation of the presentation type used in the `UserListViewController`. */
enum PresentationType {
    case normal
    case filtered(predicate: (User) -> Bool)
}
