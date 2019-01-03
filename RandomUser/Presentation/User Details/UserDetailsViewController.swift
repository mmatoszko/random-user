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

        let views = createViews(for: user)
        let stackView = createStackView(with: views)
        view.addSubview(stackView)

        let constrains = createConstraints(for: stackView, in: view)
        view.addConstraints(constrains)
    }

}

private func createStackView(with views: [UIView]) -> UIStackView {
    let stackView = UIStackView(arrangedSubviews: views)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .equalCentering
    stackView.spacing = 20
    return stackView
}

private func createViews(for user: User) -> [UIView] {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.kf.setImage(with: user.picture.large)

    let userNameLabel = UILabel()
    userNameLabel.translatesAutoresizingMaskIntoConstraints = false
    userNameLabel.text = user.fullName

    let emailLabel = UILabel()
    emailLabel.translatesAutoresizingMaskIntoConstraints = false
    emailLabel.text = user.email
    return [imageView, userNameLabel, emailLabel]
}

private func createConstraints(for stackView: UIStackView, in view: UIView) -> [NSLayoutConstraint] {
    let constrains = [
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
        ]
    return constrains
}
