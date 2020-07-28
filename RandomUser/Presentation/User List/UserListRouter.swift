//
//  UserListRouter.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 24/07/2020.
//  Copyright © 2020 Mateusz Matoszko. All rights reserved.
//

import UIKit

protocol UserListRouterType {
    var navigationController: UINavigationController? { get set }
    func showUserDetails(user: User)
}

class UserListRouter: UserListRouterType {

    var navigationController: UINavigationController?

    // MARK: - Public Methods

    func showUserDetails(user: User) {
        let userDetailsViewController = UserDetailsViewController(user: user)
        navigationController?.pushViewController(userDetailsViewController, animated: true)
    }
}
