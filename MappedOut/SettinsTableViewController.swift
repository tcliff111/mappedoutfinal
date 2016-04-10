//
//  SettinsTableViewController.swift
//  MappedOut
//
//  Created by Quintin Frerichs on 4/3/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import Parse
import ParseUI
let isLocationNotificationTrue = "isLocationNotificationTrue"
let isLocationNotificationFalse = "isLocationNotificationFalse"
class SettinsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var chosenProfilePicture: UIImage?
    @IBOutlet weak var profilePictureView: UIImageView!
    
    @IBOutlet weak var locationSwitch: UISwitch!
    
    @IBOutlet weak var notificationsSwitch: UISwitch!

    //let user = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        //if(user.propic != nil){
            //profilePictureView.image = user.propic
       // }
        
        locationSwitch.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func stateChanged(switchState: UISwitch){
        if locationSwitch.on{
            print("Switch is on")
            NSNotificationCenter.defaultCenter().postNotificationName("isLocationNotificationTrue", object: nil)
           
        }
        else{
            NSNotificationCenter.defaultCenter().postNotificationName("isLocationNotificationFalse", object: nil)
        }
    }
    

    @IBAction func onProfilePicture(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(vc, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            chosenProfilePicture = pickedImage
            //user.updateProfile(user.name, picture: pickedImage)
            profilePictureView.contentMode = .ScaleAspectFit
            profilePictureView.image = pickedImage
            
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func onLogout(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
        PFUser.logOut()
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
