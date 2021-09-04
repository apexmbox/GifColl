//
//  Gif.swift
//  GifColl
//
//  Created by Apex on 29.08.2021.
//

import Foundation

struct Gif {
    var gifUrlPreview: URL?
    
    init?(gifData: GifData) {
        let urlPreviewString = gifData.data.images.previewGIF.url
        if let url = URL(string: urlPreviewString) {
            self.gifUrlPreview = url
        }
    }
}
