//
//  MovieViewController.swift
//  RottenTomatos
//
//  Created by John YS on 4/13/15.
//  Copyright (c) 2015 Silicon Valley Insight. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UITextView!
    
    var movieTitleString: String = ""
    var movieDescriptionString: String = ""
    var imageUrlString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Make the Request
        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: imageUrlString)!) as NSURLRequest!
        
        // Show the HUD on start of network request
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        movieImage.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) -> Void in
            // Hide the HUD on completion of network request
            self.movieImage.image = image
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }, failure: { (request, response, error) -> Void in
            // Hide the HUD on completion of network request
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
        
        movieTitle.text = movieTitleString
        movieDescription.text = movieDescriptionString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
