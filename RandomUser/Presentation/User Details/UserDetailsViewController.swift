//
//  UserDetailsViewController.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 03/01/2019.
//  Copyright © 2019 Mateusz Matoszko. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {

    private let user: User

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        title = "User Details"
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

}
