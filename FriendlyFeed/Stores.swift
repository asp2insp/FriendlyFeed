//
//  Stores.swift
//  FriendlyFeed
//
//  Created by Josiah Gaskin on 5/11/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation

// ID: feed
public class FeedDataStore : Store {
    override func getInitialState() -> Immutable.State {
        return Immutable.toState([:])
    }
    
    override func initialize() {
        self.on("setData", handler: {(state, payload, action) -> Immutable.State in
            return Immutable.toState(payload as! AnyObject)
        })
    }
}

let FEED = Getter(keyPath: ["feed", "data"])