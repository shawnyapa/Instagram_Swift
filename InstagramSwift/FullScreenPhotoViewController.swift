//
//  FullScreenPhotoViewController.swift
//  InstagramSwift
//
//  Created by Shawn Yapa on 2/12/15.
//  Copyright (c) 2015 Shawn Yapa. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var photoView: UIImageView?
    var photoImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        photoView?.image = photoImage!
        scrollView?.contentSize = photoView!.image!.size
        // Do any additional setup after loading the view.
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return photoView
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
