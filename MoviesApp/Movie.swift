//
//  Movie.swift
//  MoviesApp
//
//  Created by Yerneni, Naresh on 4/3/17.
//  Copyright © 2017 Yerneni, Naresh. All rights reserved.
//

import UIKit

class Movie: NSObject {
    var id:Int!
    var title: String!
    var overview:String!
 
    var rating:Double!
    
    var posterPath:String?
    var posterPathLowResolution:String?
    var posterPathHighResolution:String?
    
    init(dict:NSDictionary) {
        
        super.init()
        
        if(dict.count > 0){
            id = dict["id"] as! Int
            title = dict["title"] as! String
            overview = dict["overview"] as! String
            rating = dict["vote_average"] as? Double
            
            if let poster = dict["poster_path"] as? String {
                let baseUrl = "https://image.tmdb.org/t/p/w500"
                posterPath =   baseUrl + poster
                posterPathLowResolution = "https://image.tmdb.org/t/p/w45" + poster
                posterPathHighResolution = "https://image.tmdb.org/t/p/original" + poster
            }
            else{
                posterPath = nil
            }
        }
    }



}
