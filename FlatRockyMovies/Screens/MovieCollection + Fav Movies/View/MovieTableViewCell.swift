//
//  MovieTableViewCell.swift
//  FlatRockyMovies
//
//  Created by Gaga Nizharadze on 30.07.22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    var data: Movie? {
        didSet {
            titleLabel.text = data?.title
            popularityLabel.text = "Popularity: \(data?.popularity ?? 0.0)"
            releaseDateLabel.text = "Release date: \(data?.releaseDate ?? "")"
            imdbLabel.text = "\(data?.voteAverage ?? 0.0)"
            ratingInStarsLabel.text = data?.ratingText
            
            if let urlString = data?.posterURLString {
                movieImageView.loadImageUsingCache(withUrl: urlString)
            }
            
        }
    }
    
    private let movieInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "color_moreLightThanBackground")
        
        return view
    }()
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        
        return label
    }()
    
    private let popularityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .systemGray
        label.text = "Popularity: "
        
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .systemGray
        label.text = "Release date: "
        
        return label
    }()
    
    
    private let popularityAndDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.alignment = .fill
        
        return stackView
    }()
    
    
    private let imdbLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25)
        label.textColor = .systemYellow
        label.text = "9.1"
        
        return label
    }()
    
    private let ratingInStarsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = "⭐️⭐️⭐️⭐️⭐️"
        
        return label
    }()
    
    private let imdbAndStarsRatingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.alignment = .fill
        
        return stackView
    }()
    
    
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Set any attributes of your UI components here.
       confUIElements()
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func confPopularityAndDateStackView() {
        popularityAndDateStackView.addArrangedSubview(popularityLabel)
        popularityAndDateStackView.addArrangedSubview(releaseDateLabel)
        
        movieInfoView.addSubview(popularityAndDateStackView)
    }
    
    private func confImdbAndStarsRatingStackView() {
        imdbAndStarsRatingStackView.addArrangedSubview(imdbLabel)
        imdbAndStarsRatingStackView.addArrangedSubview(ratingInStarsLabel)
        movieInfoView.addSubview(imdbAndStarsRatingStackView)
    }
    
    
    private func confUIElements() {
        

        contentView.addSubview(movieInfoView)
        confPopularityAndDateStackView()
        confImdbAndStarsRatingStackView()
        movieInfoView.addSubview(movieImageView)
        movieInfoView.addSubview(titleLabel)
        
        
        NSLayoutConstraint.activate([
            movieInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            movieInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            movieInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            movieInfoView.heightAnchor.constraint(equalToConstant: 240),
            
            movieImageView.leadingAnchor.constraint(equalTo: movieInfoView.leadingAnchor, constant: 5),
            movieImageView.bottomAnchor.constraint(equalTo: movieInfoView.bottomAnchor, constant: -20),
            movieImageView.widthAnchor.constraint(equalToConstant: 187),
            movieImageView.heightAnchor.constraint(equalToConstant: 336),
            
            titleLabel.topAnchor.constraint(equalTo: movieInfoView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 35),
            titleLabel.trailingAnchor.constraint(equalTo: movieInfoView.trailingAnchor, constant: -20),
            
            popularityAndDateStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            popularityAndDateStackView.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 35),
            
            imdbAndStarsRatingStackView.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 35),
            imdbAndStarsRatingStackView.bottomAnchor.constraint(equalTo: movieInfoView.bottomAnchor, constant: -30),
            imdbAndStarsRatingStackView.heightAnchor.constraint(equalToConstant: 30)
            
        ])
    }

}


