//
//  MovieCollectionViewCell.swift
//  Flicks
//
//  Created by Laura on 8/20/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    var movie: Movie? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        // reset any existing movie information
        posterImageView.image = nil
        movieTitle.text = nil
        
        // load new movies from The Movie Database
        if let movie = self.movie {
            MovieAPI.load(movie.imageURL, followedBy: nil, into: posterImageView)
            movieTitle.text = movie.title
            movieTitle.sizeToFit()
            movieTitle.adjustsFontSizeToFitWidth = true
        }
    }
}
