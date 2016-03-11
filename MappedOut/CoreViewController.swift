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

let userDidLogoutNotification = "userDidLogoutNotification"
class CoreViewController: UIViewController,UIViewControllerTransitioningDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let fadeInAnimator = TKFadeInAnimator()
        return fadeInAnimator
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

}
