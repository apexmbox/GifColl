//
//  UIImageView+loadRandomGifImage.swift
//  GifColl
//
//  Created by Apex on 29.08.2021.
//

import Foundation
import UIKit

extension UIImageView {
    func loadGifImage(withUrl url: URL) {
        DispatchQueue.main.async { [weak self] in
            guard let gifData = try? Data(contentsOf: url) else { return }
            guard let source = CGImageSourceCreateWithData(gifData as CFData, nil) else { return }
            self?.image = UIImage.animatedImageWithSource(source)
        }
    }
}
