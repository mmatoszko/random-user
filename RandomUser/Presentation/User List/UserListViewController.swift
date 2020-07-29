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

    private let userListPresenter: UserListPresenterType

    private var collectionView: UserListCollectionView

    private let dataSource: UserListDataSource
    private var userListDelegate: UserListDelegate?

    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Initialization

    init(userListPresenter: UserListPresenterType) {
        self.userListPresenter = userListPresenter
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UserListCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        dataSource = makeUserListDataSource(collectionView: collectionView)
        super.init(nibName: nil, bundle: nil)
        title = "Random Users"
        userListDelegate = UserListDelegate(cellSelectionCallback: { [weak self] indexPath in
            guard let user = self?.dataSource.itemIdentifier(for: indexPath) else {
                assertionFailure("Can't get user at index \(indexPath.row)")
                return
            }
            self?.userListPresenter.selectedUser(user: user)
        })
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        prepareUserListCollectionView(collectionView: collectionView)
        view = collectionView
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

    // MARK: - Private Methods

    private func prepareUserListCollectionView(collectionView: UserListCollectionView) {
        collectionView.dataSource = dataSource
        assert(collectionView.dataSource != nil)
        collectionView.delegate = userListDelegate
        assert(collectionView.delegate != nil)
        collectionView.backgroundColor = .green
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
        applySnapshot()
        print("reloaded with \(users.count) users")
    }

    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(userListPresenter.visibleUsers)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension UserListViewController: UISearchResultsUpdating {

    // MARK: - UISearchResultsUpdating Delegate

    func updateSearchResults(for searchController: UISearchController) {
        userListPresenter.updateSearchResults(
            searchActive: searchController.isActive,
            searchText: searchController.searchBar.text
        )
    }
}
