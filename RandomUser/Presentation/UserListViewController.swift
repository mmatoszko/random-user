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

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        userRepository.getUsers()
            .subscribe(onNext: { users in
                print(users.count)

            }).disposed(by: disposeBag)
        // Do any additional setup after loading the view, typically from a nib.
    }


}

