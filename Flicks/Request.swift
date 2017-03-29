//
//  Request.swift
//  Flicks
//
//  Created by Laura on 3/29/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import Foundation
import SwiftyJSON

class Request {
    private init() {} // this prevents others from using the default initializer of this class

    static var endPoint: String?
    
    class func fetchMovies(successCallBack: @escaping ([Movie]) -> (), errorCallBack: ((Error) -> ())?) {
        var movieCollection: [Movie] = []
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(Request.endPoint!)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                errorCallBack!(error)
                print(error.localizedDescription)
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
}
