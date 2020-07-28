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
    func getUsers(count: Int) -> Observable<[User]>
    func getFreshUsers(count: Int) -> Observable<[User]>
}

final class UserRepository: UserRepositoryType {

    typealias RemoteUsersCallback = (Int) -> Observable<[User]>
    private var remoteUsersCallback: RemoteUsersCallback

    private var userStore: UserPersisting

    init(remoteUsersCallback: @escaping RemoteUsersCallback, userStore: UserPersisting) {
        self.remoteUsersCallback = remoteUsersCallback
        self.userStore = userStore
    }

    // MARK: - Public Methods

    func getUsers(count: Int) -> Observable<[User]> {
        return persistedUsers.flatMapLatest { [weak self] users -> Observable<[User]> in
            guard users.isEmpty, let strongSelf = self else {
                return Observable.just(users)
            }
            return strongSelf.getFreshUsers(count: count)
        }
    }

    /**
     Updates the list of the users from the remote and persists it.
     */
    func getFreshUsers(count: Int) -> Observable<[User]> {
        return remoteUsersCallback(count)
            .do(onNext: { [userStore] users in
                userStore.persistAsync(users: users)
            })
    }

    // MARK: - Private Methods

    private var persistedUsers: Observable<[User]> {
        return Observable.create { [weak self] observer -> Disposable in
            self?.userStore.loadUsers(callback: { users in
                observer.onNext(users)
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
}
