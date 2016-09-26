//
//  MediaListController.swift
//  MediaPlayer
//
//  Created by Amit Khoth on 8/11/16.
//  Copyright © 2016 samsung. All rights reserved.
//

import UIKit

private let reuseIdentifier = "mediaCell"
class MediaListController: UIViewController
{
    @IBOutlet var mediaCollection: UICollectionView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool)
    {
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()

    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        let sections:Int = 1
        return sections
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return MediaShareController.sharedInstance.tvQueueMediaCollection.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        let item : Media = MediaShareController.sharedInstance.tvQueueMediaCollection[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as!MediaCell
        cell.frame = CGRectMake(0, cell.frame.origin.y, collectionView.frame.size.width, cell.frame.height)
        cell.delMediabtn.tag = indexPath.row
        cell.titleTxt.text = item.mediaTitle
        cell.mImageView.image = nil
        cell.indicator.hidesWhenStopped = true
        ImageCacheHelper.downloadImageAtIndexPath(indexPath , mediaCollection: MediaShareController.sharedInstance.tvQueueMediaCollection, completionBlock: { (result: UIImage) in
            dispatch_async(dispatch_get_main_queue())
            {
                let cell1 =  collectionView.cellForItemAtIndexPath(indexPath) as? MediaCell
                if let cell2 = cell1
                {
                    cell2.mImageView.image = result
                    cell.indicator.hidesWhenStopped = true
                }
            }
        })
        if MediaShareController.sharedInstance.playType == "audio"{
            cell.mImageView.image = UIImage(named:"Music_Placeholder.png")!
        }
        else if MediaShareController.sharedInstance.playType == "video"{
            cell.mImageView.image = UIImage(named:"video_Placeholder.jpeg")!
        }
        else if MediaShareController.sharedInstance.playType == "photo"{
            cell.mImageView.image = UIImage(named:"image_Placeholder.png")!
        }
        return cell;
    }
    @IBAction func removeItemFromList(sender: AnyObject)
    {
        
        if MediaShareController.sharedInstance.playType == "photo"
        {
            let tag = sender.tag
            var imageUrl = MediaShareController.sharedInstance.tvQueueMediaCollection[tag].mediaimageUrl
            if imageUrl.containsString("_small") == true
            {
                let range = imageUrl.endIndex.advancedBy(-10)..<imageUrl.endIndex.advancedBy(-4)
                imageUrl.removeRange(range)
            }
            MediaShareController.sharedInstance.photoplayer?.removeFromList(NSURL(string: imageUrl)!)
        }
       if  MediaShareController.sharedInstance.playType == "audio"
       {
            let tag = sender.tag
            let audioUrl = MediaShareController.sharedInstance.tvQueueMediaCollection[tag].mediaUrl
            MediaShareController.sharedInstance.audioplayer?.removeFromList(NSURL(string: audioUrl)!)
        }
       if MediaShareController.sharedInstance.playType == "video"
       {
            let tag = sender.tag
            let videoUrl = MediaShareController.sharedInstance.tvQueueMediaCollection[tag].mediaUrl
            MediaShareController.sharedInstance.videoplayer?.removeFromList(NSURL(string: videoUrl)!)
        }
    }
}
