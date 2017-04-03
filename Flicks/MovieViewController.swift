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

    var movies: [Movie] = []
    var filteredMovies: [Movie] = []
    var endPoint: String?
    var isSearchActive = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorMessageView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    private let progressHUD = JGProgressHUD.init(style: .light)
    private let refreshControl = UIRefreshControl()
    private let search = UISearchBar()
    
    lazy var errorHandler: ((Error) -> ())? = {
        (error) in
        self.errorMessageLabel.text = error.localizedDescription
        self.errorMessageView.isHidden = false
        
        self.refreshControl.endRefreshing()
        self.progressHUD?.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupErrorMessage()
        setupProgressHUD()
        setupRefreshControl()
        
        Request.fetchMovies(endPoint!, successCallBack: onMoviesReceived, errorCallBack: errorHandler)

    }

    private func setupSearchBar() {
        search.sizeToFit()
        search.placeholder = "Search"
        navigationItem.titleView = search
        search.delegate = self
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
    }
    
    @objc private func refreshControlAction() {
        Request.fetchMovies(endPoint!, successCallBack: onMoviesReceived, errorCallBack: errorHandler)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails", let destinationVC = segue.destination as? DetailViewController {
            let index = tableView.indexPath(for: sender as! MovieTableViewCell)
            destinationVC.movie = filteredMovies[(index?.row)!]
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MovieViewController: UISearchBarDelegate {
    
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
        isSearchActive = false
        filteredMovies = movies
        tableView.reloadData()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearchActive = searchText != ""
        filteredMovies = isSearchActive ? movies.filter{$0.title.localizedCaseInsensitiveContains(searchText)} : movies
        tableView.reloadData()
    }

}
