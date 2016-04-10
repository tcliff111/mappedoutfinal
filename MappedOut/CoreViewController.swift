//
//  CoreViewController.swift
//  MappedOut
//
//  Created by 吕凌晟 on 16/3/9.
//  Copyright © 2016年 Codepath. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import SwiftyDrop
import TKSubmitTransition
import BubbleTransition
import FSCalendar
import DateSuger

let userDidLogoutNotification = "userDidLogoutNotification"
class CoreViewController: UIViewController,UIViewControllerTransitioningDelegate,FSCalendarDataSource,FSCalendarDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var transitionButton: UIButton!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var AvatarImage: UIImageView!
    
    
    
    let transition = BubbleTransition()
    var events : [Event]?
    var filteredevent : [Event]?
    var selectedDate : NSDate = NSDate()
    override func viewDidLoad() {
        super.viewDidLoad()
        AvatarImage.layer.cornerRadius = 40
        AvatarImage.clipsToBounds = true
        //transitionButton.layer.cornerRadius = 25
        //transitionButton.clipsToBounds = true
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.scope = .Week
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CoreViewController.needRelaod), name: userDidCreatenewNotification, object: nil)

//        let user = User()
//        user.addAttendingEvents("3333333")
        
        
//        let location = CLLocation(latitude: 38.6488705, longitude: -90.3114517)
//        let date = NSDate()
//        let pic = UIImage(named: "camera_edit")
//        event = Event(name: "Test Class", owner: user, description: "testtesttest", location: location, picture: pic, date: date, isPublic: true)
        let user = User()
        let eventattendinglist = user.eventsAttending
        //print(eventattendinglist)
        if(eventattendinglist != nil){
        Event.getEventsbyIDs(eventattendinglist!, orderBy: "createdAt") { (events:[Event]) in
            self.events=events
            self.filteredevent?.removeAll()
            for event in events{
                print(event.startDate?.isSameDay(NSDate()))
                if (event.startDate?.isSameDay(NSDate()) == true && self.filteredevent != nil){
                    self.filteredevent?.append(event)
                }
                if (event.startDate?.isSameDay(NSDate()) == true && self.filteredevent == nil){
                    self.filteredevent = [event]
                }
            }
            //print(self.filteredevent)
            self.tableView.reloadData()
        }
        }
        
    }
    
    func needRelaod(){
        print("havereload")
        PFUser.currentUser()?.fetchInBackground()
        self.filteredevent?.removeAll()
        
        let user = User()
        let eventattendinglist = user.eventsAttending
        //print(eventattendinglist)
        Event.getEventsbyIDs(eventattendinglist!, orderBy: "createdAt") { (events:[Event]) in
            self.events=events
            self.filteredevent?.removeAll()
            for event in events{
                print(event.startDate?.isSameDay(NSDate()))
                if (event.startDate?.isSameDay(NSDate()) == true && self.filteredevent != nil){
                    self.filteredevent?.append(event)
                }
                if (event.startDate?.isSameDay(NSDate()) == true && self.filteredevent == nil){
                    self.filteredevent = [event]
                }
            }
            //print(self.filteredevent)
            self.tableView.reloadData()
        }

        
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func minimumDateForCalendar(calendar: FSCalendar!) -> NSDate! {
        return calendar.dateWithYear(2015, month: 2, day: 1)
    }
    
    func maximumDateForCalendar(calendar: FSCalendar!) -> NSDate! {
        return calendar.dateWithYear(2050, month: 2, day: 1)
    }
    
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        self.filteredevent?.removeAll()
        
        self.selectedDate = date
        for originalevent in events!{
            print(originalevent.startDate!)
            print("Today", date)
            print(originalevent.startDate!.isSameDay(date))
            
            
            
            if (originalevent.startDate?.isSameDay(date) == true && self.filteredevent != nil){
                self.filteredevent!.append(originalevent)
            }
            if (originalevent.startDate?.isSameDay(date) == true && self.filteredevent == nil){
                self.filteredevent = [originalevent]
            }
        }
        print(calendar.stringFromDate(date))
        print(self.filteredevent)
        

        self.tableView.reloadData()
        
        
    }
    
    
    
    
    @IBAction func onLogout(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()! as! loginViewController
//        self.presentViewController(vc, animated: true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
        PFUser.logOut()
        User.logOut()
        Drop.down("Logout Successfully", state: .Info, duration: 4, action: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredevent != nil{
            return filteredevent!.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Eventcell", forIndexPath: indexPath) as! EventsCell
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm" //format style. Browse online to get a format that fits your needs.
        var dateString = dateFormatter.stringFromDate(filteredevent![indexPath.row].startDate!)
        print(filteredevent![indexPath.row].name)
        cell.EventName.text = filteredevent![indexPath.row].name
        
        cell.EventTime.text = dateString
        //cell.EventLocation.text = events![indexPath.row].location
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = transitionButton.center
        transition.bubbleColor = transitionButton.backgroundColor!
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = transitionButton.center
        transition.bubbleColor = transitionButton.backgroundColor!
        return transition
    }


}
