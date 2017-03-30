//
//  Movie.swift
//  Flicks
//
//  Created by Laura on 3/29/17.
//  Copyright © 2017 Laura. All rights reserved.
//

import Foundation
import SwiftyJSON

class Movie {
    
    private static let overviewKey = "overview"
    private static let titleKey = "title"
    private static let posterKey = "poster_path"
    
    static let resultsKey = "results"
    
    private static let baseURL = "https://image.tmdb.org/t/p/w500"
    
    var title: String {
        return json[Movie.titleKey].stringValue
    }
    
    var overview: String {
        return json[Movie.overviewKey].stringValue
    }
    
    var imageURL: URL {
        return URL(string: Movie.baseURL + json[Movie.posterKey].stringValue)!
    }
    
    private let json: JSON
    
    init(json: JSON) {
        self.json = json
    }
}
