//
//  Event.swift
//  MappedOut
//
//  Created by Thomas Clifford on 3/10/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class Event: NSObject {
    
    //Not yet finished
    
    var name: String?
    var ownerName: String?
    var ownerID: String?
    var descript: String?
    var location: CLLocation?
    var attendanceCount: Int? = 0
//    var usersAttending: [String]?
    
    //Should be UIImage.  Store in Parse as PFFile
//    var picture: PFImageView?
    var date: NSDate?
    var id: String?
    var isPublic: Bool? = true
    var inviteID: String? = "empty"
    
    init(event: PFObject) {
        super.init()
        self.name = event["name"] as? String
        self.ownerName = event["ownerName"] as? String
        self.ownerID = event["ownerID"] as? String
        self.descript = event["description"] as? String
        let loc = event["location"] as? PFGeoPoint
        self.location = CLLocation(latitude: (loc?.latitude)!, longitude: (loc?.longitude)!)
        self.attendanceCount =  event["attendanceCount"] as? Int
//        self.usersAttending = event["usersAttending"] as? [String]
//        self.picture = event["picture"] as? PFImageView
        self.date = event["date"] as? NSDate
        self.id = event["id"] as? String
        self.isPublic = event["isPublic"] as? Bool
        
        //Still need inviteID
    }
//    init(name: String?, owner: User, description: String?, location: CLLocation?, picture: PFImageView?, date: NSDate?, isPublic: Bool) {
    init(name: String?, owner: User, description: String?, location: CLLocation?, date: NSDate?, isPublic: Bool) {

        super.init()
        self.name = name
        self.ownerName = owner.name
        self.ownerID = owner.id
//        self.usersAttending?.append(owner.id!)
        self.descript = description
        self.location = location
//        self.picture = picture
        self.date = date
        self.isPublic = isPublic
        self.attendanceCount!++
        Event.postEvent(self) { (success: Bool, error: NSError?) -> Void in
            if(success) {
                //Still must setup id and inviteID
                print("success")
            }
        }
    }
    
    class func postEvent(inputEvent: Event, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let event = PFObject(className: "Event")
        
        // Add relevant fields to the object
        
        event["name"] = inputEvent.name
        event["ownerName"] = inputEvent.ownerName
        event["ownerID"] = inputEvent.ownerID
        event["description"] = inputEvent.descript
        event["attendanceCount"] = inputEvent.attendanceCount
//        event["usersAttending"] = inputEvent.usersAttending
//        event["picture"] = inputEvent.picture
        event["date"] = inputEvent.date
//        event["id"] = inputEvent.id
        event["isPublic"] = inputEvent.isPublic
        event["inviteID"] = inputEvent.inviteID
        
        let point = PFGeoPoint(location: inputEvent.location)
        event["location"] = point
        
        // Save object (following function will save the object in Parse asynchronously)
        event.saveInBackgroundWithBlock(completion)
    }
    
    class func getNearbyEvents(currentLocation: CLLocation, orderBy: String, success: ([Event])->()) {
        
        let query = PFQuery(className: "Event")
        let loc = PFGeoPoint(location: currentLocation)
        
        query.whereKey("location", nearGeoPoint: loc, withinMiles: 2)
        query.orderByDescending(orderBy)
        
        query.findObjectsInBackgroundWithBlock { (events: [PFObject]?, error: NSError?) -> Void in
            if let events = events {
                var eventsArray: [Event] = []
                for event in events {
                    eventsArray.append(Event(event: event))
                }
                
                success(eventsArray)
            } else {
                print(error)
            }
        }
    }
    
    class func deleteEvent(event: Event, success: ()->()) {
        let query = PFQuery(className: "Event")
        //Also must delete event from any Events arrays
        query.getObjectInBackgroundWithId(event.id!) {
            (parseEvent: PFObject?, error: NSError?) -> Void in
            if error == nil && parseEvent != nil {
                parseEvent?.deleteEventually()
                success()
            } else {
                print(error)
            }
        }
    }
    
    class func addAttendee(user: User, event: Event) {
        //Does not account for the user side
        event.attendanceCount!++
//        event.usersAttending?.append(user.id!)
    }
    
}
