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

    let disposeBag = DisposeBag()

    private var userRepository: UserRepository

    private var collectionView: UserListCollectionView

    private var dataSource: UserListDataSource?

    private var userListDelegate: UserListDelegate?

    weak var coordinator: UserInformationCoordinating?

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UserListCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(nibName: nil, bundle: nil)
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
            guard let user = self?.dataSource?.users[indexPath.row] else {
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

        userRepository.getUsers()
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] users in
                self?.dataSource?.users = users
                self?.collectionView.reloadData()
                print(users.count)

            }).disposed(by: disposeBag)
    }

}

