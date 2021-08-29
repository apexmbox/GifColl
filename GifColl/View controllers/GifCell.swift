//
//  GifCell.swift
//  GifColl
//
//  Created by Apex on 29.08.2021.
//

import UIKit

class GifCell: UICollectionViewCell {
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    var gifImageView: UIImageView! {

    }
    
//    lazy var gifImageView: UIImageView = {
//        let img = UIImageView()
//        img.translatesAutoresizingMaskIntoConstraints = false
//        //img.image = gifImage
//        return img
//    }()
//
    private var gifImage: UIImage? {
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
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupViews() {
        gifImageView.edgesToSuperView()
        spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func setupCell(colour: UIColor) {
        self.backgroundColor = colour
    }
}
