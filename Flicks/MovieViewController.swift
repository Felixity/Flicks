//
//  MovieViewController.swift
//  Flicks
//
//  Created by Laura on 3/29/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit
import JGProgressHUD

class MovieViewController: UIViewController {

    var endPoint: String?
    
    fileprivate var movies: [Movie] = []
    fileprivate var filteredMovies: [Movie] = []
    fileprivate var isSearchActive = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorMessageView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let progressHUD = JGProgressHUD.init(style: .light)
    private let refreshControl = UIRefreshControl()
    private let search = UISearchBar()
    
    lazy var errorHandler: ((Error?) -> ())? = {
        (error) in
        if let error = error {
            self.errorMessageLabel.text = error.localizedDescription
            self.errorMessageView.isHidden = false
            
            self.refreshControl.endRefreshing()
            self.progressHUD?.dismiss()            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = false
        collectionView.isHidden = true
        
        setupSearchBar()
        setupErrorMessage()
        setupProgressHUD()
        setupRefreshControl()
        
        customizeNavigationBar()
        
        tableView.separatorColor = .black
        tableView.backgroundColor = UIColor.tableViewColor
        
        MovieAPI.fetchMovies(endPoint!, successCallBack: onMoviesReceived, errorCallBack: errorHandler)
    }

    private func setupSearchBar() {
        search.sizeToFit()
        search.placeholder = "Search"
        navigationItem.titleView = search
        search.delegate = self
        search.tintColor = UIColor.black
    }
    
    private func setupErrorMessage() {
        errorMessageView.isHidden = true
    }
    
    private func setupProgressHUD() {
        progressHUD?.textLabel.text = "Loading..."
        progressHUD?.show(in: tableView)
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    private func onMoviesReceived(moviesCollection: [Movie]){
        movies = moviesCollection
        filteredMovies = movies
        
        errorMessageLabel.text = nil
        errorMessageView.isHidden = true
        
        progressHUD?.dismiss()
        
        refreshControl.endRefreshing()
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    @objc private func refreshControlAction() {
        MovieAPI.fetchMovies(endPoint!, successCallBack: onMoviesReceived, errorCallBack: errorHandler)
    }
    
    private func customizeNavigationBar() {
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.barTintColor = UIColor.barColor
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DetailViewController {
            if segue.identifier == "showDetails" {
                let index = tableView.indexPath(for: sender as! MovieTableViewCell)
                destinationVC.movie = filteredMovies[(index?.row)!]
            }
            else if segue.identifier == "collectionShowDetails"{
                let index = collectionView.indexPath(for: sender as! UICollectionViewCell)
                destinationVC.movie = filteredMovies[(index?.row)!]
            }
        }
    }
    
    @IBAction func onSegmentedControlPress(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // display list view
            tableView.isHidden = false
            collectionView.isHidden = true
        }
        else {
            // display grid view
            collectionView.isHidden = false
            tableView.isHidden = true
        }
    }    
}

extension MovieViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableCell", for: indexPath) as! MovieTableViewCell
        cell.movie = filteredMovies[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.barColor
        tableView.cellForRow(at: indexPath)?.selectedBackgroundView = backgroundView
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let backgroundColor = UIColor.tableViewColor
        cell.contentView.backgroundColor = backgroundColor
        cell.tintColor = UIColor.tableViewColor
        tableView.separatorColor = UIColor.white
        for item in cell.subviews {
            if (item as? UIButton) != nil {
                item.superview?.backgroundColor = UIColor.tableViewColor
                item.tintColor = .black
            }
        }
    }
}

extension MovieViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
        isSearchActive = false
        filteredMovies = movies
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearchActive = searchText != ""
        filteredMovies = isSearchActive ? movies.filter{$0.title.localizedCaseInsensitiveContains(searchText)} : movies
        tableView.reloadData()
        collectionView.reloadData()
    }
}

extension MovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! MovieCollectionViewCell
        cell.movie = filteredMovies[indexPath.row]
        return cell
    }
}
