//
//  ViewController.swift
//  FlatRockyMovies
//
//  Created by Gaga Nizharadze on 29.07.22.
//

import UIKit

class MainPageViewController: UIViewController {
    
    private let viewModel = MainScreenViewModel()

    
    private let genresStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
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
        
        viewModel.loadMovie(endPoint: .nowPlaying)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        // Do any additional setup after loading the view.
        
        
        viewModel.reloadTableView = {
            self.tableView.reloadData()
        }
        
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
        
        viewModel.moveActiveIndicatorView(mainButton: nowPlayingButton,
                                          button2: upCommingButton,
                                          button3: popularButton,
                                          button4: topRatedButton,
                                          indicatorView: activeIndicatorView)
    }
    
    @objc func upCommingButtonAction() {
        viewModel.loadMovie(endPoint: .upcoming)
        
        viewModel.moveActiveIndicatorView(mainButton: upCommingButton,
                                          button2: nowPlayingButton,
                                          button3: popularButton,
                                          button4: topRatedButton,
                                          indicatorView: activeIndicatorView)
    }
    
    @objc func popularButtonAction() {
        viewModel.loadMovie(endPoint: .popular)
        
        viewModel.moveActiveIndicatorView(mainButton: popularButton,
                                          button2: upCommingButton,
                                          button3: nowPlayingButton,
                                          button4: topRatedButton,
                                          indicatorView: activeIndicatorView)
    }
    
    @objc func topRatedButtonAction() {
        viewModel.loadMovie(endPoint: .topRated)
        
        viewModel.moveActiveIndicatorView(mainButton: topRatedButton,
                                          button2: upCommingButton,
                                          button3: popularButton,
                                          button4: nowPlayingButton,
                                          indicatorView: activeIndicatorView)
    }
    
    
    private func configureUIElements() {
        createGenresSectionButtonsAndAddInStackView()
        
        view.addSubview(activeIndicatorView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            genresStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            genresStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            genresStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            genresStackView.heightAnchor.constraint(equalToConstant: 30),
            
            activeIndicatorView.topAnchor.constraint(equalTo: genresStackView.bottomAnchor, constant: 2),
            activeIndicatorView.leadingAnchor.constraint(equalTo: genresStackView.leadingAnchor, constant: 5),
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
            label.text = "Unfavorite Films"
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
            
//            let favCount = getFavoriteFilms().count
            if section == 0 {
                return viewModel.numberOfRowsInSection()
            }
            else {
                return 0 // sortByGenre.count - favCount
            }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as! MovieTableViewCell
        cell.backgroundColor = UIColor(named: "color_backgroundColor")
        
        cell.data = viewModel.cellForRowAt(indexPath: indexPath)
        
        return cell
        
//        let favFilms = getFavoriteFilms()
//        let unfavFilms = getUnfavoriteFilms()
//
//        guard let cell = MoviesTableViewCell()
//
//        cell.delegate = self
//
//        if indexPath.section == 0 {
//            cell.setUpUI(model: favFilms[indexPath.row])
//
//            return cell
//        }
//
//        else {
//            cell.setUpUI(model: unfavFilms[indexPath.row])
//
//            return cell
//        }
        
    }
    
//    private func confUIForDetails(vc: MovieDetailsViewController, model: Movie) {
//        vc.configureElements(model: model)
//
//
////        let removedSelectedMovie = movies.filter { $0 != model }
//        vc.moviesWithSameGenres = movies.filter { $0.genre == model.genre }
//
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let sb = UIStoryboard(name: "MovieDetails", bundle: Bundle.main)
//        guard let vc = sb.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController else { return }
//
//        vc.delegate = self
//
//        _ = vc.view
//
//
//        if indexPath.section == 0 {
//            confUIForDetails(vc: vc, model: getFavoriteFilms()[indexPath.row])
//        }
//        else {
//            confUIForDetails(vc: vc, model: getUnfavoriteFilms()[indexPath.row])
//        }
//
//
//
//        navigationController?.pushViewController(vc, animated: true)
//
//    }
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
