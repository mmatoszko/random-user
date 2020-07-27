//
//  ViewController.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 21/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import UIKit
import RxSwift

class UserListViewController: UIViewController {

    private let userListPresenter: UserListPresenter

    private var collectionView: UserListCollectionView

    private let searchController = UISearchController(searchResultsController: nil)

    init(userListPresenter: UserListPresenter) {
        self.userListPresenter = userListPresenter
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UserListCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(nibName: nil, bundle: nil)
        title = "Random Users"
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        prepareUserListCollectionView(collectionView: collectionView)
        view = collectionView
    }

    private func prepareUserListCollectionView(collectionView: UserListCollectionView) {
        collectionView.dataSource = userListPresenter.dataSource
        assert(collectionView.dataSource != nil)
        collectionView.delegate = userListPresenter.userListDelegate
        assert(collectionView.delegate != nil)
        collectionView.backgroundColor = .green
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupSearchController()

        userListPresenter.reloadUsersLookup = { [weak self] users in
            self?.reload(users: users)
        }
        userListPresenter.loadUsers()
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing users")
        refreshControl.addTarget(self,
                                 action: #selector(refreshOptions(sender:)),
                                 for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    @objc private func refreshOptions(sender: UIRefreshControl) {
        userListPresenter.refreshUsers()
    }

    private func reload(users: [User]) {
        collectionView.refreshControl?.endRefreshing()
        collectionView.reloadData()
        print("reloaded with \(users.count) users")
    }
}

extension UserListViewController: UISearchResultsUpdating {

    // MARK: - UISearchResultsUpdating Delegate

    func updateSearchResults(for searchController: UISearchController) {
        let presentationType = listPresentationType(for: searchController)
        userListPresenter.updateSearchResults(presentationType: presentationType)
        collectionView.reloadData()
    }
}

private func listPresentationType(for searchController: UISearchController) -> PresentationType {
    guard searchController.isActive,
        let searchText = searchController.searchBar.text else {
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
