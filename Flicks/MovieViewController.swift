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
    var endPoint: String?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorMessageView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    private let progressHUD = JGProgressHUD.init(style: .light)
    private let refreshControl = UIRefreshControl()
    
    lazy var errorHandler: ((Error) -> ())? = {
        (error) in
        self.errorMessageLabel.text = error.localizedDescription
        self.errorMessageView.isHidden = false
        
        print(error.localizedDescription)
        
        self.refreshControl.endRefreshing()
        self.progressHUD?.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessageView.isHidden = true
        
        progressHUD?.textLabel.text = "Loading..."
        progressHUD?.show(in: tableView)
        
        Request.fetchMovies(endPoint!, successCallBack: onMoviesReceived, errorCallBack: errorHandler)
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }

    private func onMoviesReceived(moviesCollection: [Movie]){
        movies = moviesCollection
        
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
            destinationVC.movie = movies[(index?.row)!]
        }
    }
}

extension MovieViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableCell", for: indexPath) as! MovieTableViewCell
        cell.movie = movies[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
