//
//  MovieViewController.swift
//  Flicks
//
//  Created by Laura on 3/29/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    var movies: [Movie] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Request.fetchMovies(endPoint: "now_playing", successCallBack: onMoviesReceived, errorCallBack: nil)
    }

    private func onMoviesReceived(moviesCollection: [Movie]){
        movies = moviesCollection
        tableView.reloadData()
    }
    
    private func errorHandler(error: Error) {
        print(error.localizedDescription)
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
}
