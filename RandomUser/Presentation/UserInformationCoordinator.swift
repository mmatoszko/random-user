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

    private var navigationController: UINavigationController?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        assert(navigationController == nil, "Start method should be called only during `didFinishLaunchingWithOptions`")
        let router = UserListRouter()
        let userListViewController = createUserListViewController(router: router)
        let navigationController = UINavigationController(rootViewController: userListViewController)
        self.navigationController = navigationController
        router.navigationController = navigationController

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    private func createUserListViewController(router: UserListRouter) -> UserListViewController {
        let userListInteractor = UserListInteractor(userRepository: userRepository)
        let userListPresenter = UserListPresenter(interactor: userListInteractor, router: router)
        return UserListViewController(userListPresenter: userListPresenter)

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
