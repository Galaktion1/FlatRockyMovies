//
//  MoviesCollectionViewCell.swift
//  FlatRockyMovies
//
//  Created by Gaga Nizharadze on 01.08.22.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: MoviesCollectionViewCell.self)
    
    private let movieImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 25
//        imgView.contentMode = .scaleAspectFill
        
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(movieImageView)
        movieImageView.frame = contentView.frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func configureUIElements(imageURLString: String) {
        movieImageView.loadImageUsingCache(withUrl: imageURLString)
    }
    
}
