//
//  GifCollectorViewController.swift
//  GifColl
//
//  Created by Apex on 28.08.2021.
//

import UIKit

class GifCollectorViewController: UIViewController {

    let itemInset: CGFloat = 20
    let itemsInRow: CGFloat = 2
//    
//    var data = [UIColor.red, UIColor.green, UIColor.blue, UIColor.green, UIColor.purple, UIColor.orange, UIColor.blue, UIColor.green, UIColor.blue, UIColor.green, UIColor.red, UIColor.green, UIColor.blue, UIColor.green, UIColor.purple, UIColor.orange, UIColor.blue, UIColor.green, UIColor.blue, UIColor.green, UIColor.red, UIColor.green, UIColor.blue, UIColor.green, UIColor.purple, UIColor.orange, UIColor.blue, UIColor.green, UIColor.blue, UIColor.green, UIColor.red, UIColor.green, UIColor.blue, UIColor.green, UIColor.purple, UIColor.orange, UIColor.blue, UIColor.green, UIColor.blue, UIColor.green]
    
    var gifNetworkManager = GifNetworkManager()
    var gifs: [Gif] = []
    var gifCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .green
        
        self.gifCollectionView.delegate = self
        self.gifCollectionView.dataSource = self
        self.gifCollectionView.register(GifCell.self, forCellWithReuseIdentifier: "gifCell")
        //self.gifCollectionView.alwaysBounceHorizontal = true
        self.gifCollectionView.backgroundColor = .systemBackground
        
        gifNetworkManager.onCompletion = { [weak self] gif in
            guard let self = self else { return }
            self.gifs.append(gif)
//            gifs.gifUrls.forEach { (gifUrl) in
//                self.gifs?.gifUrls.append(gifUrl)
//            }
            DispatchQueue.main.async {
                self.gifCollectionView.reloadData()
            }
        }

        gifCollectionView.edgesToSuperView()
        fetchPackGifs()
    }
    
    override func loadView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: itemInset, left: itemInset, bottom: itemInset, right: itemInset)
        layout.minimumLineSpacing = itemInset
        layout.minimumInteritemSpacing = itemInset
        let paddingWidth = itemInset * (itemsInRow + 1)
        let screenRect = UIScreen.main.bounds
        let availableWidth = screenRect.size.width - paddingWidth
        let itemWidth = availableWidth / itemsInRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.scrollDirection = .vertical
        
        gifCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        self.view = gifCollectionView
    }
    
    private func fetchPackGifs() {
        for _ in 0..<gifsPackCount {
            gifNetworkManager.fetchRandomGif()
        }
    }
}

extension GifCollectorViewController: UICollectionViewDelegate {

}

extension GifCollectorViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as? GifCell {
            cell.backgroundColor = .black
            cell.spinner.startAnimating()
            cell.gifImageView.loadGifImage(withUrl: gifs[indexPath.row].gifUrl)
            if indexPath.row == gifs.count - 1 {
                fetchPackGifs()
            }
            return cell
        }
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as? GifCell {
//            let data = self.data[indexPath.item]
//            cell.setupCell(colour: data)
//            return cell
//        }
        fatalError("Unable to dequeue subclassed cell")
    }
}
