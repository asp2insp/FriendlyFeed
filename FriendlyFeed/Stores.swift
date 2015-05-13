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

// ID: ui
public class UIDataStore : Store {
    override func getInitialState() -> Immutable.State {
        return Immutable.toState([
            "filters": [
                ["name":"Links", "enabled":true],
                ["name":"Statuses", "enabled":true],
                ["name":"Photos", "enabled":true],
                ["name":"Video", "enabled":true]
            ]
        ])
    }
    
    override func initialize() {
        self.on("toggleFilter", handler: {(state, payload, action) -> Immutable.State in
            let targetFilterName = payload as! String
            return state.mutateIn(["filters"], withMutator: {(filters) -> Immutable.State in
                let current = filters!
                return current.map({(filter, i) -> Immutable.State in
                    let name = filter.getIn(["name"]).toSwift() as! String
                    return filter.setIn(["enabled"], withValue: Immutable.toState(name == targetFilterName))
                })
            })
        })
    }
}

let FILTERS = Getter(keyPath: ["ui", "filters"])

let FEED = Getter(keyPath: ["feed", "data"])