//
//  InstaDetailViewController.swift
//  InstagramSwift
//
//  Created by Shawn Yapa on 2/11/15.
//  Copyright (c) 2015 Shawn Yapa. All rights reserved.
//

import UIKit
import Alamofire

class InstaDetailViewController: UIViewController {
    
    var instaPhoto: InstaModel?
    @IBOutlet weak var name: UILabel?
    @IBOutlet weak var imageViewStandardResolution: UIImageView?
    @IBOutlet weak var caption: UITextView?
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Photo Detail"
        self.name?.text = instaPhoto?.name
        self.caption?.text = instaPhoto?.caption
        let imageURL: URLStringConvertible = instaPhoto!.urlStandardResolution
        Alamofire.request(.GET, imageURL).response() {
            (request, _, data, error) in
            if error == nil && data != nil {
                //let image = UIImage(data: data! as NSData)
                self.image = UIImage(data: data! as NSData)
                self.imageViewStandardResolution?.image = self.image
            }
        }
    }
    
    @IBAction func showFullPhotoWithZoom(sender: AnyObject) {
        
        self.performSegueWithIdentifier("showFullPhotoWithZoom", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showFullPhotoWithZoom" {
            var fullScreenPhotoVC: FullScreenPhotoViewController = segue.destinationViewController as FullScreenPhotoViewController
            fullScreenPhotoVC.photoImage = image
        }
    }
    

}
