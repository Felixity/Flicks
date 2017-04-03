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
    private static let releaseDateKey = "release_date"
    private static let rateKey = "vote_average"
    
    static let resultsKey = "results"
    
    private static let baseURL = "https://image.tmdb.org/t/p/w500"
    private static let lowResolutionBaseURL = "https://image.tmdb.org/t/p/w45"
    private static let highResolutionBaseURL = "https://image.tmdb.org/t/p/original"
    
    var title: String {
        return json[Movie.titleKey].stringValue
    }
    
    var overview: String {
        return json[Movie.overviewKey].stringValue
    }
    
    var imageURL: URL? {
        return URL(string: Movie.baseURL + json[Movie.posterKey].stringValue)
    }
    
    var smallImageURL: URL? {
        return URL(string: Movie.lowResolutionBaseURL + json[Movie.posterKey].stringValue)
    }

    var largeImageURL: URL? {
        return URL(string: Movie.highResolutionBaseURL + json[Movie.posterKey].stringValue)
    }
    
    var releaseDate: String {
        let stringDate = json[Movie.releaseDateKey].stringValue
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-DD"
        let date = formatter.date(from: stringDate) ?? Date()
        formatter.dateFormat = "MMM dd, YYYY"
        return formatter.string(from: date)
    }
    
    var rate: String {
        let movieRate = json[Movie.rateKey].float
        return movieRate?.description ?? ""
    }
    
    private let json: JSON
    
    init(json: JSON) {
        self.json = json
    }
}
