//
//  GifCollectorModel.swift
//  GifColl
//
//  Created by Apex on 30.08.2021.
//

import Foundation

class GifCollectorModel {
    enum State {
        case browse
        case saved
    }
    
    var gifUrls: [URL] = []
    var savedGifUrls: [URL] = []
    var networkManager = GifNetworkManager()
    var onReload: (() -> ())?
    var modelState: State
    
    init() {
        self.modelState = .saved
        self.gifUrls = [URL]()
        if let data = UserDefaults.standard.value(forKey: defaultsGifArrayKey) as? Data {
            do {
                self.savedGifUrls = try PropertyListDecoder().decode([URL].self, from: data)
            } catch {
                self.savedGifUrls = [URL]()
            }
        }
         
        networkManager.onCompletionURL = { [weak self] url in
            guard let self = self else { return }
            self.add(url)
        }
    }
    
    var getUrls: [URL] {
        get {
            switch modelState {
            case .browse:
                return gifUrls
            case .saved:
                return savedGifUrls
            }
        }
    }
    
    var currentModelSize: Int {
        get {
            switch modelState {
            case .browse:
                return gifUrls.count
            case .saved:
                return savedGifUrls.count
            }
        }
    }
    
    func add(_ url: URL) {
        gifUrls.append(url)
        self.onReload?()
    }
    
    func save(_ url: URL) {
        savedGifUrls.append(url)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(savedGifUrls), forKey: defaultsGifArrayKey)
    }
    
    func remove(_ url: URL) {
        if let index = savedGifUrls.firstIndex(of: url) {
            savedGifUrls.remove(at: index)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(savedGifUrls), forKey: defaultsGifArrayKey)
        }
    }
    
    func refreshRandomGifs() {
        self.gifUrls = []
        self.fetchPackGifs()
    }
    
    func fetchPackGifs() {
        for _ in 0..<gifsPackCount {
            networkManager.fetchRandomGifUrl()
        }
    }
}
