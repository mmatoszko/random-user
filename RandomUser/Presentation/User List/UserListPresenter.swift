//
//  UserListPresenter.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 24/07/2020.
//  Copyright © 2020 Mateusz Matoszko. All rights reserved.
//

import RxCocoa
import RxSwift

protocol UserListPresenterType: class {

    typealias UsersUpdate = (users: [User], animate: Bool)
    typealias ReloadUsersLookup = (UsersUpdate) -> Void

    var reloadUsersLookup: ReloadUsersLookup { get set }

    var visibleUsers: [User] { get }

    func selectedUser(user: User)
    func loadUsers()
    func refreshUsers()
    func updateSearchResults(searchActive: Bool, searchText: String?)
}

class UserListPresenter: UserListPresenterType {

    var reloadUsersLookup: ReloadUsersLookup = { _ in }

    var visibleUsers: [User] = []

    private let interactor: UserListInteractorType
    private let router: UserListRouterType
    private let userCount = 15

    private let disposeBag = DisposeBag()

    // MARK: - Initialization

    init(interactor: UserListInteractorType, router: UserListRouterType) {
        self.interactor = interactor
        self.router = router

        interactor.visibleUsers.asDriver()
            .drive(onNext: { [weak self] users in
                // Animate only when there already were users
                let shouldAnimate = self?.visibleUsers.isEmpty == false
                self?.visibleUsers = users
                self?.reloadUsersLookup(UsersUpdate(users, shouldAnimate))
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Public Methods

    func selectedUser(user: User) {
        router.showUserDetails(user: user)
    }

    func loadUsers() {
        interactor.loadUsers(userCount: userCount)
    }

    func refreshUsers() {
        interactor.refreshUsers(userCount: userCount)
    }

    func updateSearchResults(searchActive: Bool, searchText: String?) {
        let presentationType = listPresentationType(for: searchActive, searchText: searchText)
        interactor.presentationType.accept(presentationType)
    }
}

private func listPresentationType(for searchActive: Bool, searchText: String?) -> PresentationType {
    guard searchActive,
        let searchText = searchText, !searchText.isEmpty else {
            return .normal
    }
    // We could also add a custom operator for function composition here, but not everyone likes that
    let userFilter: (User) -> Bool = createUsersFilter(searchText: searchText)
    return .filtered(predicate: userFilter)
}

func createUsersFilter<T: FullName>(searchText: String) -> (T) -> Bool {
    if searchText.isEmpty { return { _ in return true } }
    return { return $0.fullName.lowercased().contains(searchText.lowercased()) }
}
