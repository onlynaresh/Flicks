//
//  MovieDetailController.swift
//  MoviesApp
//
//  Created by Yerneni, Naresh on 3/31/17.
//  Copyright © 2017 Yerneni, Naresh. All rights reserved.
//

import UIKit

class MovieDetailController: UIViewController ,UIGestureRecognizerDelegate{

    @IBOutlet weak var movieDetailImage: UIImageView!
   
    @IBOutlet weak var movieDetailOverview: UILabel!
    @IBOutlet weak var movieDetailTitle: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var movie:Movie!

    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: (scrollView.frame.size.height + (infoView.frame.origin.y - infoView.frame.size.height)))
        
        let title = movie.title
        let overview = movie.overview
        
        movieDetailTitle.text = title
        movieDetailTitle.sizeToFit()
        movieDetailOverview.text = overview
        movieDetailOverview.sizeToFit()
        
        movieDetailImage.contentMode = .scaleAspectFit
       
        
        if  movie.posterPath != nil {
            posterlowHighRes()
        }
        
        navigationItem.title = title
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: Selector(("toggleDetailsView:")))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        swipeUp.delegate = self
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: Selector(("toggleDetailsView:")))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        swipeDown.delegate = self
        self.view.addGestureRecognizer(swipeDown)
        

        
    }
    
    
    func posterlowHighRes() {
        let smallImageRequest = NSURLRequest(url: NSURL(string: movie.posterPathLowResolution!)! as URL)
        let largeImageRequest = NSURLRequest(url: NSURL(string: movie.posterPathHighResolution!)! as URL)
        
        self.movieDetailImage.setImageWith(
            smallImageRequest as URLRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                
                              self.movieDetailImage.alpha = 0.0
                self.movieDetailImage.image = smallImage;
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    
                    self.movieDetailImage.alpha = 1.0
                    
                }, completion: { (sucess) -> Void in
                    
                    
                    self.movieDetailImage.setImageWith(
                        largeImageRequest as URLRequest,
                        placeholderImage: smallImage,
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            
                            self.movieDetailImage.image = largeImage;
                            
                    },
                        failure: { (request, response, error) -> Void in
                            
                    })
                })
        },
            failure: { (request, response, error) -> Void in
                        })
    }
    
    func toggleDetailsView(gesture: UIGestureRecognizer){
        let top:CGPoint = infoView.frame.origin
        let middle:CGPoint = CGPoint(x: infoView.frame.origin.x, y:(infoView.frame.size.height/2) as CGFloat)
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.up:
                
                UIView.animate(withDuration: 1.5, animations: {
                    self.infoView.frame.origin = top
                })
            case UISwipeGestureRecognizerDirection.down:
                
                UIView.animate(withDuration: 1.5, animations: {
                    self.infoView.frame.origin = middle
                })
            default:
                break
            }
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
