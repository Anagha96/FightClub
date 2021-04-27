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
    
    /*
     Function to call view model to fetch the movie list on pull to refresh
     */
    @objc func refresh(_ sender: AnyObject) {
        fetchData()
    }
    
    
    func setup()  {
        /// Collection View Setup
        collectionView.register(UINib(nibName: Constants.MovieList.movieListCellNibName, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.MovieList.movieListCellIdentifier)
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
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
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
            
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
            
        }
        
        return layout
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return viewModel.filteredMovieList.value.count
        } else {
            return viewModel.movieList.value.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    }
}

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFiltering {
            viewModel.selectedMovie = viewModel.filteredMovieList.value[indexPath.row].id.value
            performSegue(withIdentifier: Constants.MovieList.segueId, sender: self)
        } else {
            viewModel.selectedMovie = viewModel.movieList.value[indexPath.row].id.value
            performSegue(withIdentifier: Constants.MovieList.segueId, sender: self)
        }
        
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
