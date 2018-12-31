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
    func showListOfUsers()
}

final class UserInformationCoordinator: UserInformationCoordinating {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let userListViewController = UserListViewController(userRepository: userRepository)
        userListViewController.coordinator = self
        window.rootViewController = userListViewController
        window.makeKeyAndVisible()
    }

    func showUserDetails(user: User) {
        print("Showing details for \(user.email)")
    }

    func showListOfUsers() {
        print("show list of users")
    }

    private lazy var userRepository: UserRepository = {
        let restApi = createRestApi()
        let userStore = createUserStore()
        return UserRepository(restApi: restApi, userStore: userStore)
    }()
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
