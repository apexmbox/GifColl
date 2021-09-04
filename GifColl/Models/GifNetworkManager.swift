//
//  GifNetworkManager.swift
//  GifColl
//
//  Created by Apex on 29.08.2021.
//

import Foundation
import UIKit

struct GifNetworkManager {
    
    var onCompletionURL: ((URL) -> Void)?
    var onCompletionImage: ((UIImage) -> Void)?
    
    func fetchGif(fromUrl url: URL?) {
        guard let url = url else { return }
        guard let gifData = try? Data(contentsOf: url) else { return }
        guard let source = CGImageSourceCreateWithData(gifData as CFData, nil) else { return }
        if let image = UIImage.animatedImageWithSource(source) {
            self.onCompletionImage?(image)
        }
    }
    
    func fetchRandomGifUrl() {
        let urlString = randomGifUrlString
        performRequest(withUrlString: urlString)
    }

    fileprivate func performRequest(withUrlString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil,
                  let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                return
            }
            if let url = parseJSON(withData: data) {
                self.onCompletionURL?(url)
            }
        }
        task.resume()
    }
    
    fileprivate func parseJSON(withData data: Data) -> URL? {
        let decoder = JSONDecoder()
        do {
            let gifData = try decoder.decode(GifData.self, from: data)
            guard let gif = Gif(gifData: gifData) else { return nil }
            return gif.gifUrlPreview
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
}
