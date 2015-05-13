//
//  FeedViewController.swift
//  FriendlyFeed
//
//  Created by Josiah Gaskin on 5/11/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation
let manager = AFHTTPRequestOperationManager()

class FeedViewController : UIViewController, ReactorResponder, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 20.0, right: 10.0)
    let reactor = Reactor.instance

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.registerNib(UINib(nibName:"StatusCell", bundle: nil), forCellWithReuseIdentifier: "friendlyfeed.status")
        collectionView.registerNib(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "friendlyfeed.photo")
        
        reactor.responder = self
        self.refreshDataFromServer()
    }
    
    func refreshDataFromServer() {
        if FBSDKAccessToken.currentAccessToken() != nil {
            FBSDKGraphRequest(graphPath: "me/feed", parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
                if error == nil {
                    self.reactor.dispatch("setData", payload: result)
                } else {
                    self.reactor.dispatch("setData", payload: [
                        "data": [
                            ["message": "Dummy item 1"],
                            ["message": "Dummy item 2"],
                            ["message": "Dummy item 3"],
                            ["picture": "http://www.example.com/image.png"],
                            ["message": "Dummy item 4"],
                            ["message": "Dummy item 5"]
                        ]
                    ])
                }
            })
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("About to show \(reactor.evaluate(FEED).count) items")
        return reactor.evaluate(FEED).count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if let message = reactor.evaluate(FEED)
                .getIn([indexPath.row])
                .getIn(["message"])
                .toSwift() as? String {
            return CGSize(width: 260, height: 100)
        } else {
            return CGSize(width: 150, height: 200)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let post = reactor.evaluate(FEED).getIn([indexPath.row])
        if let message = post.getIn(["message"]).toSwift() as? String {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("friendlyfeed.status", forIndexPath: indexPath) as! StatusCell
            cell.message.text = message
            return cell
        } else if let message = post.getIn(["picture"]).toSwift() as? String {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("friendlyfeed.photo", forIndexPath: indexPath) as! PhotoCell
            let url = NSURL(string: message)
            cell.picture.setImageWithURL(url)
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