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
    private var moviesData = [Movie](){
        didSet {
            self.reloadTableView?()
        }
    }
    
    func createGenresButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle("\(title)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.titleLabel?.textColor = .white
        
        return button
    }
    
    
    func loadMovie(endPoint: MovieListEndpoint) {
         MovieStore.shared.fetchMovies(from: endPoint) { result in
            switch result {
            case .success(let response):
                self.moviesData = response.results
                
            case . failure(let error):
                print(error)
            }
        }

    }
    
    
    func numberOfRowsInSection() -> Int {
        moviesData.count
        
        
    }
    
    func cellForRowAt (indexPath: IndexPath) -> Movie {
        moviesData[indexPath.row]
    }
    
    
    func moveActiveIndicatorView(mainButton: UIButton, button2: UIButton, button3: UIButton, button4: UIButton, indicatorView: UIView) {
        mainButton.tintColor = .systemYellow
        button2.tintColor = .white
        button3.tintColor = .white
        button4.tintColor = .white
        
        let xCoordinant = mainButton.frame.origin.x
        let mainButtonWidth = mainButton.frame.width
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options:[], animations: {
            indicatorView.transform = CGAffineTransform(translationX: xCoordinant, y: 0)
            indicatorView.frame.size.width = mainButtonWidth
            }, completion: nil)
    }

    
    
    
}
