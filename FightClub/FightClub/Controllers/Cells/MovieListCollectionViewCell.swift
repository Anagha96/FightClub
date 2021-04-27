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
    
    var viewModel: MovieListViewCellModel?
    weak var delegate: MovieListCellDelegate?
    
    func configure(isBookingEnabled: Bool = false) {
        bookButton.isHidden = !isBookingEnabled
        viewModel?.name.bind { [weak self] (name) in
            self?.name.text = name
        }
        viewModel?.releaseDate.bind(listener: { [weak self] (date) in
            self?.releaseDate.text = date
        })
        viewModel?.poster.bind(listener: { [weak self] (path) in
            self?.poster.load(urlString: "https://image.tmdb.org/t/p/w500" + path)
        })
        bookButton.layer.cornerRadius = 12.0
    }
    
    @IBAction func bookButtonPressed(_ sender: Any) {
        delegate?.handleButtonPress()
    }
}

