//
//  MoviesViewController.swift
//  MoviesApp
//
//  Created by Yerneni, Naresh on 3/31/17.
//  Copyright © 2017 Yerneni, Naresh. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

    @IBOutlet weak var movieTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
   
    
    @IBOutlet weak var errorView: UIView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var movies:[NSDictionary]?
    
    var endpoint:String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.dataSource=self
        movieTableView.delegate=self
        
        searchBar.delegate=self
        hideErrorView()

        networkRequest()
        
        let refreshControl = UIRefreshControl()
         refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        movieTableView.insertSubview(refreshControl, at: 0)
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        networkRequest()
            }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        movies = searchText.isEmpty ? movies : movies?.filter {
            String(describing: $0["title"]).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        movieTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
        networkRequest()
        movieTableView.reloadData()
    }
    
    func networkRequest()
    {
        var httpResponse:HTTPURLResponse?=nil
        let buildReuestUrl = "https://api.themoviedb.org/3/movie/\(endpoint as String)?api_key=6adac74ffbb3c0fc636a7c5e51630b21"
        let requestUrl = URL(string:buildReuestUrl)
        let request = URLRequest(url: requestUrl!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let error = error {
                     print("\(error)")
                    self.showErrorView()
                }
               else  if let data = data {
                     MBProgressHUD.hide(for: self.view, animated: true)
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                    self.movies=responseDictionary["results"] as? [NSDictionary]
                        self.movieTableView.reloadData()
                    }
                }
                
        });

        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
        
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "MovieCell",for:indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        
        let title=movie["title"] as! String
        
        let overview=movie["overview"] as! String
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = NSURL(string: baseUrl + posterPath) as! URL
            let posterRequest = NSURLRequest(url: posterUrl)
            cell.movieImage.setImageWith(
                posterRequest as URLRequest,
                placeholderImage: nil,
                success: { (posterRequest, posterResponse, poster) -> Void in
                    if posterResponse != nil {
                        cell.movieImage.alpha = 0.0
                        cell.movieImage.image = poster
                        UIView.animate(withDuration: 1.0, animations: { () -> Void in
                            cell.movieImage.alpha = 1.0
                        })
                    } else {
                        cell.movieImage.image = poster
                    }
            })
        }
        cell.movieTitle.text=title
        cell.movieOverview.text=overview
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies=movies {
            return movies.count
        }else {
            return 0;
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movieDetailController = segue.destination as! MovieDetailController
        
        let indexPath = movieTableView.indexPath(for: sender as! UITableViewCell)!
        let movie = movies![indexPath.row]
        
        movieDetailController.movie = movie
        
        
    }
    
    
    private func hideErrorView(){
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.errorView.isHidden = true
            self.errorView.frame.size.height = 0
        }, completion: nil)
    }

    
    private func showErrorView(){
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            MBProgressHUD.hide(for: self.view, animated: true)

            self.errorView.isHidden = false
            self.errorView.backgroundColor = UIColor.clear
        }, completion: nil)
        
    }
 

}
