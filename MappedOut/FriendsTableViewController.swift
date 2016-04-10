//
//  FriendsTableViewController.swift
//  MappedOut
//
//  Created by Thomas Clifford on 3/29/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import Parse

class FriendsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    //Image: https://thenounproject.com/search/?q=invite&i=161161
    
    var friends: [User] = []
    var followers: [User] = []
    var filteredFriends: [User] = []
    var selectedUsers: [User] = []

    @IBOutlet var addFriendButton: UIBarButtonItem!
    @IBOutlet var friendsInviteButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var eventInviteButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    var user: User?
    var searchBar: UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchBar = UISearchBar()
        searchBar!.sizeToFit()
        self.tableView.tableHeaderView = searchBar
        searchBar!.barStyle = .Default
        searchBar!.delegate = self
        
        user = User()
        
        user!.getFriends { (friends) -> () in
            self.friends = friends
            self.filteredFriends = friends
            self.tableView.reloadData()
        }
        
        user!.getFollowers { (followers) -> () in
            self.followers = followers
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredFriends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("HEY")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendTableViewCell", forIndexPath: indexPath) as! FriendTableViewCell
        
        let cellUser = filteredFriends[indexPath.row]
        
        cell.name.text = cellUser.name
        
        cell.username.text = cellUser.username
        if let propic = cellUser.propic {
            cell.propic.image = propic
        }
        
        return cell
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        print("begin1")
        
        filteredFriends = friends
        tableView.reloadData()
    }
    
    //resigns first responser
    //text = ""
    //searchbar.hidden = true
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == "") {
            if (segmentedControl.selectedSegmentIndex == 0) {
                filteredFriends = friends
            }
            else if (segmentedControl.selectedSegmentIndex == 1) {
                filteredFriends = followers
            }
            
            tableView.reloadData()
        }
        else {
            if (segmentedControl.selectedSegmentIndex == 0) {
                filteredFriends = friends.filter({ (dataItem: User) -> Bool in
                    if((dataItem.username?.rangeOfString(searchText, options: .CaseInsensitiveSearch, range: nil, locale: nil)) != nil) {
                        
                        return true
                    }
                    else {
                        
                        return false
                    }
                })
            }
            else if (segmentedControl.selectedSegmentIndex == 1) {
                filteredFriends = followers.filter({ (dataItem: User) -> Bool in
                    if((dataItem.username?.rangeOfString(searchText, options: .CaseInsensitiveSearch, range: nil, locale: nil)) != nil) {
                        
                        return true
                    }
                    else {
                        
                        return false
                    }
                })
            }
            
            tableView.reloadData()
            
//            let range = NSMakeRange(0, self.tableView.numberOfSections)
//            let sections = NSIndexSet(indexesInRange: range)
//            self.tableView.reloadSections(sections, withRowAnimation: .Fade)
            
            
        }
    }
    
    @IBAction func onEventsInvite(sender: AnyObject) {
//        let selectedIndexPaths = tableView.indexPathsForSelectedRows
//        if let selectedIndexPaths = selectedIndexPaths {
//            var selectedUsers: [User] = []
//            for indexPath in selectedIndexPaths {
//                selectedUsers.append(filteredFriends[indexPath.row])
//            }
//        }
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.tableView.setEditing(false, animated: true)
        self.updateButtons()
        selectedUsers = []
        tableView.reloadData()
    }
    @IBAction func onFriendsInvite(sender: AnyObject) {
        self.tableView.setEditing(true, animated: true)
        self.updateButtons()
    }
    
    func updateButtons() {
        if (self.tableView.editing == true) {
            navigationItem.rightBarButtonItem = self.eventInviteButton
            navigationItem.leftBarButtonItem = self.cancelButton
        }
        else {
            navigationItem.rightBarButtonItem = self.addFriendButton
            navigationItem.leftBarButtonItem = self.friendsInviteButton
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedUsers.append(filteredFriends[indexPath.row])
        print("selected")
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        selectedUsers = selectedUsers.filter() { $0 !== filteredFriends[indexPath.row] }
        print("deselected")
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cellUser = filteredFriends[indexPath.row]
        
        if(selectedUsers.contains(cellUser)) {
//            cell.setSelected(true, animated: false)
            tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Top)
        }
        else{
//            cell.setSelected(false, animated: false)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EventInviteSegue" {
            if let destination = segue.destinationViewController as? EventInviteViewController {
                destination.invitedUsers = selectedUsers
            }
        }
    }
    
    @IBAction func segmentedControlAction(sender: AnyObject) {
        if (segmentedControl.selectedSegmentIndex == 0) {
            
            if(searchBar?.text == "") {
                filteredFriends = friends
            }
            else {
                filteredFriends = friends.filter({ (dataItem: User) -> Bool in
                    if((dataItem.username?.rangeOfString((searchBar?.text)!, options: .CaseInsensitiveSearch, range: nil, locale: nil)) != nil) {
                        
                        return true
                    }
                    else {
                        
                        return false
                    }
                })
            }
            
            tableView.reloadData()
        }
        else if (segmentedControl.selectedSegmentIndex == 1) {
            
            if(searchBar?.text == "") {
                filteredFriends = followers
            }
            else {
                filteredFriends = followers.filter({ (dataItem: User) -> Bool in
                    if((dataItem.username?.rangeOfString((searchBar?.text)!, options: .CaseInsensitiveSearch, range: nil, locale: nil)) != nil) {
                        
                        return true
                    }
                    else {
                        
                        return false
                    }
                })
            }
            tableView.reloadData()
        }
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
