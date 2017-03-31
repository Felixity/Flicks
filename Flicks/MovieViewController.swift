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
    
    @IBOutlet weak var tableView: UITableView!
    
    private let progressHUD = JGProgressHUD.init(style: .light)
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressHUD?.textLabel.text = "Loading..."
        progressHUD?.show(in: tableView)
        Request.fetchMovies(endPoint: "now_playing", successCallBack: onMoviesReceived, errorCallBack: nil)
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }

    private func onMoviesReceived(moviesCollection: [Movie]){
        movies = moviesCollection
        progressHUD?.dismiss()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    private func errorHandler(error: Error) {
        print(error.localizedDescription)
    }
    
    @objc private func refreshControlAction() {
        Request.fetchMovies(endPoint: "now_playing", successCallBack: onMoviesReceived, errorCallBack: nil)
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
