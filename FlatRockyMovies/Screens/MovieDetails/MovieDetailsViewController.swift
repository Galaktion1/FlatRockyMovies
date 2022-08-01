//
//  MovieDetailsViewController.swift
//  FlatRockyMovies
//
//  Created by Gaga Nizharadze on 30.07.22.
//

import UIKit

protocol MovieDetailsViewControllerDelegate {
    func changeIsFavProperty(isFav: Bool, id: Int)
}

class MovieDetailsViewController: UIViewController {
    
    private let viewModel = MovieDetailsViewModel()
    
    var delegate: MovieDetailsViewControllerDelegate?
    
    var movieData: Movie? {
        didSet {
            titleLabel.text = movieData?.title
            imdbLabel.text = "\(movieData?.voteAverage ?? 0.0)"
            ratingInStarsLabel.text = movieData?.ratingText
            genreLabel.text = "\(movieData?.voteCount ?? 0)"
            originalLanguageLabel.text = movieData?.originalLanguage?.uppercased()
            
            releaseYearLabel.text = movieData?.releaseDate
            overviewTextView.text = movieData?.overview
            if let movieData = movieData {
                mainImageView.loadImageUsingCache(withUrl: movieData.backdropURLString)
            }
            
            if let isFav = movieData?.isFavourite {
                if isFav {
                    favButton.isSelected = true
                } else { favButton.isSelected = false }
            }
             
        }
    }
    
