//
//  GifCell.swift
//  GifColl
//
//  Created by Apex on 29.08.2021.
//

import UIKit

protocol GifCollectorCellDelegate: class {
    func pinGifTapped(delegateFrom cell: GifCell)
}

let imageCache = NSCache<NSString, UIImage>()

class GifCell: UICollectionViewCell {
    
    enum cellType: NSString {
        case general = "general"
        case saved = "saved"
    }
    
    let saveButtonSize = CGSize(width: 25, height: 25)
    let saveButtonBorderInsets = UIEdgeInsets(top: 5, left: .zero, bottom: .zero, right: 5)
    private var downloadTask: URLSessionDownloadTask?
    public var imageURL: URL? {
            didSet {
                self.downloadGifImage(imageURL: imageURL)
            }
    }
    
    weak var delegate: GifCollectorCellDelegate?
    var gifUrlString: String = ""
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    lazy var gifImageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.addTarget(self, action: #selector(pinButtonTap(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var gifImage: UIImage? {
        get {
            return gifImageView.image
        }
        set {
            gifImageView.image = newValue
            gifImageView.sizeToFit()
            spinner.stopAnimating()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(gifImageView)
        self.contentView.addSubview(spinner)
        self.addSubview(saveButton)
        self.backgroundColor = .black
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        gifImageView.image = nil
    }
        
    @objc func pinButtonTap(_ sender: Any) {
        delegate?.pinGifTapped(delegateFrom: self)
    }
    
    func setupViews() {
        gifImageView.edgesToSuperView()
        spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        saveButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: saveButtonBorderInsets.top).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -saveButtonBorderInsets.right).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: saveButtonSize.height).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: saveButtonSize.width).isActive = true
    }
    
    func setupCell(forType type: cellType) {
        switch type {
        case .general:
            let imageName = "pin"
            saveButton.setImage(UIImage.init(systemName: imageName), for: .normal)
        case.saved:
            saveButton.setImage(UIImage.init(systemName: "pin.slash"), for: .normal)
        }
    }
    
    public func downloadGifImage(imageURL: URL?) {
        
        if let urlOfImage = imageURL {
            if let cachedImage = imageCache.object(forKey: urlOfImage.absoluteString as NSString){
                self.gifImage = cachedImage
            } else {
                let session = URLSession.shared
                self.downloadTask = session.downloadTask(
                    with: urlOfImage as URL, completionHandler: { [weak self] url, response, error in
                        if error == nil, let url = url,
                           let data = try? Data(contentsOf: url),
                           let source = CGImageSourceCreateWithData(data as CFData, nil),
                           let image = UIImage.animatedImageWithSource(source) {
                            
                            DispatchQueue.main.async() {
                                let imageToCache = image
                                if let strongSelf = self {
                                    strongSelf.gifImage = imageToCache
                                    imageCache.setObject(imageToCache, forKey: urlOfImage.absoluteString as NSString , cost: 1)
                                }
                            }
                        } else {
                            //print("ERROR \(String(describing: error?.localizedDescription))")
                        }
                    })
                self.downloadTask!.resume()
            }
        }
    }
    
    override public func prepareForReuse() {
        self.downloadTask?.cancel()
        self.gifImage = nil
    }
}
