//
//  RecentSearchCollectionViewCell.swift
//  FightClub
//
//  Created by Anagha Wadkar on 27/04/21.
//

import UIKit

class RecentSearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    var viewModel: RecentSearchCellViewModel?
    
    func configure() {
        viewModel?.name.bind { [weak self] (name) in
            self?.movieNameLabel.text = name
        }
        viewModel?.poster.bind(listener: { [weak self] (path) in
            self?.movieImageView.load(urlString: "https://image.tmdb.org/t/p/w500" + path)
        })
    }

}
