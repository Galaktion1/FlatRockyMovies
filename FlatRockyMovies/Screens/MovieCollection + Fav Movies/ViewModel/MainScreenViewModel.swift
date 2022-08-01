//
//  MainScreenViewModel.swift
//  FlatRockyMovies
//
//  Created by Gaga Nizharadze on 30.07.22.
//

import Foundation
import UIKit


class MainScreenViewModel {
    
    var reloadTableView: (()->Void)?
    var moviesData = [Movie](){
        didSet {
            generateFavMoviesArray()
            self.reloadTableView?()
        }
    }
    
    var updateFavInfo: (([Movie])->())?
    private var onlyFavMovies = [Movie]() {
        didSet {
            self.updateFavInfo?(onlyFavMovies)
        }
    }
    
    func createGenresButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle("\(title)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19)
        button.titleLabel?.textColor = .white
        
        return button
    }
    
    
    func loadMovie(endPoint: MovieListEndpoint) {
         MovieStore.shared.fetchMovies(from: endPoint) { result in
            switch result {
            case .success(let response):
                if let result = response.results {
                    self.moviesData = result
                }
                
            case . failure(let error):
                print(error)
            }
        }

    }
    
    
    func numberOfRowsInSection() -> Int {
        moviesData.count
    }
    
    func cellForRowAtForAllMovies (indexPath: IndexPath) -> Movie {
        moviesData[indexPath.row]
    }
    
    func cellForRowAtForFavMovies (indexPath: IndexPath) -> Movie {
        onlyFavMovies[indexPath.row]
    }
    
    func getMovies() -> [Movie] {
        moviesData
    }
    
    
    func generateFavMoviesArray()  {
        if let  favIndecies = UserDefaults.standard.array(forKey: "favMovies") as? [Int] {
            onlyFavMovies = moviesData.filter { favIndecies.contains($0.id!) }
        }
        
    }
    
    
    private func makeButtonSelected(mainButton: UIButton, otherButtons: [UIButton]) {
        mainButton.isSelected = true
        mainButton.setTitleColor(.systemYellow, for: .selected)
        
        otherButtons.forEach {
            $0.isSelected = false
            $0.setTitleColor(.white, for: .normal)
        }
    }
    
    func moveActiveIndicatorView(mainButton: UIButton, otherButtons: [UIButton], indicatorView: UIView) {
        
        makeButtonSelected(mainButton: mainButton, otherButtons: otherButtons)
        
        let xCoordinant = mainButton.frame.origin.x
        let mainButtonWidth = mainButton.frame.width
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options:[], animations: {
            indicatorView.transform = CGAffineTransform(translationX: xCoordinant, y: 0)
            indicatorView.frame.size.width = mainButtonWidth
            }, completion: nil)
        
    }
}



