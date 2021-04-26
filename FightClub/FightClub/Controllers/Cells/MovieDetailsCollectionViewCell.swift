//
//  MovieDetailsCollectionViewCell.swift
//  FightClub
//
//  Created by Anagha Wadkar on 26/04/21.
//

import UIKit

class MovieDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagLineLabel: UILabel!
    @IBOutlet weak var backDropImage: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var overViewLabel: UILabel!
    
    var viewModel: MovieDetailsCellViewModel?
    
    func configure() {
        self.viewModel?.tagLine.bind {[weak self] (tagline) in
            DispatchQueue.main.async {
                self?.tagLineLabel.text = tagline
            }
        }
        
        self.viewModel?.movieName.bind {[weak self] (name) in
            DispatchQueue.main.async {
                self?.movieNameLabel.text = name
            }
        }
        
        self.viewModel?.infoDetails.bind {[weak self] (info) in
            DispatchQueue.main.async {
                self?.infoLabel.text = info
            }
        }
        
        self.viewModel?.backDrop.bind {[weak self] (path) in
            DispatchQueue.main.async {
                self?.backDropImage.load(urlString: path)
            }
        }
        
        self.viewModel?.overview.bind{[weak self]  (overview) in
            DispatchQueue.main.async {
                self?.overViewLabel.text = overview
            }
        }
    }
    
    @IBAction func moreButtonPressed(_ sender: Any) {
        if moreButton.titleLabel?.text == "more" {
            self.overViewLabel.numberOfLines = 0
            self.overViewLabel.lineBreakMode = .byWordWrapping
            moreButton.setTitle("less", for: .normal)
        } else {
            self.overViewLabel.numberOfLines = 2
            self.overViewLabel.lineBreakMode = .byTruncatingTail
            moreButton.setTitle("more", for: .normal)
        }
    }
    
}
