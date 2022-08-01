//
//  MovieDetailsViewModel.swift
//  FlatRockyMovies
//
//  Created by Gaga Nizharadze on 31.07.22.
//

import Foundation
import UIKit

class MovieDetailsViewModel {
    
    func createStaticLabelsForMovieDetails(labelText: String) -> UILabel {
        
        let label = UILabel()
        label.text = labelText
        costumizeLabel(label: label)
        
        return label
    }
    
    func costumizeLabel(label: UILabel) {
        label.font = .systemFont(ofSize: 17)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func createHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        return stackView
    }
    
    func createDetailsHorizontalStackView(staticLabelText: String) -> UIStackView {
            
        let genreStackView = createHorizontalStackView()
        let genreStaticLabel = createStaticLabelsForMovieDetails(labelText: staticLabelText)
//        label = createStaticLabelsForMovieDetails(labelText: "1")
//        label.textAlignment = .right
        
        genreStackView.addArrangedSubview(genreStaticLabel)
//        genreStackView.addArrangedSubview(label)
        
            
        return genreStackView
    }
    
}
