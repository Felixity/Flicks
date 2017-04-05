//
//  MovieTableViewCell.swift
//  Flicks
//
//  Created by Laura on 3/29/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!

    var movie: Movie? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        // reset any existing movie information
        movieTitleLabel.text = nil
        overviewLabel.text = nil
        posterImageView.image = nil
        
        // load new movies from The Movie Database
        if let movie = self.movie {
            movieTitleLabel.text = movie.title
            overviewLabel.text = movie.overview
            overviewLabel.sizeToFit()
            Request.load(movie.imageURL, followedBy: nil, into: posterImageView)
        }
    }
}
