//
//  CoreViewController.swift
//  MappedOut
//
//  Created by 吕凌晟 on 16/3/9.
//  Copyright © 2016年 Codepath. All rights reserved.
//

import UIKit
import Parse
import SwiftyDrop
import TKSubmitTransition
import BubbleTransition
import FSCalendar

let userDidLogoutNotification = "userDidLogoutNotification"
class CoreViewController: UIViewController,UIViewControllerTransitioningDelegate,FSCalendarDataSource,FSCalendarDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var transitionButton: UIButton!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var AvatarImage: UIImageView!
    let transition = BubbleTransition()
    
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
        print(calendar.stringFromDate(date))
    }
    
    
    @IBAction func onLogout(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()! as! loginViewController
//        self.presentViewController(vc, animated: true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
        PFUser.logOut()
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
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Eventcell", forIndexPath: indexPath) as! EventsCell
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
