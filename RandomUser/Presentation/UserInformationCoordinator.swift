//
//  UserInformationCoordinator.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 27/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import Foundation
import UIKit

protocol UserInformationCoordinating: class {
    func showUserDetails(user: User)
}

final class UserInformationCoordinator: UserInformationCoordinating {

    private let window: UIWindow

    private var navigationController: UINavigationController?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        assert(navigationController == nil, "Start method should be called only during `didFinishLaunchingWithOptions`")
        let userListViewController = UserListViewController(userRepository: userRepository)
        userListViewController.coordinator = self
        navigationController = UINavigationController(rootViewController: userListViewController)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func showUserDetails(user: User) {
        let userDetailsViewController = UserDetailsViewController(user: user)
        navigationController?.pushViewController(userDetailsViewController, animated: true)
    }

    private lazy var userRepository: UserRepository = {
        let userStore = createUserStore()
        return UserRepository(remoteUsersCallback: restApi.getUsers, userStore: userStore)
    }()

    private lazy var restApi: RestApi = createRestApi()
}

private func createRestApi() -> RestApi {
    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration)
    return RestApi(urlSession: session)
}

private func createUserStore() -> UserStore {
    let store = UserStore(containerName: "RandomUser")
    store.load { success in
        assert(success, "User store should be properly created")
    }
    return store
}
