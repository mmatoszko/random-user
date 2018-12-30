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
        dataSource = UserListDataSource()
        userListDelegate = UserListDelegate()
        collectionView.dataSource = dataSource
        collectionView.delegate = userListDelegate
        collectionView.backgroundColor = .green
        view = collectionView
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

