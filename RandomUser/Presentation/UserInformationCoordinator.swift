//
//  UserInformationCoordinator.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 27/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import Foundation
import UIKit

final class UserInformationCoordinator {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let userListViewController = UserListViewController()
        window.rootViewController = userListViewController
        window.makeKeyAndVisible()
    }
}
