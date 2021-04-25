//
//  MovieListTableViewCell.swift
//  FightClub
//
//  Created by Anagha Wadkar on 25/04/21.
//

import Foundation
import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var bookButton: UIButton!
    
    var movieViewModel: MovieListViewCellModel?
    
    func configure() {
        movieViewModel?.name.bind { [weak self] (name) in
            self?.name.text = name
        }
        movieViewModel?.releaseDate.bind(listener: { [weak self] (date) in
            self?.releaseDate.text = date
        })
        movieViewModel?.poster.bind(listener: { [weak self] (path) in
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + path) else {
                return
            }
            self?.poster.load(url: url)
        })
        bookButton.layer.cornerRadius = 12.0
    }
    
    @IBAction func bookButtonPressed(_ sender: Any) {
        //TODO: Implement Alert on Book button press
    }
}

