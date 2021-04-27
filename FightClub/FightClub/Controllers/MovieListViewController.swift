//
//  MovieListViewController.swift
//  FightClub
//
//  Created by Anagha Wadkar on 23/04/21.
//

import Foundation
import UIKit

protocol MovieListCellDelegate: class {
    func handleButtonPress()
}

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel = MovieListViewModel()
    let searchController = UISearchController(searchResultsController: nil)
    var activityIndicator = UIActivityIndicatorView()
    var refreshControl = UIRefreshControl()
    
    enum Section: String, CaseIterable {
        case Movies = ""
        case RecentlySearched = "Recently Searched"
    }
    
    var sections: [Section] {
        if isFiltering && searchController.searchBar.text?.count == 0 {
            return [.RecentlySearched]
        } else {
            return [.Movies]
        }
    }
    
    var isFiltering: Bool {
        return searchController.isActive
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
        collectionView.addSubview(activityIndicator)
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.createRecentlySearchedViewCellModels()
    }
    
    /*
     Function to call view model to fetch the movie list on pull to refresh
     */
    @objc func refresh(_ sender: AnyObject) {
        fetchData()
    }
    
    
    func setup()  {
        /// Collection View Setup
        collectionView.register(UINib(nibName: Constants.MovieList.movieListCellNibName, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.MovieList.movieListCellIdentifier)
        collectionView.register(UINib(nibName: Constants.MovieList.recentSearchCellNibName, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.MovieList.recentSearchCellIdentifier)
        collectionView.register(UINib(nibName: Constants.MovieDetails.movieDetailsSectionNibName, bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.MovieDetails.movieDetailsSectionIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = generateLayout()
        
        ///Activity Indicator Configuration
        activityIndicator.center = view.center
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        
        /// Search Controller Setup
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func fetchData() {
        viewModel.fetchMovies { (error) in
            if error == nil {
                
                self.viewModel.movieList.bind { [weak self](_) in
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                }
                self.viewModel.filteredMovieList.bind { [weak self](_) in
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                }
                self.viewModel.recentlySearchedMovies.bind{ [weak self](_) in
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
                self.refreshControl.endRefreshing()
            }
        }
       
    }
    
    /*
     Function to prepare segue to move to the movie detail screen for the selected movie
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.MovieList.segueId {
            if let vc = segue.destination as? MovieDetailsViewController {
                vc.selectedMovie = viewModel.selectedMovie
            }
        }
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.MovieDetails.movieDetailsSectionIdentifier, for: indexPath) as? MovieDetailsSectionHeaderView else {
                return UICollectionReusableView()
            }
            if viewModel.recentlySearchedMovies.value.isEmpty {
                headerView.sectionHeader.text = "No Recent Searches"

            } else {
                headerView.sectionHeader.text = sections[indexPath.section].rawValue

            }
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .Movies:
            if isFiltering {
                return viewModel.filteredMovieList.value.count
            } else {
                return viewModel.movieList.value.count
            }
        case.RecentlySearched:
            return viewModel.recentlySearchedMovies.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .Movies:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.MovieList.movieListCellIdentifier, for: indexPath) as? MovieListCollectionViewCell else {
                return UICollectionViewCell()
            }
            if isFiltering {
                cell.viewModel = viewModel.filteredMovieList.value[indexPath.row]
            } else {
                cell.viewModel = viewModel.movieList.value[indexPath.row]
            }
            cell.delegate = self
            cell.contentView.layer.cornerRadius = 8.0
            cell.configure()
            return cell
        case .RecentlySearched:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.MovieList.recentSearchCellIdentifier, for: indexPath) as? RecentSearchCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = viewModel.recentlySearchedMovies.value[indexPath.row]
            cell.contentView.layer.cornerRadius = 8.0
            cell.configure()
            return cell
        }
        
    }
}

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFiltering {
            switch sections[indexPath.section] {
            case .Movies:
                viewModel.selectedMovie = viewModel.filteredMovieList.value[indexPath.row].id.value
                performSegue(withIdentifier: Constants.MovieList.segueId, sender: self)
                ///Save Recently Searched Movie ID to UserDefaults
                viewModel.saveToRecentlySearched(movieID: viewModel.selectedMovie)
            case . RecentlySearched:
                viewModel.selectedMovie = viewModel.recentlySearchedMovies.value[indexPath.row].id.value
                performSegue(withIdentifier: Constants.MovieList.segueId, sender: self)
            }
            
        } else {
            viewModel.selectedMovie = viewModel.movieList.value[indexPath.row].id.value
            performSegue(withIdentifier: Constants.MovieList.segueId, sender: self)
        }
        ///Haptic feedback on selecting a movie
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
}

extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if isFiltering {
            let searchBar =  searchController.searchBar
            viewModel.filterMovies(for: searchBar.text)
        }
    }
}

extension MovieListViewController: MovieListCellDelegate {
    func handleButtonPress() {
        self.showAlert(title: Constants.MovieList.bookButtonPressedAlertTitle, message: Constants.MovieList.bookButtonPressedAlertMsg, primaryActionTitle: Constants.MovieList.bookButtonPressedAlertActionTitle, primaryActionhandler: nil)
    }
}

extension MovieListViewController {
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self](sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            if let strongSelf = self {
                let sectionLayoutKind = strongSelf.sections[sectionIndex]
                switch (sectionLayoutKind) {
                case .Movies: return strongSelf.generateMoviesLayout()
                case .RecentlySearched:
                    return strongSelf.generateRecentSearchLayout()
                }
            } else {
                return nil
            }
            
        }
        
        return layout
    }
    
    func generateRecentSearchLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(5)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 5
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
            
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
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.49),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(380))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(5)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 5
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
            
        
            return section
    }
}
