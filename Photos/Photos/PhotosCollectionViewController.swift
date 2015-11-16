//
//  PhotosCollectionViewController.swift
//  Photos
//
//  Created by Gene Yoo on 11/3/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let api = InstagramAPI()
        api.loadPhotos(didLoadPhotos)
        // FILL ME IN
        let l = UICollectionViewFlowLayout()
        let itemWidth = (view.bounds.size.width - 2) / 3
        l.itemSize = CGSize(width: itemWidth, height: itemWidth)
        l.minimumInteritemSpacing = 1.0
        l.minimumLineSpacing = 1.0
        l.footerReferenceSize = CGSize(width: collectionView!.bounds.size.width, height: 100.0)
        collectionView!.collectionViewLayout = l
        collectionView!.registerClass(PhotoCell.classForCoder(), forCellWithReuseIdentifier: "PhotoCollectionCell")
    }

    /* 
     * IMPLEMENT ANY COLLECTION VIEW DELEGATE METHODS YOU FIND NECESSARY
     * Examples include cellForItemAtIndexPath, numberOfSections, etc.
     */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailed = segue.destinationViewController as! DetailedView
        detailed.pic = sender as! Photo
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("detailedView", sender: photos[indexPath.row])
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let pic = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionCell", forIndexPath: indexPath) as! PhotoCell
        loadImageForCell(photos[indexPath.row], imageView: pic.pic)
        return pic
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    /* Creates a session from a photo's url to download data to instantiate a UIImage. 
       It then sets this as the imageView's image. */
    func loadImageForCell(photo: Photo, imageView: UIImageView) {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: photo.url)!, completionHandler: {
            (data, response, error) -> Void in
            if error == nil { imageView.image = UIImage(data: data!) }
        }).resume()
    }
    
    /* Completion handler for API call. DO NOT CHANGE */
    func didLoadPhotos(photos: [Photo]) {
        self.photos = photos
        self.collectionView!.reloadData()
    }    
}

class PhotoCell: UICollectionViewCell {
    let pic = UIImageView()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        pic.frame = bounds
        addSubview(pic)
    }
}

class DetailedView: UIViewController {
    var pic: Photo!
    @IBOutlet var picView: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var likes: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImageForCell(self.pic, imageView: picView)
        username.text = "Posted by " + self.pic.username + ":"
        likes.text = "\(self.pic.likes) people liked this"
        date.text = self.pic.date
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImageForCell(photo: Photo, imageView: UIImageView) {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: pic.url)!, completionHandler: {
            (data, response, error) -> Void in
            if error == nil { imageView.image = UIImage(data: data!) }
        }).resume()
    }

    @IBAction func pressHeart(sender: AnyObject) {
        likeButton.selected = !likeButton.selected
    }
}
