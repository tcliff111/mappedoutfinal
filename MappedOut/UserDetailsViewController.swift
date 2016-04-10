//
//  UserDetailsViewController.swift
//  MappedOut
//
//  Created by Quintin Frerichs on 3/26/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var isFriendLabel: UILabel!
    
    var user: User?
    let friendsEvents = ["Event1", "TestClass", "Rager", "Settler"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        if user != nil{
            usernameLabel.text = user?.username
            profilePictureView.image = user?.propic
            
            
        }
        // Do any additional setup after loading the view.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return friendsEvents.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("UserTableViewCell", forIndexPath: indexPath) as! UserTableViewCell
        cell.eventNameLabel.text = friendsEvents[indexPath.row]
        return cell
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDone(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
