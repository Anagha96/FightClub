//
//  MovieListViewController.swift
//  FightClub
//
//  Created by Anagha Wadkar on 23/04/21.
//

import Foundation
import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel = MovieListViewModel()
    let searchController = UISearchController(searchResultsController: nil)
    

    var isFiltering: Bool {
      return searchController.isActive
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
    }
    
    func setup()  {
        /// Collection View Setup
        collectionView.register(UINib(nibName: "MovieCell", bundle: Bundle(for: MovieDetailsViewController.self)), forCellWithReuseIdentifier: "movieCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
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
                DispatchQueue.main.async {
                    self.viewModel.movieList.bind { [weak self](_) in
                        self?.collectionView.reloadData()
                    }
                    self.viewModel.filteredMovieList.bind { [weak self](_) in
                        self?.collectionView.reloadData()
                    }
                }
            } else {
                //TODO: Handle Exceptions and errors
            }
        }
    }
    
    /*
     Function to prepare segue to move to the movie detail screen for the selected movie
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let vc = segue.destination as? MovieDetailsViewController {
                vc.selectedMovie = viewModel.selectedMovie
            }
        }
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
        cell.contentView.layer.cornerRadius = 8.0
        cell.configure()
        return cell
    }
}

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFiltering {
            viewModel.selectedMovie = viewModel.filteredMovieList.value[indexPath.row].id.value
            performSegue(withIdentifier: "showDetail", sender: self)
        } else {
            viewModel.selectedMovie = viewModel.movieList.value[indexPath.row].id.value
            performSegue(withIdentifier: "showDetail", sender: self)
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
