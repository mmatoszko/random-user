//
//  UserCollectionViewCell.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 28/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import UIKit
import Kingfisher

final class UserCollectionViewCell: UICollectionViewCell {

    static let identifier = "UserCell"

    let imageView: UIImageView

    let nameLabel: UILabel

    override init(frame: CGRect) {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel = UILabel()
        nameLabel.numberOfLines = 2
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: frame)
        nameLabel.backgroundColor = .yellow

        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0).isActive = true
        contentView.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(user: User) {
        imageView.kf.setImage(with: user.picture.large)
        let name = user.name
        // This could be done also in a properly tested view model
        let fullName = "\(name.title) \(name.first) \(name.last)"
        nameLabel.text = fullName
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
    }

}
