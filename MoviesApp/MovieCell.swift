//
//  MovieCell.swift
//  MoviesApp
//
//  Created by Yerneni, Naresh on 3/31/17.
//  Copyright © 2017 Yerneni, Naresh. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieOverview: UILabel!

    @IBOutlet weak var movieImage: UIImageView!
    
    var movie:Movie! {
        didSet {
            movieTitle.text = movie.title
            movieOverview.text=movie.overview
            if  movie.posterPath != nil {
                let imageUrl = NSURL(string: movie.posterPath!)
                movieImage.setImageWith(imageUrl as! URL)
            }

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
