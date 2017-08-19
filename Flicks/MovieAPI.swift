//
//  MovieAPI.swift
//  Flicks
//
//  Created by Laura on 3/29/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import Foundation
import SwiftyJSON

class MovieAPI {
    static private var _instance: MovieAPI?
    static var sharedInstance: MovieAPI? {
        get {
            if _instance == nil {
                _instance = MovieAPI()
            }
            return _instance
        }
    }
    
    class func fetchMovies(_ endPoint: String, successCallBack: @escaping ([Movie]) -> (), errorCallBack: ((Error?) -> ())?) {
        var movieCollection: [Movie] = []
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                errorCallBack?(error)
            }
            else if let data = data {
                let jsonResponse = JSON(data: data)
                for json in jsonResponse[Movie.resultsKey].arrayValue {
                    let movie = Movie(json: json)
                    movieCollection.append(movie)
                }
                successCallBack(movieCollection)
            }
        })
        task.resume()
    }
    
    class func load(_ smallImageURL: URL?, followedBy largeImageURL: URL?, into imageView: UIImageView) {
        if let firstURL = smallImageURL {
            let smallImageRequest = URLRequest(url: firstURL)
            
            imageView.setImageWith(smallImageRequest, placeholderImage: nil, success: {(smallImageRequest, smallImageResponse, smallImage) in
                
                imageView.alpha = 0
                imageView.image = smallImage
                
                UIView.animate(withDuration: 0.3, animations: {() in
                    
                    imageView.alpha = 1
                    
                }, completion: {(success) in
                    
                    if let secondURL = largeImageURL {
                        let largeImageRequest = URLRequest(url: secondURL)
                        
                        imageView.setImageWith(largeImageRequest, placeholderImage: smallImage, success: {(largeImageRequest, largeImageResponse, largeImage) in
                            
                            imageView.image = largeImage
                            
                        }, failure: {(largeImageRequest, largeImageResponse, largeImageError) in
                            print("Error while loading the large image!")
                        })
                    }
                })
            }, failure: {(smallImageRequest, smallImageResponse, smallImageError) in
                print("Error while loading the small image!")
            })
        }
    }
}

