//
//  GifCollectorViewController.swift
//  GifColl
//
//  Created by Apex on 28.08.2021.
//

import UIKit

protocol GifCollectorViewControllerDelegate: class {
    func findButtonTapped()
}

class GifCollectorViewController: UICollectionViewController {

    let itemInset: CGFloat = 20
    let itemsInRow: CGFloat = 2

    private var collector: GifCollectorModel
    private var imageCache = NSCache<NSString, UIImage>()
    
    weak var delegate: GifCollectorViewControllerDelegate?
    
    lazy var emptyListMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Empty", comment: "")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var findButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("BrowseGifs", comment: ""), for: .normal)
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(findButtonTap), for: .touchUpInside)
        return button
    }()

    
    init(withDataModel collectorModel: GifCollectorModel) {
        self.collector = collectorModel
        
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
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.register(GifCell.self, forCellWithReuseIdentifier: "gifCell")
        collectionView.showsVerticalScrollIndicator = false
        
        if collector.modelState == .browse {
            collectionView.refreshControl = UIRefreshControl()
            collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        }
        
        collector.fetchPackGifs()
        
        collector.onReload = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        if tabBarController?.selectedIndex == 1 && collector.savedGifUrls.isEmpty {
            self.view.addSubview(emptyListMessageLabel)
            self.view.addSubview(findButton)
            
            setupLayout()
        }
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            findButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            findButton.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            findButton.heightAnchor.constraint(equalToConstant: 50),
            findButton.widthAnchor.constraint(equalToConstant: self.view.frame.width - 80),
            emptyListMessageLabel.bottomAnchor.constraint(equalTo: findButton.topAnchor, constant: -20),
            emptyListMessageLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 40),
            emptyListMessageLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            emptyListMessageLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func findButtonTap() {
        delegate?.findButtonTapped()
    }
    
    func hideEmptyScreenElements() {
        emptyListMessageLabel.isHidden = true
        findButton.isHidden = true
    }
    
    func showEmptyScreenElements() {
        emptyListMessageLabel.isHidden = false
        findButton.isHidden = false
    }
    
    @objc func handleRefreshControl() {
        collector.refreshRandomGifs()
        self.collectionView.reloadData()
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}

extension GifCollectorViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collector.currentModelSize
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as? GifCell {
            cell.backgroundColor = .black
            cell.delegate = self
            let url = collector.getUrls[indexPath.item]
            cell.gifUrlString = url.absoluteString
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                DispatchQueue.main.async {
                    cell.gifImage = cachedImage
                }
            } else {
                cell.spinner.startAnimating()
                cell.downloadGifImage(imageURL: url)
                if let image = cell.gifImage {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                }
            }
            if collector.modelState == .browse {
                if collector.savedGifUrls.contains(url) {
                    cell.saveButton.setImage(UIImage(systemName: "pin.fill"), for: .normal)
                } else {
                cell.saveButton.setImage(UIImage(systemName: "pin"), for: .normal)
                }
                if indexPath.item == collector.currentModelSize - 1 {
                    collector.fetchPackGifs()
                }
            } else {
                cell.saveButton.setImage(UIImage(systemName: "pin.slash"), for: .normal)
            }
            
            return cell
        }
        fatalError("Unable to dequeue subclassed cell")
    }
}

extension GifCollectorViewController: GifCollectorCellDelegate {
    func pinGifTapped(delegateFrom cell: GifCell) {
        guard  let url = URL(string: cell.gifUrlString) else { return }
        if self.tabBarController?.selectedIndex == 0 {
            collector.save(url)
            cell.saveButton.setImage(UIImage(systemName: "pin.fill"), for: .normal)
        } else if self.tabBarController?.selectedIndex == 1 {
            collector.remove(url)
            self.collectionView.reloadData()
            if collector.savedGifUrls.isEmpty {
                showEmptyScreenElements()
            }
        }
    }
}

