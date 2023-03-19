//
//  UICollectionView+Extension.swift
//  BankAssistant
//
//  Created by nguyen.tuan.hai on 19/07/2022.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: name)
        } else {
            register(aClass, forCellWithReuseIdentifier: name)
        }
    }

    func registerFooter<T: UICollectionReusableView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                     withReuseIdentifier: name)
        } else {
            register(aClass,
                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                     withReuseIdentifier: name)
        }
    }
    
    func registerHeader<T: UICollectionReusableView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                     withReuseIdentifier: name)
        } else {
            register(aClass,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: name)
        }
    }
    
    func dequeue<T: UICollectionViewCell>(_ aClass: T.Type, _ indexPath: IndexPath) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("`\(name)` is not registerd")
        }
        return cell
    }

    func dequeueHeader<T: UICollectionReusableView>(_ aClass: T.Type, _ indexPath: IndexPath) -> T {
        let name = String(describing: aClass)

        guard let cell = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                          withReuseIdentifier: name,
                                                          for: indexPath) as? T else {
            fatalError("`\(name)` is not registerd")
        }
        return cell
    }
    
    func dequeueFooter<T: UICollectionReusableView>(_ aClass: T.Type, _ indexPath: IndexPath) -> T {
        let name = String(describing: aClass)

        guard let cell = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                          withReuseIdentifier: name,
                                                          for: indexPath) as? T else {
            fatalError("`\(name)` is not registerd")
        }
        return cell
    }
}