    private let mainImageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        
        return img
    }()
    
    private let overviewBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "color_moreLightThanBackground")
        
        return view
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 35
        button.backgroundColor = .systemIndigo
        button.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 21)
        label.text = "The Godfather Godfather Godfather "
        label.numberOfLines = 3
        
        var widthConstraint = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .lessThanOrEqual, toItem: label.superview, attribute: .width, multiplier: 1.0, constant: 220)
        label.addConstraint(widthConstraint)
        
        return label
    }()
    
    let favButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemRed
        button.backgroundColor = .clear
        button.isSelected ? button.setImage(UIImage(systemName: "heart.fill"), for: .selected) : button.setImage(UIImage(systemName: "heart"), for: .normal)
        
        button.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        
        return button
    }()
    
    @objc func makeMovieFavourite(_ sender: UIButton) {
        
        var favMovies  = UserDefaults.standard.array(forKey: "favMovies") as? [Int] ?? []
        
        if sender.isSelected {
            
            movieData?.isFavourite = true
            if let id = movieData?.id {
                delegate?.changeIsFavProperty(isFav: !sender.isSelected, id: id)
                if favMovies.contains(id) {
                    favMovies = favMovies.filter { $0 != id }
                    UserDefaults.standard.set(favMovies, forKey: "favMovies")
                    print(favMovies)
                }
            }
        
        }
        else {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .selected)
            
            if let id = movieData?.id {
                delegate?.changeIsFavProperty(isFav: !sender.isSelected, id: id)
                if !favMovies.contains(id) {
                    favMovies.append(id)
                    UserDefaults.standard.set(favMovies, forKey: "favMovies")
                    print(favMovies)
                }
            }
        }
        
        sender.isSelected.toggle()
    }
    
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
    
    private let overviewTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textColor = .white
        
        return textView
    }()
    
    
    private let miniDetailsAboutMovieBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "color_moreLightThanBackground")
        
        return view
    }()
    
    private var genreLabel:  UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private var releaseYearLabel:  UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private var originalLanguageLabel:  UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        
        return label
    }()
    
    
    
    private let miniDetailsAboutMovieStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "color_backgroundColor")
        confMiniDetailsAboutMovieStackView()
        favButton.addTarget(self, action: #selector(makeMovieFavourite(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let isFav = movieData?.isFavourite {
            if isFav {
                favButton.isSelected = true
            } else { favButton.isSelected = false }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureUIElementsConstraints()
    }
    
    private func confMiniDetailsAboutMovieStackView() {
        let genreStackView = viewModel.createDetailsHorizontalStackView(staticLabelText: "Vote Count:")
        viewModel.costumizeLabel(label: genreLabel)
        genreStackView.addArrangedSubview(genreLabel)
        
        let releaseYearStackView = viewModel.createDetailsHorizontalStackView(staticLabelText: "Release Date:")
        viewModel.costumizeLabel(label: releaseYearLabel)
        releaseYearStackView.addArrangedSubview(releaseYearLabel)
        
        let originalLanguageStackView = viewModel.createDetailsHorizontalStackView(staticLabelText: "Original Language: ")
        viewModel.costumizeLabel(label: originalLanguageLabel)
        originalLanguageStackView.addArrangedSubview(originalLanguageLabel)
        
        miniDetailsAboutMovieStackView.addArrangedSubview(genreStackView)
        miniDetailsAboutMovieStackView.addArrangedSubview(releaseYearStackView)
        miniDetailsAboutMovieStackView.addArrangedSubview(originalLanguageStackView)
        
        miniDetailsAboutMovieBackgroundView.addSubview(miniDetailsAboutMovieStackView)
        
        view.addSubview(miniDetailsAboutMovieBackgroundView)
        
        
    }
    
    private func confImdbAndStarsRatingStackView() {
        imdbAndStarsRatingStackView.addArrangedSubview(imdbLabel)
        imdbAndStarsRatingStackView.addArrangedSubview(ratingInStarsLabel)
        overviewBackgroundView.addSubview(imdbAndStarsRatingStackView)
    }
    
    private func configureUIElementsConstraints() {
        view.addSubview(mainImageView)
        view.addSubview(overviewBackgroundView)
        confImdbAndStarsRatingStackView()
        overviewBackgroundView.addSubview(overviewTextView)
        overviewBackgroundView.addSubview(titleLabel)
        overviewBackgroundView.addSubview(favButton)
        overviewBackgroundView.addSubview(playButton)
        
        
        NSLayoutConstraint.activate([
            mainImageView.heightAnchor.constraint(equalToConstant: view.bounds.height / 3.5),
            mainImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mainImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mainImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            overviewBackgroundView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -40),
            overviewBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            overviewBackgroundView.heightAnchor.constraint(equalToConstant: 347),
            
            
            playButton.topAnchor.constraint(equalTo: overviewBackgroundView.topAnchor, constant: -35),
            playButton.trailingAnchor.constraint(equalTo: overviewBackgroundView.trailingAnchor, constant: -15),
            playButton.heightAnchor.constraint(equalToConstant: 70),
            playButton.widthAnchor.constraint(equalToConstant: 70),
            
            titleLabel.topAnchor.constraint(equalTo: overviewBackgroundView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: overviewBackgroundView.leadingAnchor, constant: 8),
//            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            favButton.topAnchor.constraint(equalTo: overviewBackgroundView.topAnchor, constant: 4),
            favButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            favButton.heightAnchor.constraint(equalToConstant: 30),
            favButton.widthAnchor.constraint(equalToConstant: 30),
            
            imdbAndStarsRatingStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            imdbAndStarsRatingStackView.leadingAnchor.constraint(equalTo: overviewBackgroundView.leadingAnchor, constant: 8),
            imdbAndStarsRatingStackView.widthAnchor.constraint(equalToConstant: 130),
            
            
            overviewTextView.topAnchor.constraint(equalTo: imdbAndStarsRatingStackView.bottomAnchor, constant: 20),
            overviewTextView.leadingAnchor.constraint(equalTo: overviewBackgroundView.leadingAnchor, constant: 8),
            overviewTextView.trailingAnchor.constraint(equalTo: overviewBackgroundView.trailingAnchor, constant: -8),
            overviewTextView.bottomAnchor.constraint(equalTo: overviewBackgroundView.bottomAnchor, constant: -50),
            
            miniDetailsAboutMovieBackgroundView.topAnchor.constraint(equalTo: overviewBackgroundView.bottomAnchor, constant: 40),
            miniDetailsAboutMovieBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            miniDetailsAboutMovieBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            miniDetailsAboutMovieBackgroundView.heightAnchor.constraint(equalToConstant: 140),
            
            miniDetailsAboutMovieStackView.topAnchor.constraint(equalTo: miniDetailsAboutMovieBackgroundView.topAnchor, constant: 20),
            miniDetailsAboutMovieStackView.leadingAnchor.constraint(equalTo: miniDetailsAboutMovieBackgroundView.leadingAnchor, constant: 10),
            miniDetailsAboutMovieStackView.trailingAnchor.constraint(equalTo: miniDetailsAboutMovieBackgroundView.trailingAnchor, constant: -10),
            miniDetailsAboutMovieStackView.bottomAnchor.constraint(equalTo: miniDetailsAboutMovieBackgroundView.bottomAnchor, constant: -20),
            
            
            
            
            
        ])
    }
    
}



#if canImport(swiftUI) && DEBUG
import SwiftUI
struct PreviewMovieDetailsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            MovieDetailsViewController()
        }.previewDevice("iPhone 12").previewInterfaceOrientation(.portrait)
    }
}

struct MovieDetailsViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewControllerBuilder: () -> UIViewController

    init(_ viewControllerBuilder: @escaping () -> UIViewController) {
        self.viewControllerBuilder = viewControllerBuilder
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        return viewControllerBuilder()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
#endif
