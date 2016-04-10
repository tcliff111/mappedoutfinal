//
//  EventInviteViewController.swift
//  MappedOut
//
//  Created by Thomas Clifford on 4/1/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit

class EventInviteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var invitedUsers: [User] = []
    var user = User()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        
        
//        Event.getEventsbyIDs(<#T##ids: [String]##[String]#>, orderBy: <#T##String#>, success: <#T##([Event]) -> ()#>)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let eventsOwned = user.eventsOwned {
            return eventsOwned.count
        }
        else {
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventInviteTableViewCell", forIndexPath: indexPath) as! EventInviteTableViewCell
//        let event = user.eventsOwned![indexPath.row] as! Event
//        cell.eventName = event.name
        return cell
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
