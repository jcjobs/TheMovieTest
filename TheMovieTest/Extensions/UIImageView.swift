//
//  UIImageView.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 10/10/22.
//

import UIKit
import Kingfisher
import CoreComponents

extension UIImageView {
    func setImage(with imageUrlString: String, and defaultImage: UIImage?, and color: UIColor? = nil) {
        guard let imageUrl = URL(string: CoreConstants.imageUrl + imageUrlString) else {
            image = defaultImage
            return
        }
        
        let transition = KingfisherOptionsInfoItem.transition(.fade(0.1))
        var options: KingfisherOptionsInfo?
        if let customColor = color {
            let processor = OverlayImageProcessor(overlay: customColor, fraction: 0.75)
            options = [transition, .processor(processor)]
        } else {
            options = [transition]
        }
        
        self.kf.indicatorType = .activity
        self.kf.setImage(with: imageUrl, placeholder: defaultImage, options: options)
    }
}
