//
//  MovieDetailsViewController.swift
//  FightClub
//
//  Created by Anagha Wadkar on 26/04/21.
//

import Foundation
import UIKit

class MovieDetailsViewController: UIViewController {
    var selectedMovie: Int?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel = MovieDetailViewModel()
    var activityIndicator = UIActivityIndicatorView()
    
    enum Section: String, CaseIterable {
        case Cast = "Cast"
        case SimilarMovies = "Similar Movies"
        case MovieDetails = "Movie Details"
        case Reviews = "Reviews"
    }
    
    let sections: [Section] = [.MovieDetails, .Cast, .SimilarMovies, .Reviews]
    
    fileprivate func setupCollectionView() {
        collectionView.register(UINib(nibName: Constants.MovieDetails.movieCrewCellNibName, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.MovieDetails.movieCrewCellIdentifier)
        collectionView.register(UINib(nibName: Constants.MovieList.movieListCellNibName, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.MovieList.movieListCellIdentifier)
        collectionView.register(UINib(nibName: Constants.MovieDetails.movieDetailsCellNibName, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.MovieDetails.movieDetailsCellId)
        collectionView.register(UINib(nibName: Constants.MovieDetails.movieReviewsCellNibName, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.MovieDetails.movieReviewsCellIdentifier)
        collectionView.register(UINib(nibName: Constants.MovieDetails.movieDetailsSectionNibName, bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.MovieDetails.movieDetailsSectionIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.addSubview(activityIndicator)
        collectionView.collectionViewLayout = generateLayout()
    }
    
    @objc func goToHome() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    fileprivate func setupNavigationBar() {
        let homeIcon = UIImage(systemName: "homekit", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: homeIcon, style: .plain, target: self, action: #selector(goToHome))
    }
    
    fileprivate func fetchDetails() {
        viewModel.fetchMovieDetails(id: selectedMovie) { (error) in
            if error == nil {
                self.viewModel.crewList.bind { [weak self](_) in
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                        
                    }
                }
                self.viewModel.movieList.bind { [weak self](_) in
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                        
                    }
                }
                self.viewModel.movieReviews.bind { [weak self](_) in
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                        
                    }
                }
                
            } else {
                self.showAlertForError()
            }
            DispatchQueue.main.async {
                ///Stoping Activity Indicator Animation
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
        
        ///Activity Indicator Configuration
        activityIndicator.center = view.center
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        
        fetchDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
}

extension MovieDetailsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.MovieDetails.movieDetailsSectionIdentifier, for: indexPath) as? MovieDetailsSectionHeaderView else {
                return UICollectionReusableView()
            }
            headerView.sectionHeader.text = sections[indexPath.section].rawValue
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .Cast:
            return viewModel.crewList.value.count
        case .SimilarMovies:
            return viewModel.movieList.value.count
        case .MovieDetails:
            return viewModel.movieDetails.value.count
        case .Reviews:
            return viewModel.movieReviews.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .Cast:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.MovieDetails.movieCrewCellIdentifier, for: indexPath) as? CrewDetailsCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = viewModel.crewList.value[indexPath.row]
            cell.contentView.layer.cornerRadius = 8.0
            cell.configure()
            return cell
        case .SimilarMovies:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.MovieList.movieListCellIdentifier, for: indexPath) as? MovieListCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.viewModel = viewModel.movieList.value[indexPath.row]
            cell.contentView.layer.cornerRadius = 8.0
            cell.configure()
            return cell
        case .MovieDetails:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.MovieDetails.movieDetailsCellId, for: indexPath) as? MovieDetailsCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = viewModel.movieDetails.value[indexPath.row]
            cell.contentView.layer.cornerRadius = 8.0
            cell.configure()
            return cell
        case .Reviews:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.MovieDetails.movieReviewsCellIdentifier, for: indexPath) as? ReviewsCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = viewModel.movieReviews.value[indexPath.row]
            cell.contentView.layer.cornerRadius = 8.0
            cell.configure()
            return cell

        }
    }
}

extension MovieDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard sections[indexPath.section] == .SimilarMovies else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let detailsVC = storyboard.instantiateViewController(identifier: "movieDetailsViewController") as? MovieDetailsViewController {
            detailsVC.selectedMovie = viewModel.movieList.value[indexPath.row].id.value
            navigationController?.pushViewController(detailsVC, animated: true)
        }
       
        
    }
}

extension MovieDetailsViewController {
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self](sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            if let strongSelf = self {
                let sectionLayoutKind = strongSelf.sections[sectionIndex]
                switch (sectionLayoutKind) {
                case .Cast: return strongSelf.generateCastLayout()
                case .SimilarMovies:
                    return strongSelf.generateMoviesLayout()
                case .MovieDetails:
                    return strongSelf.generateMovieDetailsLayout()
                case .Reviews:
                    return strongSelf.generateReviewsLayout()
                }
            } else {
                return nil
            }
            
        }
        
        return layout
    }
    
    func generateMovieDetailsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(450))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(450))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func generateReviewsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: titleSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.boundarySupplementaryItems = [titleSupplementary]
        return section
    }
    
    func generateCastLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(140),
            heightDimension: .absolute(186))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: titleSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.boundarySupplementaryItems = [titleSupplementary]
        return section
    }
    
    func generateMoviesLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(188),
            heightDimension: .absolute(384))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: titleSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.boundarySupplementaryItems = [titleSupplementary]
        return section
    }
}

extension MovieDetailsViewController: MovieListCellDelegate {
    func handleButtonPress() {
        self.showAlert(title: Constants.MovieList.bookButtonPressedAlertTitle, message: Constants.MovieList.bookButtonPressedAlertMsg, primaryActionTitle: Constants.MovieList.bookButtonPressedAlertActionTitle, primaryActionhandler: nil)
    }
}
