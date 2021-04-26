//
//  CrewDetailsCollectionViewCell.swift
//  FightClub
//
//  Created by Anagha Wadkar on 26/04/21.
//

import UIKit

class CrewDetailsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var characterName: UILabel!
    
    var viewModel: CrewDetailsCellViewModel?
    
    func configure() {
       profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
        viewModel?.name.bind(listener: {[weak self] (name) in
            self?.name.text = name
        })
        viewModel?.characterName.bind(listener: {[weak self] (characterName) in
            self?.characterName.text = characterName
        })
        viewModel?.profileImage.bind(listener: {[weak self] (path) in
            self?.profileImage.load(urlString: "https://image.tmdb.org/t/p/w500" + path)
        })
        
    }
}
