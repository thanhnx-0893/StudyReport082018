//
//  SlideShowViewController.swift
//  SlideShow
//
//  Created by Thanh Nguyen on 18/08/2018.
//  Copyright © 2018 Thanh Nguyen. All rights reserved.
//

import UIKit

class SlideShowViewController: UIViewController {

    @IBOutlet fileprivate weak var slideShowCollectionView: UICollectionView!

    fileprivate let photos = [
        "photo1",
        "photo2",
        "photo3",
        "photo4",
        "photo5"
    ]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }

    @IBAction private func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - UICollectionViewDataSource

extension SlideShowViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        // Set photo name cho cell
        cell.setPhoto(photos[indexPath.row])
        // Implement closure
        cell.scrollViewDidZoomed = { isOriginalSize in
            collectionView.isScrollEnabled = !isOriginalSize
        }
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension SlideShowViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Mỗi cell sẽ có kích thước full màn hình
        return view.frame.size
    }

}
