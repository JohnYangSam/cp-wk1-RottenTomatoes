//
//  MoviesViewController.swift
//  RottenTomatos
//
//  Created by John YS on 4/13/15.
//  Copyright (c) 2015 Silicon Valley Insight. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorAlertView: UIView!
    
    /* Variable dictionary of movies. We use NSDictionary for additional funcationality. */
    var movies: [NSDictionary] = []
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Add UIRefreshControl as a subview of the UITableView - using the lowest index so that it appears behind everything
        refreshControl = UIRefreshControl()
        // 'onRefresh' will be the function called
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        /* Loading the information from the Rotten Tomatoes API */
        let apiKey = "nxu96vjy2huu9g3vd3kjfd2g"
        let url_route = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=\(apiKey)"
        
        var url = NSURL(string: url_route)!
        var request = NSURLRequest(URL: url)
       
        // Show the HUD on start of network request
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            println("error: \(error)")
            
            if (error != nil) {
                self.networkErrorAlertView.hidden = false
            } else {
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
                
                // Set the movies
                self.movies = responseDictionary["movies"] as! [NSDictionary]
                
                // Update the table
                self.tableView.reloadData()
            }
            
            // Hide the HUD on completion of network request
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            // Testing
            println("response: \(self.movies)")
            
            
        }
        
        // Set tableView dataSource and deleagate
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func onRefresh() {
        /* Loading the information from the Rotten Tomatoes API */
        let apiKey = "nxu96vjy2huu9g3vd3kjfd2g"
        let url_route = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=\(apiKey)"
        
        var url = NSURL(string: url_route)!
        var request = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            println("error: \(error)")
            
            if (error != nil) {
                self.networkErrorAlertView.hidden = false
            } else {
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
                
                // Set the movies
                self.movies = responseDictionary["movies"] as! [NSDictionary]
                
                // Update the table
                self.tableView.reloadData()
            }
            
            // Finish refreshing when the callback is done. You need to use self because we are inside of a closure
            self.refreshControl.endRefreshing()
            
            // Testing
            println("response: \(self.movies)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieViewCell") as! MovieViewCell
        
        // TODO: Doublecheck index path
        var movie = movies[indexPath.row]
        
        // Unload strings from JSON response
        var movieThumbNailImage = movie.valueForKeyPath("posters.thumbnail") as! String
        var movieDetailImage = movie.valueForKeyPath("posters.detailed") as! String
        
        // Fix to get movie poster detail
        var range = movieDetailImage.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            movieDetailImage = movieDetailImage.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        
        var title = movie.valueForKeyPath("title") as! String
        var description = movie.valueForKeyPath("synopsis") as! String
        
        // Set the cell
        cell.movieImage.setImageWithURL(NSURL(string: movieThumbNailImage))
        cell.movieTitle.text = title
        cell.movieDescription.text = description
        
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.destinationViewController.isKindOfClass(MovieViewController)) {
            var movieViewController: MovieViewController = segue.destinationViewController as! MovieViewController
            
            var indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            var movie = movies[indexPath.row]
            var movieDetailImage = movie.valueForKeyPath("posters.original") as! String
            
            // Fix to get movie poster detail
            var range = movieDetailImage.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
            if let range = range {
                movieDetailImage = movieDetailImage.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
            }
            
            var title = movie.valueForKeyPath("title") as! String
            var description = movie.valueForKeyPath("synopsis") as! String
            
            movieViewController.imageUrlString = movieDetailImage
            movieViewController.movieTitleString = title
            movieViewController.movieDescriptionString = description
           
        }
    }

}
