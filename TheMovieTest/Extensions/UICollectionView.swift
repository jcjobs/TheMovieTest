//
//  UICollectionView.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 10/10/22.
//

import UIKit

extension UICollectionView {
    func registerCells<T: UICollectionViewCell>(_ cells: [T.Type]) {
        cells.forEach { self.register($0.self, forCellWithReuseIdentifier: $0.reuseIdentifier) }
    }

    func dequeReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to reuse cell")
        }
        
        return cell
    }
}
