//
//  DetailViewController.swift
//  Flicks
//
//  Created by Laura on 3/29/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import UIKit
import AFNetworking

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
        customizeNavigationBar()
        updateUI()
        setScrollViewContentSizeForDetailLabel()
    }
    
    private func setScrollViewContentSizeForDetailLabel() {
        let contentWidth = scrollView.bounds.width
        scrollView.contentSize = CGSize(width: contentWidth, height: detailView.frame.origin.y + detailView.frame.size.height)
    }
    
    private func customizeNavigationBar() {
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.tintColor = .black
            
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.lightGray
            shadow.shadowOffset = CGSize(width: 2, height: 2)
            shadow.shadowBlurRadius = 4
            let attributeColor = UIColor.black
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: attributeColor,NSShadowAttributeName: shadow]
        }
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
            overviewLabel.sizeToFit()
            
            detailView.frame.size.height = overviewLabel.frame.origin.y + overviewLabel.frame.size.height
            
            MovieAPI.load(movie.smallImageURL, followedBy: movie.largeImageURL, into: posterImage)
        }
    }
}
