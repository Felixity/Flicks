//
//  MovieTableViewCell.swift
//  Flicks
//
//  Created by Laura on 3/29/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!

    var movie: Movie? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        // reset any existing movie information
        titleLabel.text = nil
        overviewLabel.text = nil
        posterImageView.image = nil
        
        // load new movies from The Movie Database
        if let movie = self.movie {
            titleLabel.text = movie.title
            overviewLabel.text = movie.overview
            
            print(movie.imageURL)
            DispatchQueue.global(qos: .userInitiated).async {
                
                if let imageData = try? Data(contentsOf: movie.imageURL) {
                    DispatchQueue.main.async {
                        self.posterImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
