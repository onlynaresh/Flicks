//
//  MovieDetailController.swift
//  MoviesApp
//
//  Created by Yerneni, Naresh on 3/31/17.
//  Copyright © 2017 Yerneni, Naresh. All rights reserved.
//

import UIKit

class MovieDetailController: UIViewController {

    @IBOutlet weak var movieDetailImage: UIImageView!
   
    @IBOutlet weak var movieDetailOverview: UILabel!
    @IBOutlet weak var movieDetailTitle: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var movie:NSDictionary!

    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: (scrollView.frame.size.height + (infoView.frame.origin.y - infoView.frame.size.height)))
        
        movieDetailTitle.text = movie["title"] as? String
        movieDetailOverview.text = movie["overview"] as? String
        
        movieDetailOverview.sizeToFit()
        
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "https://image.tmdb.org/t/p/w500"
            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            movieDetailImage.setImageWith(posterUrl! as URL)
        }
        else {
            
            movieDetailImage.image = nil
        }
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
