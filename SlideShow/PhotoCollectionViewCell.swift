//
//  PhotoCollectionViewCell.swift
//  SlideShow
//
//  Created by Thanh Nguyen on 18/08/2018.
//  Copyright © 2018 Thanh Nguyen. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var imageView: UIImageView!

    @IBOutlet private weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewTrailingConstraint: NSLayoutConstraint!

    var scrollViewDidZoomed: (Bool) -> Void = { _ in }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Set delegate cho scrollView
        scrollView.delegate = self
        // Thêm một gesture double tap để zoom in và zoom out
        let zoomGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(zoomWhenDoubleTapped))
        zoomGestureRecognizer.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(zoomGestureRecognizer	)
    }

    func setPhoto(_ photoName: String) {
        imageView.image = UIImage(named: photoName)
        // Calculate minimumZoomScale, maximumZoomScale
        updateMinZoomScale()
        // Centering imageView
        updateImageViewConstraints()
    }

    private func updateImageViewConstraints() {
        let xOffset = max(0.0, (contentView.frame.size.width - imageView.frame.size.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        let yOffset = max(0.0, (contentView.frame.size.height - imageView.frame.size.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        layoutIfNeeded()
    }

    @objc private func zoomWhenDoubleTapped(_ gesture: UITapGestureRecognizer) {
        // Nếu zoomScale hiện tại > minimumZoomScale tức là ảnh đang bị zoom, douple tap sẽ zoom out về kích thước nhỏ nhất
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            // Nếu zoomScale hiện tại > minimumZoomScale tức là ảnh đang bị zoom, douple tap sẽ zoom in đến kích thước lớn nhất
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }

    private func updateMinZoomScale() {
        guard let image = imageView.image else {
            return
        }
        // Tính toán tỉ lệ chiều rộng của ảnh với chiều rộng của contentView
        let widthScale = contentView.bounds.width / image.size.width
        // Tính toán tỉ lệ chiều cao của ảnh với chiều cao của contentView
        let heightScale = contentView.bounds.height / image.size.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        scrollView.maximumZoomScale = max(1, minScale * 3)
    }

}

// MARK: - UIScrollViewDelegate

extension PhotoCollectionViewCell: UIScrollViewDelegate {

    // Set view cần zoom trong scrollView
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    // Nếu đang zoom thì call closure disable scrolling collectionView
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        let isOriginalSize = scrollView.zoomScale == scrollView.minimumZoomScale
        scrollViewDidZoomed(isOriginalSize)
    }

    // Centering imageView
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateImageViewConstraints()
    }

}
