//
//  ViewController.swift
//  FlatRockyMovies
//
//  Created by Gaga Nizharadze on 29.07.22.
//

import UIKit

class MainPageViewController: UIViewController {
    
    private let viewModel = MainScreenViewModel()
    
    private var currentPage: MovieListEndpoint = .nowPlaying
    
    var onlyFavMovies = [Movie]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var favMoviesIndecies = [Int]() {
        didSet {
            if favMoviesIndecies.count != oldValue.count {
                for index in 0 ..< viewModel.moviesData.count {
                    if favMoviesIndecies.contains(viewModel.moviesData[index].id!) {
                        viewModel.moviesData[index].isFavourite = true
                    }
                }
                tableView.reloadData()
            }
        }
    }
    
    private let genresStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = UIColor(named: "color_backgroundColor")
        
        return stackView
    }()
    
    private let activeIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "color_backgroundColor")
        tableView.separatorStyle = .none

        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "color_backgroundColor")
        
        nowPlayingButtonAction()
        nowPlayingButton.setTitleColor(.systemYellow, for: .normal)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        // Do any additional setup after loading the view.
        
        
        viewModel.reloadTableView = {
            self.tableView.reloadData()
        }
        
        createGenresSectionButtonsAndAddInStackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favMoviesIndecies = UserDefaults.standard.array(forKey: "favMovies") as? [Int] ?? []
        
        viewModel.updateFavInfo = { info in
            self.onlyFavMovies = info
        }
        
        viewModel.loadMovie(endPoint: currentPage)  // every time when user pop to root viewcontroller, I'm reloading page if he liked/unliked movie
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUIElements()
    }
    
    
    
    var nowPlayingButton = UIButton()
    var upCommingButton = UIButton()
    var popularButton = UIButton()
    var topRatedButton = UIButton()
    
    private func createGenresSectionButtonsAndAddInStackView() {
        
        nowPlayingButton = viewModel.createGenresButton(title: "NowPlaying")
        nowPlayingButton.addTarget(self, action: #selector(nowPlayingButtonAction), for: .touchUpInside)
        
        upCommingButton = viewModel.createGenresButton(title: "UpComming")
        upCommingButton.addTarget(self, action: #selector(upCommingButtonAction), for: .touchUpInside)
        
        popularButton = viewModel.createGenresButton(title: "Popular")
        popularButton.addTarget(self, action: #selector(popularButtonAction), for: .touchUpInside)
        
        topRatedButton = viewModel.createGenresButton(title: "TopRated")
        topRatedButton.addTarget(self, action: #selector(topRatedButtonAction), for: .touchUpInside)
        
        
        genresStackView.addArrangedSubview(nowPlayingButton)
        genresStackView.addArrangedSubview(upCommingButton)
        genresStackView.addArrangedSubview(popularButton)
        genresStackView.addArrangedSubview(topRatedButton)
        view.addSubview(genresStackView)
        
    }
    
    @objc func nowPlayingButtonAction() {
        viewModel.loadMovie(endPoint: .nowPlaying)
        
        
        viewModel.moveActiveIndicatorView(mainButton: nowPlayingButton, otherButtons: [upCommingButton, popularButton, topRatedButton],
                                          indicatorView: activeIndicatorView)
        currentPage = .nowPlaying
    }
    
    
    @objc func upCommingButtonAction() {
        viewModel.loadMovie(endPoint: .upcoming)
        
        viewModel.moveActiveIndicatorView(mainButton: upCommingButton, otherButtons: [nowPlayingButton, popularButton, topRatedButton],
                                          indicatorView: activeIndicatorView)
        currentPage = .upcoming
    }
    
    
    @objc func popularButtonAction() {
        viewModel.loadMovie(endPoint: .popular)
        
        viewModel.moveActiveIndicatorView(mainButton: popularButton, otherButtons: [nowPlayingButton, upCommingButton, topRatedButton],
                                          indicatorView: activeIndicatorView)
        currentPage = .popular
    }
    
    @objc func topRatedButtonAction() {
        viewModel.loadMovie(endPoint: .topRated)
        
        viewModel.moveActiveIndicatorView(mainButton: topRatedButton, otherButtons: [nowPlayingButton, popularButton, upCommingButton],
                                          indicatorView: activeIndicatorView)
        currentPage = .topRated
    }
    
    
    private func configureUIElements() {
        
        view.addSubview(activeIndicatorView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            genresStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 10),
            genresStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            genresStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            genresStackView.heightAnchor.constraint(equalToConstant: 30),
            
            activeIndicatorView.topAnchor.constraint(equalTo: genresStackView.bottomAnchor, constant: 2),
            activeIndicatorView.leadingAnchor.constraint(equalTo: genresStackView.leadingAnchor, constant: 0),
            activeIndicatorView.heightAnchor.constraint(equalToConstant: 2),
            activeIndicatorView.widthAnchor.constraint(equalToConstant: 100),
            
            tableView.topAnchor.constraint(equalTo: genresStackView.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        ])
    }
    
    
    private struct TableViewConstants {
        static let numberOfSections = 2
        static let heightForHeaderInSection: CGFloat = 50
        static let heightForRow: CGFloat = 406
    }
    
    
}


extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        TableViewConstants.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: TableViewConstants.heightForHeaderInSection))
        headerView.backgroundColor =  UIColor(named: "color_backgroundColor")
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        if section == 0 {
            label.text = "All Films"
        }
        else {
            label.text = "Favourite Films"
        }
        
        label.font = .systemFont(ofSize: 26)
        label.textColor = .yellow
        
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TableViewConstants.heightForHeaderInSection
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableViewConstants.heightForRow
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if section == 0 {
                return viewModel.numberOfRowsInSection()
            }
            else {
                return onlyFavMovies.count
            }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as! MovieTableViewCell
        cell.backgroundColor = UIColor(named: "color_backgroundColor")
        cell.selectionStyle = .none
        
        

        if indexPath.section == 0 {
            cell.data = viewModel.cellForRowAtForAllMovies(indexPath: indexPath)

            return cell
        }

        else {
            cell.data = viewModel.cellForRowAtForFavMovies(indexPath: indexPath)

            return cell
        }
        
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        let vc = MovieDetailsViewController()
    
        vc.delegate = self
        vc.moviesWithSameGenres = viewModel.moviesData
        
        if indexPath.section == 0 {
            
            vc.isFavourite = false
            
            vc.movieData = viewModel.cellForRowAtForAllMovies(indexPath: indexPath)
            
        }
        else {
            vc.isFavourite = true
            vc.movieData = viewModel.cellForRowAtForFavMovies(indexPath: indexPath)
        }
        
        navigationController?.pushViewController(vc, animated: true)

    }
}


extension MainPageViewController: MovieDetailsViewControllerDelegate {
    func changeIsFavProperty(isFav: Bool, id: Int) {
        for index in 0 ..< viewModel.moviesData.count {      // I'm using this kind of for cycle, becouse moviesData is array of struct (value type)
            if viewModel.moviesData[index].id == id {
                viewModel.moviesData[index].isFavourite = isFav
            }
        }
    }
}







#if canImport(swiftUI) && DEBUG
import SwiftUI
struct PreviewViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            MainPageViewController()
        }.previewDevice("iPhone 12").previewInterfaceOrientation(.portrait)
    }
}

struct ViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
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
