//
//  UserListPresenter.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 24/07/2020.
//  Copyright © 2020 Mateusz Matoszko. All rights reserved.
//

import RxCocoa
import RxSwift

class UserListPresenter {

    typealias ReloadUsersLookup = ([User]) -> Void

    var reloadUsersLookup: ReloadUsersLookup = { _ in }

    var dataSource: UserListDataSource
    var userListDelegate: UserListDelegate?

    private let interactor: UserListInteractor
    private let router: UserListRouter
    private let userCount = 15

    private let disposeBag = DisposeBag()

    init(interactor: UserListInteractor, router: UserListRouter) {
        self.interactor = interactor
        self.router = router

        dataSource = UserListDataSource()
        userListDelegate = UserListDelegate(cellSelectionCallback: { [weak self] indexPath in
            guard let user = self?.dataSource.users[indexPath.row] else {
                assertionFailure("Can't get user at index \(indexPath.row)")
                return
            }
            self?.router.showUserDetails(user: user)
        })
        interactor.visibleUsers.asDriver()
            .drive(onNext: { [weak self] users in
                self?.dataSource.users = users
                self?.reloadUsersLookup(users)
            })
            .disposed(by: disposeBag)
    }

    func loadUsers() {
        interactor.loadUsers(userCount: userCount)
    }

    func refreshUsers() {
        interactor.refreshUsers(userCount: userCount)
    }

    func updateSearchResults(presentationType: PresentationType) {
        interactor.presentationType.accept(presentationType)
    }
}
