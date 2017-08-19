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
        
        setupSearchBar()
        setupErrorMessage()
        setupProgressHUD()
        setupRefreshControl()
        
        customizeNavigationBar()
        
        tableView.separatorColor = .black
        tableView.backgroundColor = UIColor(red: 252/255, green: 193/255, blue: 0, alpha: 1)
        
        MovieAPI.fetchMovies(endPoint!, successCallBack: onMoviesReceived, errorCallBack: errorHandler)

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
        MovieAPI.fetchMovies(endPoint!, successCallBack: onMoviesReceived, errorCallBack: errorHandler)
    }
    
    private func customizeNavigationBar() {
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.barTintColor = UIColor(red: 252/255, green: 193/255, blue: 0, alpha: 1)
        }
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
        let backgroundView = UIView()
        backgroundView.backgroundColor = .lightGray
        tableView.cellForRow(at: indexPath)?.selectedBackgroundView = backgroundView
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let backgroundColor = UIColor(red: 252/255, green: 193/255, blue: 0, alpha: 1)
        cell.contentView.backgroundColor = backgroundColor
        cell.tintColor = UIColor(red: 252/255, green: 193/255, blue: 0, alpha: 1)
        for item in cell.subviews {
            if (item as? UIButton) != nil {
                item.superview?.backgroundColor = UIColor(red: 252/255, green: 193/255, blue: 0, alpha: 1)
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
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearchActive = searchText != ""
        filteredMovies = isSearchActive ? movies.filter{$0.title.localizedCaseInsensitiveContains(searchText)} : movies
        tableView.reloadData()
    }

}
