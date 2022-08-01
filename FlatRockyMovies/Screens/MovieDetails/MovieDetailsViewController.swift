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
    var moviesWithSameGenres = [Movie]()
    
    
    var delegate: MovieDetailsViewControllerDelegate?
    
    var isFavourite: Bool! {
        didSet {
            checkIfFav()
        }
    }
    
    var movieData: Movie? {
        didSet {
            titleLabel.text = movieData?.title
            imdbLabel.text = "\(movieData?.voteAverage ?? 0.0)"
            ratingInStarsLabel.text = movieData?.ratingText
            voteCountLabel.text = "\(movieData?.voteCount ?? 0)"
            originalLanguageLabel.text = movieData?.originalLanguage?.uppercased()
            
            releaseYearLabel.text = movieData?.releaseDate
            overviewTextView.text = movieData?.overview
            if let movieData = movieData {
                mainImageView.loadImageUsingCache(withUrl: movieData.backdropURLString) }
            
            checkIfFav()
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
        button.isUserInteractionEnabled = true
        
        button.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        
        return button
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
    
    
    private var voteCountLabel:  UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        
        return label
    }()
    
    
    private var releaseYearLabel:  UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        
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
    
    
    private let sameSectionMoviesCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 180, height: 180), collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isDirectionalLockEnabled = true
        
        return scrollView
        
    }()
    
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "color_backgroundColor")
        
        confMiniDetailsAboutMovieStackView()
        favButton.addTarget(self, action: #selector(makeMovieFavourite(_:)), for: .touchUpInside)
      
        
        sameSectionMoviesCollectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        sameSectionMoviesCollectionView.delegate = self
        sameSectionMoviesCollectionView.dataSource = self
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureUIElementsConstraints()
    }
    
   
    
    
    @objc func makeMovieFavourite(_ sender: UIButton) {
        
        var favMovies  = UserDefaults.standard.array(forKey: "favMovies") as? [Int] ?? []
        
        if isFavourite {
            
            isFavourite.toggle()
            if let id = movieData?.id {
                delegate?.changeIsFavProperty(isFav: isFavourite, id: id)
                if favMovies.contains(id) {
                    favMovies = favMovies.filter { $0 != id }
                    UserDefaults.standard.set(favMovies, forKey: "favMovies")
                    print(favMovies)
                }
            }
        }
        else {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear, animations: {
                self.favButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }) { (success) in
                
                self.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                   
                
                UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                    self.favButton.transform = .identity
                }, completion: nil)
            }
            isFavourite.toggle()
            if let id = movieData?.id {
                delegate?.changeIsFavProperty(isFav: isFavourite, id: id)
                if !favMovies.contains(id) {
                    favMovies.append(id)
                    UserDefaults.standard.set(favMovies, forKey: "favMovies")
                    print(favMovies)
                }
            }
        }
        
    }
    
    private func checkIfFav() {
        isFavourite ? favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal) : favButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    private func confMiniDetailsAboutMovieStackView() {
        
        let genreStackView = viewModel.createDetailsHorizontalStackView(staticLabelText: "Vote Count:")
        viewModel.costumizeLabel(label: voteCountLabel)
        genreStackView.addArrangedSubview(voteCountLabel)
        
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
        
        scrollView.addSubview(miniDetailsAboutMovieBackgroundView)
    }
    
    private func confImdbAndStarsRatingStackView() {
        imdbAndStarsRatingStackView.addArrangedSubview(imdbLabel)
        imdbAndStarsRatingStackView.addArrangedSubview(ratingInStarsLabel)
        overviewBackgroundView.addSubview(imdbAndStarsRatingStackView)
    }
    

    private func confScrollView() {
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: 450, height: 1000)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func confBackgroundView() {
        
        scrollView.addSubview(backgroundView)

        NSLayoutConstraint.activate([
           backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor),
           backgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
           backgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
           backgroundView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
           backgroundView.widthAnchor.constraint(equalToConstant: scrollView.bounds.width)
        ])
        
        let heightConstraint = backgroundView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightConstraint.priority = UILayoutPriority(rawValue: 250)
        heightConstraint.isActive = true
        
    }
    
    
    private func addSubviewInBackgroundAndInOverview() {
        backgroundView.addSubview(mainImageView)
        backgroundView.addSubview(overviewBackgroundView)
        backgroundView.addSubview(sameSectionMoviesCollectionView)
        
        confImdbAndStarsRatingStackView()
        overviewBackgroundView.addSubview(overviewTextView)
        overviewBackgroundView.addSubview(titleLabel)
        overviewBackgroundView.addSubview(favButton)
        overviewBackgroundView.addSubview(playButton)
    }
    
    private func configureUIElementsConstraints() {
        
        confScrollView()
        
        confBackgroundView()
        
        addSubviewInBackgroundAndInOverview()
        
        NSLayoutConstraint.activate([
            mainImageView.heightAnchor.constraint(equalToConstant: view.bounds.height / 4),
            mainImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 0),
            mainImageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 0),
            mainImageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: 0),
            
            overviewBackgroundView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -40),
            overviewBackgroundView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            overviewBackgroundView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            overviewBackgroundView.heightAnchor.constraint(equalToConstant: 347),
            
            
            playButton.topAnchor.constraint(equalTo: overviewBackgroundView.topAnchor, constant: -35),
            playButton.trailingAnchor.constraint(equalTo: overviewBackgroundView.trailingAnchor, constant: -15),
            playButton.heightAnchor.constraint(equalToConstant: 70),
            playButton.widthAnchor.constraint(equalToConstant: 70),
            
            titleLabel.topAnchor.constraint(equalTo: overviewBackgroundView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: overviewBackgroundView.leadingAnchor, constant: 8),
            
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
            miniDetailsAboutMovieBackgroundView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            miniDetailsAboutMovieBackgroundView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            miniDetailsAboutMovieBackgroundView.heightAnchor.constraint(equalToConstant: 140),
            
            miniDetailsAboutMovieStackView.topAnchor.constraint(equalTo: miniDetailsAboutMovieBackgroundView.topAnchor, constant: 20),
            miniDetailsAboutMovieStackView.leadingAnchor.constraint(equalTo: miniDetailsAboutMovieBackgroundView.leadingAnchor, constant: 10),
            miniDetailsAboutMovieStackView.trailingAnchor.constraint(equalTo: miniDetailsAboutMovieBackgroundView.trailingAnchor, constant: -10),
            miniDetailsAboutMovieStackView.bottomAnchor.constraint(equalTo: miniDetailsAboutMovieBackgroundView.bottomAnchor, constant: -20),
            
            sameSectionMoviesCollectionView.topAnchor.constraint(equalTo: miniDetailsAboutMovieBackgroundView.bottomAnchor, constant: 30),
            sameSectionMoviesCollectionView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            sameSectionMoviesCollectionView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -1),
            sameSectionMoviesCollectionView.heightAnchor.constraint(equalToConstant: 192)
        ])
    }
    
}



extension MovieDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        moviesWithSameGenres.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.identifier, for: indexPath) as! MoviesCollectionViewCell
        
        cell.configureUIElements(imageURLString: moviesWithSameGenres[indexPath.row].posterURLString)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 120, height: 155)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movieData = moviesWithSameGenres[indexPath.row]
    }
}


//extension MovieDetailsViewController: UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.x != 0 {
//            scrollView.contentOffset.x = 0
//        }
//    }
//
//}


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
