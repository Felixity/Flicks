//
//  DetailViewController.swift
//  Flicks
//
//  Created by Laura on 3/29/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: Movie? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setScrollViewContentSizeForDetailLabel()
    }
    
    private func setScrollViewContentSizeForDetailLabel() {
        let contentWidth = scrollView.bounds.width
        scrollView.contentSize = CGSize(width: contentWidth, height: detailView.frame.origin.y + detailView.frame.size.height)
    }
    
    private func updateUI() {
        if viewIfLoaded == nil {
            return
        }
        if let movie = movie {
            // Set the title of the Detail ViewController
            self.title = movie.title
            
            titleLabel.text = movie.title
            releaseDateLabel.text = movie.releaseDate
            rateLabel.text = movie.rate
            overviewLabel.text = movie.overview
            
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: movie.imageURL) {
                    DispatchQueue.main.async {
                    self.posterImage.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
