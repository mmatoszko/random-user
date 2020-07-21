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

    private let userCount = 15
    private let disposeBag = DisposeBag()

    private let userRepository: UserRepository

    private var collectionView: UserListCollectionView

    private var dataSource: UserListDataSource?

    private var userListDelegate: UserListDelegate?

    private let searchController = UISearchController(searchResultsController: nil)

    weak var coordinator: UserInformationCoordinating?

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
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
        assert(dataSource != nil)
        assert(userListDelegate != nil)
        assert(coordinator != nil)
    }

    private func prepareUserListCollectionView(collectionView: UserListCollectionView) {
        dataSource = UserListDataSource()
        userListDelegate = UserListDelegate(cellSelectionCallback: { [weak self] indexPath in
            guard let user = self?.dataSource?.visibleUsers[indexPath.row] else {
                assertionFailure("Can't get user at index \(indexPath.row)")
                return
            }
            self?.coordinator?.showUserDetails(user: user)
        })
        collectionView.dataSource = dataSource
        collectionView.delegate = userListDelegate
        collectionView.backgroundColor = .green
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        userRepository.getUsers(count: userCount)
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] users in
                self?.loadNewUsers(users: users)
            })
            .disposed(by: disposeBag)
        setupRefreshControl()
        setupSearchController()
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
        userRepository.getFreshUsers(count: userCount)
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] users in
                self?.loadNewUsers(users: users)
                sender.endRefreshing()
            })
            .disposed(by: disposeBag)
    }

    private func loadNewUsers(users: [User]) {
        dataSource?.updateUsers(users: users)
        filterAndReloadData()
        print("just loaded \(users.count) users")
    }

    private func filterAndReloadData() {
        updateSearchResults(for: searchController)
    }

}

extension UserListViewController: UISearchResultsUpdating {

    // MARK: - UISearchResultsUpdating Delegate

    func updateSearchResults(for searchController: UISearchController) {
        guard let dataSource = dataSource else {
            assertionFailure("No data source.")
            return
        }
        dataSource.presentationType = listPresentationType(for: searchController, and: dataSource)
        collectionView.reloadData()
    }
}

private func listPresentationType(for searchController: UISearchController, and dataSource: UserListDataSource) -> PresentationType {
    guard searchController.isActive,
        let searchText = searchController.searchBar.text else {
            return .normal
    }
    // We could also add a custom operator for function composition here, but not everyone likes that
    let userFilter: (User) -> Bool = filterFunction(searchText: searchText)
    return .filtered(predicate: userFilter)
}

func filterFunction<T: FullName>(searchText: String) -> (T) -> Bool {
    if searchText.isEmpty { return { _ in return true } }
    return { return $0.fullName.lowercased().contains(searchText.lowercased()) }
}
