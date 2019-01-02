//
//  UserListDelegate.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 30/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import UIKit

final class UserListDelegate: NSObject, UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDelegateFlowLayout Delegate

    typealias CellSelectionCallback = (IndexPath) -> Void

    private let cellSelectionCallback: CellSelectionCallback

    init(cellSelectionCallback: @escaping CellSelectionCallback) {
        self.cellSelectionCallback = cellSelectionCallback
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellSelectionCallback(indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // not everyone likes the magic numbers, but they fit well in this use case
        let width = UIScreen.main.bounds.width / 3 - 7
        return CGSize(width: width, height: 120)
    }

}
