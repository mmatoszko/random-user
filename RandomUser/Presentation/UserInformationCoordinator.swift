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
    private let userStore: UserStore

    init(window: UIWindow) {
        self.window = window
        self.userStore = createUserStore()
    }

    func start() {
        let userListViewController = UserListViewController(userRepository: userRepository)
        window.rootViewController = userListViewController
        window.makeKeyAndVisible()
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
