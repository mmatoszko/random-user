//
//  UserListInteractor.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 24/07/2020.
//  Copyright © 2020 Mateusz Matoszko. All rights reserved.
//

import RxSwift
import RxRelay

class UserListInteractor {

    private let users = BehaviorRelay<[User]>(value: [])
    let visibleUsers = BehaviorRelay<[User]>(value: [])

    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()

    /** Presentation state of the DataSource. */
    let presentationType = BehaviorRelay<PresentationType>(value: .normal)

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        Observable.combineLatest(users, presentationType)
            .map(filterUsers)
            .asDriver(onErrorJustReturn: [])
            .drive(visibleUsers)
            .disposed(by: disposeBag)
    }

    func loadUsers(userCount: Int) {
        userRepository
            .getUsers(count: userCount)
            .asDriver(onErrorJustReturn: [])
            .drive(users)
            .disposed(by: disposeBag)
    }

    func refreshUsers(userCount: Int) {
        userRepository
            .getFreshUsers(count: userCount)
            .asDriver(onErrorJustReturn: [])
            .drive(users)
            .disposed(by: disposeBag)
    }

    // MARK: - Private Methods
}

private func filterUsers(users: [User], presentationType: PresentationType) -> [User] {
    switch presentationType {
    case .normal:
        return users
    case .filtered(let predicate):
        return users.filter(predicate)
    }
}

/** Representation of the presentation type used in the `UserListViewController`. */
enum PresentationType {
    case normal
    case filtered(predicate: (User) -> Bool)
}
