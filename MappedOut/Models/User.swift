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

class User: NSObject {

    //Not yet finished.  Currently hard-coded.
    
    var name: String?
    var username: String?
    var propic: PFImageView?
    var eventsAttending: [String]?
    var eventsOwned: [String]?
    var location: CLLocation?
    var friendNames: [String]?
    var friendIDs: [String]?
    var id: String?
    

//    init(user: PFUser) {
    override init() {
        super.init()
//        self.username = user["username"] as! String
        self.username = "johnny"
        self.name = "John"
        self.id = "23u4huhrh"
    }
    
    
    
    
}
