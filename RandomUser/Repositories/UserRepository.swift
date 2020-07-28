//
//  UserRepository.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 26/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import Foundation
import RxSwift

protocol UserRepositoryType {
    func getUsers(count: Int) -> Single<[User]>
    func getFreshUsers(count: Int) -> Single<[User]>
}

final class UserRepository: UserRepositoryType {

    typealias RemoteUsersCallback = (Int) -> Single<[User]>
    private var remoteUsersCallback: RemoteUsersCallback

    private var userStore: UserPersisting

    init(remoteUsersCallback: @escaping RemoteUsersCallback, userStore: UserPersisting) {
        self.remoteUsersCallback = remoteUsersCallback
        self.userStore = userStore
    }

    // MARK: - Public Methods

    func getUsers(count: Int) -> Single<[User]> {
        return persistedUsers.flatMap { [weak self] users -> Single<[User]> in
            guard users.isEmpty, let strongSelf = self else {
                return .just(users)
            }
            return strongSelf.getFreshUsers(count: count)
        }
    }

    /**
     Updates the list of the users from the remote and persists it.
     */
    func getFreshUsers(count: Int) -> Single<[User]> {
        return remoteUsersCallback(count)
            .do(onSuccess: { [userStore] users in
                userStore.persistAsync(users: users)
            })
    }

    // MARK: - Private Methods

    private var persistedUsers: Single<[User]> {
        return Single.create { [weak self] observer -> Disposable in
            self?.userStore.loadUsers(callback: { users in
                observer(.success(users))
            })
            return Disposables.create()
        }
    }
}
