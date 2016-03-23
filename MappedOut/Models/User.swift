//
//  User.swift
//  MappedOut
//
//  Created by Thomas Clifford on 3/10/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class User: PFUser {

    //Not yet finished
    
    //User inherits the properties username, password, and objectId from PFUser
    
    var name: String?
    var propic: UIImage?
    var eventsAttending: [String]?
    var eventsOwned: [String]?
    var location: CLLocation?
    var friendsCount: Int = 0
    var friendNames: [String]? {
        didSet{
            friendsCount = (friendNames?.count)!
        }
    }
    var friendIDs: [String]?
    
    
    override init() {
        super.init()
    }
    
    //User inherits the functions login() and register() from PFUser
    
//    override func login() {
//        super.login()
        
//    }
    

    func updateProfile(name: String?, picture: UIImage?) {
        if let name = name {
            self.name = name
        }
        if let picture = picture {
            self.propic = picture
        }
    }
    
    func addFriend() {
        
    }
    
    func getFriends() {
        
    }
    
    func searchUsers(usernameSubstring: String) -> [User]? {
        
        let users: [User] = []
        return users
    }
    
    
}
