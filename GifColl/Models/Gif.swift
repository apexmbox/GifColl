//
//  Gif.swift
//  GifColl
//
//  Created by Apex on 29.08.2021.
//

import Foundation

struct Gif {
    var gifUrl: URL
    
    init?(gifData: GifData) {
        //let urlString = gifData.data.images.original.url
        //let urlString = gifData.data.fixedHeightSmallURL
        let urlString = gifData.data.fixedHeightDownsampledURL
        guard let url = URL(string: urlString) else { return nil }
        self.gifUrl = url
    }
}
