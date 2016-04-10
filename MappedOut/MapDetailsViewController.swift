//
//  MapDetailsViewController.swift
//  MappedOut
//
//  Created by Quintin Frerichs on 3/19/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import Parse
class MapDetailsViewController: UIViewController {
    @IBOutlet weak var eventProfilePicture: UIImageView!
    @IBOutlet weak var eventDistance: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    let attendees = [User]()
    let nameArray = ["Hillary", "Barack", "Donald", "Quintin"]
    var event: Event?
    var namesOfAttendees: [String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(event != nil){
            eventNameLabel.text = event!.name
            eventDescription.text = event!.descript
            eventProfilePicture.image = event!.picture
            let compareFromPoint = CLLocation(latitude: 38.6480, longitude: -90.3050)
            let compareToPoint = CLLocation(latitude: event!.location!.coordinate.latitude, longitude: event!.location!.coordinate.longitude)
            let distance = compareFromPoint.distanceFromLocation(compareToPoint)
            let convertedDistance = round((distance/1609.34)*100)/100
            eventDistance.text = "\(convertedDistance) mi"
        }
        
       
    }
    @IBAction func onDismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
