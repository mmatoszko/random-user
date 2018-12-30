//
//  UserListDelegate.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 30/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import UIKit

final class UserListDelegate: NSObject, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // not everyone likes the magic numbers, but they fit well in this use case
        let width = UIScreen.main.bounds.width / 2 - 5
        return CGSize(width: width, height: 150)
    }

}
