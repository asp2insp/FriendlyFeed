//
//  FeedViewController.swift
//  FriendlyFeed
//
//  Created by Josiah Gaskin on 5/11/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation
let manager = AFHTTPRequestOperationManager()

class FeedViewController : UIViewController, ReactorResponder, UICollectionViewDataSource {
    let reactor = Reactor.instance

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.registerClass(StatusCell.self, forCellWithReuseIdentifier: "friendlyfeed.status")
        collectionView.registerClass(PhotoCell.self, forCellWithReuseIdentifier: "friendlyfeed.photo")
        
        reactor.responder = self
        self.refreshDataFromServer()
    }
    
    func refreshDataFromServer() {
        if FBSDKAccessToken.currentAccessToken() != nil {
            FBSDKGraphRequest(graphPath: "me/feed", parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
                if error == nil {
                    self.reactor.dispatch("setData", payload: result)
                }
            })
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("About to show \(reactor.evaluate(FEED).count) items")
        return reactor.evaluate(FEED).count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let post = reactor.evaluate(FEED).getIn([indexPath.row])
        if let message = post.getIn(["message"]).toSwift() as? String {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("friendlyfeed.status", forIndexPath: indexPath) as! StatusCell
            cell.message.text = message
            cell.message.textColor = UIColor.whiteColor()
            cell.backgroundColor = UIColor.redColor()
            return cell
        } else if let message = post.getIn(["picture"]).toSwift() as? String {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("friendlyfeed.photo", forIndexPath: indexPath) as! PhotoCell
            cell.backgroundColor = UIColor.blueColor()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("friendlyfeed.status", forIndexPath: indexPath) as! StatusCell
            cell.message.text = "Unknown"
            return cell
        }
    }
    
    func onUpdate() {
        collectionView.reloadData()
    }
}

// friendlyfeed.status
class StatusCell : UICollectionViewCell {
    var message: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.message = UILabel()
        message.center = contentView.center
        contentView.addSubview(message)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}

// friendlyfeed.photo
class PhotoCell : UICollectionViewCell {
    var picture: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.picture = UIImageView()
        picture.center = contentView.center
        contentView.addSubview(picture)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
