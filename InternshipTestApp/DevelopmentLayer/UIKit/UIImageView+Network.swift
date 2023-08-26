//
//  UIImageView+Network.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 27.08.2023.
//

import NukeExtensions
import UIKit

extension UIImageView {
    /// Загрузка и установка изображения с возможностью установки плейсхолдера
    func setImage(
        from url: URL?,
        placeholder: UIImage? = UIImage(named: "placeholder_image"),
        forceTransition: Bool = false,
        completion: ((Result<UIImage, Error>) -> Void)? = nil
    ) {
        guard let url = url else {
            if image == nil {
                image = placeholder
            }
            
            return
        }

        var options = ImageLoadingOptions(
            placeholder: placeholder,
            transition: .fadeIn(duration: 0.25)
        )
        options.alwaysTransition = forceTransition

        if backgroundColor == nil {
            backgroundColor = .white
        }
        
        loadImage(with: url, options: options, into: self) { result in
            completion?(
                result.map { $0.image }.mapError { $0 }
            )
        }
    }
}
