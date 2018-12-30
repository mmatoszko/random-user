//
//  UserCollectionViewCell.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 28/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import UIKit

final class UserCollectionViewCell: UICollectionViewCell {

    static let identifier = "UserCell"

    let nameLabel: UILabel

    override init(frame: CGRect) {
        nameLabel = UILabel()
        nameLabel.numberOfLines = 2
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: frame)
        nameLabel.backgroundColor = .yellow

        contentView.addSubview(nameLabel)
        contentView.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(user: User) {
        let name = user.name
        // This could be done also in a properly tested view model
        let fullName = "\(name.title) \(name.first) \(name.last)"
        nameLabel.text = fullName
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
    }

}
