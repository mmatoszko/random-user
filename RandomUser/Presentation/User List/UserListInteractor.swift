//
//  UserListInteractor.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 24/07/2020.
//  Copyright © 2020 Mateusz Matoszko. All rights reserved.
//

import RxSwift
import RxRelay

protocol UserListInteractorType {
    var visibleUsers: BehaviorRelay<[User]> { get }
    var presentationType: BehaviorRelay<PresentationType> { get }

    func loadUsers(userCount: Int)
    func refreshUsers(userCount: Int)
}

class UserListInteractor: UserListInteractorType {

    let visibleUsers = BehaviorRelay<[User]>(value: [])
    /** Presentation state of the DataSource. */
    let presentationType = BehaviorRelay<PresentationType>(value: .normal)

    private let users = BehaviorRelay<[User]>(value: [])

    private let userRepository: UserRepositoryType
    private let disposeBag = DisposeBag()

    // MARK: - Initialization

    init(userRepository: UserRepositoryType) {
        self.userRepository = userRepository
        Observable.combineLatest(users, presentationType)
            .map(filterUsers)
            .asDriver(onErrorJustReturn: [])
            .drive(visibleUsers)
            .disposed(by: disposeBag)
    }

    // MARK: - Public Methods

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
