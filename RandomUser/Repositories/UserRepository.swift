//
//  UserRepository.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 26/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import Foundation
import RxSwift

final class UserRepository {

    private var restApi: RestApi

    private var userStore: UserStore

    init(restApi: RestApi, userStore: UserStore) {
        self.restApi = restApi
        self.userStore = userStore
    }

    private var persistedUsers: Observable<[User]> {
        return Observable.create { [weak self] observer -> Disposable in
            self?.userStore.loadUsers(callback: { users in
                observer.onNext(users)
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }

    func getUsers() -> Observable<[User]> {
        return persistedUsers.flatMapLatest { [weak self] users -> Observable<[User]> in
            guard users.isEmpty, let strongSelf = self else {
                return Observable.just(users)
            }
            return strongSelf.getFreshUsers()
        }
    }

    /**
     Updates the list of the users from the remote and persists it.
     */
    func getFreshUsers() -> Observable<[User]> {
        return restApi.getUsers()
            .do(onNext: { [userStore] users in
                userStore.persistAsync(users: users)
            })
    }
}
