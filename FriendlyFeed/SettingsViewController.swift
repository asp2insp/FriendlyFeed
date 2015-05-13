//
//  SettingsViewController.swift
//  FriendlyFeed
//
//  Created by Josiah Gaskin on 5/13/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation


class SettingsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, ReactorResponder {
    @IBOutlet weak var tableView: UITableView!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Set up right button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.Plain, target: self, action: "applySettings:")
        // Set up left button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "close:")
        
        self.navigationItem.title = "Settings"
        
        Reactor.instance.responder = self
    }
    
    func applySettings(sender: AnyObject) {
        
    }
    
    func onUpdate() {
        self.tableView.reloadData()
    }
    
    func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendlyfeed.settingstoggle") as! SettingsCell
        let setting = Reactor.instance.evaluate(FILTERS).getIn([indexPath.row])
        cell.labeltext.text = setting.getIn(["name"]).toSwift() as? String
        cell.toggle.on = setting.getIn(["enabled"]).toSwift() as! Bool
        cell.toggle.addTarget(cell, action: "toggleFilter:", forControlEvents: UIControlEvents.ValueChanged)
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SettingsCell
        let filterText = cell.labeltext.text!
        Reactor.instance.dispatch("toggleFilter", payload: filterText)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Reactor.instance.evaluate(FILTERS).count
    }
}

class SettingsCell : UITableViewCell {
    @IBOutlet weak var labeltext: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    var filterName : String = ""
    
    func toggleFilter(sender: AnyObject) {
//        if (sender as! UISwitch).on {
//            Reactor.instance.dispatch("toggleFilter", payload: filterName)
//        }
    }
}
