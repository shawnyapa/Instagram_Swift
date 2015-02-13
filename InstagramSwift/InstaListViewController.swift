//
//  InstaListViewController.swift
//  InstagramSwift
//
//  Created by Shawn Yapa on 2/10/15.
//  Copyright (c) 2015 Shawn Yapa. All rights reserved.
//

import UIKit
import Alamofire

class InstaListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var instaList: UITableView?
    var refreshControl: UIRefreshControl?
    var instaArray = [InstaModel]()
    var placeholderImage: UIImage?
    var selectedPhoto: InstaModel?
    //var instagramUrlString = "https://api.instagram.com/v1/media/popular?client_id=2c20e447eeed401ea9380d62d8f3b6cf"
    var instagramUrlString: URLStringConvertible = "https://api.instagram.com/v1/users/22836073/media/recent/?client_id=2c20e447eeed401ea9380d62d8f3b6cf" // Miami Heat UserId includes nextUrl Pagination
    var nextUrl: String?
    var fetchingInProgress=false
    var selectedInstaPhoto: InstaModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Popular Photos"
        refreshControl = UIRefreshControl.init()
        refreshControl?.addTarget(self, action:"onRefresh", forControlEvents:UIControlEvents.ValueChanged)
        self.instaList?.insertSubview(self.refreshControl!, atIndex: 0)
        let placeHolderImageString = "placeholderImage"
        placeholderImage?.imageAsset.valueForKey(placeHolderImageString)
        getInstagramPhotosWithAlamofire(instagramUrlString, addPhotos: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onRefresh() {
        //println("Refreshing")
        getInstagramPhotosWithAlamofire(instagramUrlString, addPhotos: false)
    }
    
    func getInstagramPhotosWithAlamofire(instagramUrl: URLStringConvertible, addPhotos:Bool) {
        if fetchingInProgress == false {
        fetchingInProgress = true
        Alamofire.request(.GET, instagramUrl)
            .responseJSON { (request, response, JSON, error) in
                //println(request)
                //println(response)
                //println(JSON)
                //println(error)
                if error == nil && response != nil {
                    let pagination: NSDictionary = (JSON!.valueForKey("pagination") as NSDictionary)
                    self.nextUrl = (pagination.valueForKey("next_url") as String)
                    let photos:[NSDictionary] = (JSON!.valueForKey("data") as [NSDictionary])
                    var tempInstaArray = InstaModel.createInstaModels(photos) as [InstaModel]
                    if addPhotos {
                        self.instaArray += tempInstaArray
                        var arrayTest: InstaModel = self.instaArray[0]
                        self.instaList?.tableFooterView = nil
                    } else {
                        self.instaArray = tempInstaArray
                        self.refreshControl?.endRefreshing()
                    }
                    self.instaList?.reloadData()
                    self.fetchingInProgress = false
                } else {
                    self.refreshControl?.endRefreshing()
                    self.instaList?.tableFooterView = nil
                    self.fetchingInProgress = false
                    var alertview: UIAlertView = UIAlertView.init()
                    alertview.title = "Connection Error"
                    alertview.message = "Unable to connect and fetch Instagram Photos"
                    alertview.cancelButtonIndex = 0
                    alertview.show()
                }
        }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instaArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var instaCell:InstaListTableViewCell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as InstaListTableViewCell
        if (indexPath.row == instaArray.count-1) && (indexPath.row != 0) {
            // Fetch additional Instagram Photos & show Footer Activity View
            loadAdditionalInstagramPhotos()
        }
        var instaModel = self.instaArray[indexPath.row] as InstaModel
        instaCell.name?.text = instaModel.name
        instaCell.caption?.text = instaModel.caption
        
        let imageURL: URLStringConvertible = instaModel.urlThumbnail
        instaCell.thumbnailImage?.image = placeholderImage;
        instaCell.request = Alamofire.request(.GET, imageURL).response() {
            (request, _, data, error) in
            if error == nil && data != nil {
                let image = UIImage(data: data! as NSData)
                if request.URLString == instaCell.request?.request.URLString {
                    instaModel.thumbnailImage = image
                    dispatch_async(dispatch_get_main_queue(), {
                        // DO SOMETHING ON THE MAINTHREAD
                        //instaCell.thumbnailImage?.image = image
                        self.setCellImage(instaCell, withInstaModel: instaModel)
                    })
                }
            }
        }
        return instaCell
    }
    
    func setCellImage(cell: InstaListTableViewCell, withInstaModel instaModel:InstaModel) {
        cell.thumbnailImage?.image = instaModel.thumbnailImage
    }

    func loadAdditionalInstagramPhotos() {
        showFooterLoadingView()
        
        getInstagramPhotosWithAlamofire(nextUrl!, addPhotos: true)
    }
    
    func showFooterLoadingView() {
        let frame: CGRect = CGRectMake(0, 0, 320, 50)
        var tableFooterView: UIView = UIView.init()
        tableFooterView.frame = frame
        var loadingView: UIActivityIndicatorView = UIActivityIndicatorView.init()
        loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingView.startAnimating()
        loadingView.center = tableFooterView.center
        tableFooterView.addSubview(loadingView)
        self.instaList?.tableFooterView = tableFooterView
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedInstaPhoto = self.instaArray[indexPath.row] as InstaModel
        self.performSegueWithIdentifier("ShowInstagramPhotoDetail", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowInstagramPhotoDetail" {
            let instagramPhotoDetailVC = segue.destinationViewController as InstaDetailViewController
            instagramPhotoDetailVC.instaPhoto = selectedInstaPhoto
        }
    }
    

}
